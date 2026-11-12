
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:maalmitra/presentation/screens/HomePages/manufacturer_home_page.dart';
import '../../../data/controllers/manufacturer_registration_controller.dart';
import '../../../core/storage/colors.dart';
import '../../../core/constants/app url.dart';
import '../Registration/manufacturer_registration_screen.dart';
const Color _backgroundColor = Color(0xFFF7F7F7);
const Color _textColor = Color(0xFF263238);
const Color _mutedColor = Color(0xFF757575);

String _manufacturerMediaUrl(String path) {
  if (path.trim().isEmpty) return '';
  final base = AppUrl.baseUrl.replaceFirst(RegExp(r'/user/?$'), '');
  final parsed = Uri.tryParse(path);
  if (parsed != null && parsed.hasScheme) {
    final baseUri = Uri.tryParse(base);
    if (baseUri != null &&
        (parsed.host == 'localhost' || parsed.host == '127.0.0.1')) {
      return parsed.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : parsed.port,
      ).toString();
    }
    return path;
  }
  return '$base${path.startsWith('/') ? path : '/$path'}';
}

Future<void> _openStatusDocument(String value) async {
  final uri = Uri.tryParse(_manufacturerMediaUrl(value));
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    Get.snackbar('Error', 'Invalid document URL.');
    return;
  }

  try {
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened) {
      Get.snackbar('Error', 'Unable to open the document.');
    }
  } catch (e) {
    Get.snackbar('Error', 'Unable to open the document: $e');
  }
}

/// Manufacturer registration pending screen.
class ManufacturerPendingScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const ManufacturerPendingScreen({
    super.key,
    required this.profile,
  });

  @override
  State<ManufacturerPendingScreen> createState() =>
      _ManufacturerPendingScreenState();
}

class _ManufacturerPendingScreenState extends State<ManufacturerPendingScreen> {
  late final ManufacturerRegistrationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ManufacturerRegistrationController>()
        ? Get.find<ManufacturerRegistrationController>()
        : Get.put(ManufacturerRegistrationController());
  }

  Future<void> _refreshRegistrationStatus() async {
    final latestProfile = await controller.fetchManufacturerStatus();
    if (!mounted) return;

    if (latestProfile == null) {
      final message = controller.errorMessage.value.isNotEmpty
          ? controller.errorMessage.value
          : 'Unable to refresh registration status. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    final profile = <String, dynamic>{
      ...widget.profile,
      ...latestProfile,
    };
    final status = (latestProfile['registration_status'] ??
            latestProfile['status'] ??
            '')
        .toString()
        .trim()
        .toLowerCase();

    if (status == 'approved') {
      Get.offAll(() => const ManufacturerHomePage());
    } else if (status == 'rejected') {
      Get.offAll(() => ManufacturerRejectedScreen(profile: profile));
    } else if (status == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your registration is still pending admin approval.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The server returned an unknown registration status.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _mediaUrl(String path) {
    if (path.isEmpty) return '';

    final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
      RegExp(r'/user/?$'),
      '',
    );

    final parsedUri = Uri.tryParse(path);
    if (parsedUri != null && parsedUri.hasScheme) {
      final baseUri = Uri.tryParse(serverBaseUrl);

      if (baseUri != null &&
          (parsedUri.host == '127.0.0.1' ||
              parsedUri.host == 'localhost')) {
        return parsedUri.replace(
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : parsedUri.port,
          scheme: baseUri.scheme,
        ).toString();
      }
      return path;
    }

    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$serverBaseUrl$normalizedPath';
  }

  Widget _documentCard(String title, dynamic document) {
    final rawPath = document?.toString().trim() ?? '';
    final hasDocument =
        rawPath.isNotEmpty && rawPath.toLowerCase() != 'null';

    if (!hasDocument) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: colours.primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$title: Document not available',
                style: const TextStyle(color: _mutedColor, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final url = _mediaUrl(rawPath);
    final uri = Uri.tryParse(url);
    final path = (uri?.path ?? url).toLowerCase();
    final isImage = RegExp(r'\.(jpg|jpeg|png|webp|gif)$').hasMatch(path);
    final fileName = (uri?.path ?? rawPath).split('/').last;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                path.endsWith('.pdf')
                    ? Icons.picture_as_pdf_outlined
                    : Icons.description_outlined,
                color: colours.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isImage)
            InkWell(
              onTap: () => _openStatusDocument(url),
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                url,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                    'Manufacturer document image error ($title): $error',
                  );
                  return Text(
                    'Unable to load image: $fileName',
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  );
                },
                ),
              ),
            )
          else
            InkWell(
              onTap: () => _openStatusDocument(url),
              borderRadius: BorderRadius.circular(8),
              child: Row(
              children: [
                Icon(
                  path.endsWith('.pdf')
                      ? Icons.picture_as_pdf
                      : Icons.insert_drive_file_outlined,
                  color: colours.primaryColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    fileName.isEmpty ? title : fileName,
                    style: const TextStyle(
                      color: _mutedColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final categories = profile['product_categories'];

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Registration Status',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: colours.primaryColor,
        foregroundColor: colours.foregroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandHeader(),
              const SizedBox(height: 18),
              _StatusHeader(
                icon: Icons.hourglass_top_rounded,
                color: colours.primaryColor,
                title: 'Registration Pending',
                message:
                    'Your manufacturer registration is waiting for admin approval.',
              ),
              const SizedBox(height: 16),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: controller.isCheckingStatus.value
                          ? null
                          : _refreshRegistrationStatus,
                      icon: controller.isCheckingStatus.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.refresh_rounded),
                      label: Text(controller.isCheckingStatus.value
                          ? 'Checking Status...'
                          : 'Refresh Status'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colours.primaryColor,
                        foregroundColor: colours.buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              _sectionTitle('Company Details'),
              _detailCard([
                _DetailRow(
                  label: 'Company Name',
                  value: profile['company_name'],
                ),
                _DetailRow(
                  label: 'GST Number',
                  value: profile['gst_number'],
                ),
                _DetailRow(
                  label: 'Registration Number',
                  value: profile['company_registration_number'],
                ),
                _DetailRow(
                  label: 'Year Established',
                  value: profile['year_of_establishment'],
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Contact Details'),
              _detailCard([
                _DetailRow(
                  label: 'Contact Person',
                  value: profile['contact_person_name'],
                ),
                _DetailRow(
                  label: 'Mobile Number',
                  value: profile['mobile_number'],
                ),
                _DetailRow(
                  label: 'Email Address',
                  value: profile['email_address'],
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Factory Address'),
              _detailCard([
                _DetailRow(
                  label: 'Address',
                  value: profile['factory_address'],
                ),
                _DetailRow(
                  label: 'City',
                  value: profile['city'],
                ),
                _DetailRow(
                  label: 'State',
                  value: profile['state'],
                ),
                _DetailRow(
                  label: 'PIN Code',
                  value: profile['pin_code'],
                ),
                _DetailRow(
                  label: 'Country',
                  value: profile['country'],
                ),
                _DetailRow(
                  label: 'Product Categories',
                  value: categories is List
                      ? categories.join(', ')
                      : categories,
                ),
              ]),
              const SizedBox(height: 20),
              _ManufacturerDocumentsSection(profile: profile),
              const SizedBox(height: 24),
             
            ],
          ),
        ),
      ),
    );
  }
}

/// Manufacturer registration rejected screen.
class ManufacturerRejectedScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ManufacturerRejectedScreen({
    super.key,
    required this.profile,
  });

  String _mediaUrl(String path) {
    if (path.isEmpty) return '';

    final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
      RegExp(r'/user/?$'),
      '',
    );

    final parsedUri = Uri.tryParse(path);
    if (parsedUri != null && parsedUri.hasScheme) {
      final baseUri = Uri.tryParse(serverBaseUrl);

      if (baseUri != null &&
          (parsedUri.host == '127.0.0.1' ||
              parsedUri.host == 'localhost')) {
        return parsedUri.replace(
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : parsedUri.port,
          scheme: baseUri.scheme,
        ).toString();
      }
      return path;
    }

    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$serverBaseUrl$normalizedPath';
  }

  Widget _documentCard(String title, dynamic document) {
    final rawPath = document?.toString().trim() ?? '';
    final hasDocument =
        rawPath.isNotEmpty && rawPath.toLowerCase() != 'null';

    if (!hasDocument) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(Icons.description_outlined, color: colours.primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$title: Document not available',
                style: const TextStyle(color: _mutedColor, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final url = _mediaUrl(rawPath);
    final uri = Uri.tryParse(url);
    final path = (uri?.path ?? url).toLowerCase();
    final isImage = RegExp(r'\.(jpg|jpeg|png|webp|gif)$').hasMatch(path);
    final fileName = (uri?.path ?? rawPath).split('/').last;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                path.endsWith('.pdf')
                    ? Icons.picture_as_pdf_outlined
                    : Icons.description_outlined,
                color: colours.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: _textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isImage)
            InkWell(
              onTap: () => _openStatusDocument(url),
              borderRadius: BorderRadius.circular(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                url,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint(
                    'Manufacturer document image error ($title): $error',
                  );
                  return Text(
                    'Unable to load image: $fileName',
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  );
                },
                ),
              ),
            )
          else
            InkWell(
              onTap: () => _openStatusDocument(url),
              borderRadius: BorderRadius.circular(8),
              child: Row(
              children: [
                Icon(
                  path.endsWith('.pdf')
                      ? Icons.picture_as_pdf
                      : Icons.insert_drive_file_outlined,
                  color: colours.primaryColor,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectableText(
                    fileName.isEmpty ? title : fileName,
                    style: const TextStyle(
                      color: _mutedColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reason = (profile['rejection_reason'] ?? '').toString().trim();
    final categories = profile['product_categories'];

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Registration Status',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: colours.primaryColor,
        foregroundColor: colours.foregroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandHeader(),
              const SizedBox(height: 18),
              _StatusHeader(
                icon: Icons.cancel_outlined,
                color: Colors.red,
                title: 'Registration Rejected',
                message: 'Your manufacturer registration was not approved. Please review the reason below.',
              ),
              const SizedBox(height: 24),
              _sectionTitle('Rejection Reason'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD4D4)),
                ),
                child: Text(
                  reason.isNotEmpty
                      ? reason
                      : 'No rejection reason was provided. Please contact the administrator.',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFFB42318),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('Company Details'),
              _detailCard([
                _DetailRow(label: 'Company Name', value: profile['company_name']),
                _DetailRow(label: 'GST Number', value: profile['gst_number']),
                _DetailRow(label: 'Company Registration Number', value: profile['company_registration_number']),
                _DetailRow(label: 'Year of Establishment', value: profile['year_of_establishment']),
                _DetailRow(label: 'Company Landline Number', value: profile['company_landline_number']),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Contact Person Details'),
              _detailCard([
                _DetailRow(label: 'Contact Person Name', value: profile['contact_person_name']),
                _DetailRow(label: 'Mobile Number', value: profile['mobile_number']),
                _DetailRow(label: 'Email Address', value: profile['email_address']),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Factory and Business Details'),
              _detailCard([
                _DetailRow(label: 'Factory Address', value: profile['factory_address']),
                _DetailRow(label: 'City', value: profile['city']),
                _DetailRow(label: 'State', value: profile['state']),
                _DetailRow(label: 'PIN Code', value: profile['pin_code']),
                _DetailRow(label: 'Country', value: profile['country']),
                _DetailRow(
                  label: 'Product Categories',
                  value: categories is List ? categories.join(', ') : categories,
                ),
              ]),
              const SizedBox(height: 20),
              _ManufacturerDocumentsSection(profile: profile),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAll(() => const ManufacturerRegistrationScreen()),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Register Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.primaryColor,
                    foregroundColor: colours.buttonTextColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'You can start the registration process again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: _mutedColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManufacturerDocumentsSection extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _ManufacturerDocumentsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final documents = <_ManufacturerDocumentItem>[
      _ManufacturerDocumentItem(
        label: 'Company Registration Certificate',
        value: profile['company_registration_certificate'],
        icon: Icons.description_outlined,
      ),
      _ManufacturerDocumentItem(
        label: 'GST Certificate',
        value: profile['gst_certificate'],
        icon: Icons.receipt_long_outlined,
      ),
      _ManufacturerDocumentItem(
        label: 'Business Address Proof',
        value: profile['business_address_proof'],
        icon: Icons.location_on_outlined,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Uploaded Documents'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              for (int i = 0; i < documents.length; i++) ...[
                _ManufacturerDocumentRow(document: documents[i]),
                if (i < documents.length - 1) const Divider(height: 24),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ManufacturerDocumentItem {
  final String label;
  final dynamic value;
  final IconData icon;

  const _ManufacturerDocumentItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _ManufacturerDocumentRow extends StatelessWidget {
  final _ManufacturerDocumentItem document;

  const _ManufacturerDocumentRow({required this.document});

  String _fileName(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return Uri.decodeComponent(uri.pathSegments.last);
    }
    return url.split('/').last;
  }

  @override
  Widget build(BuildContext context) {
    final rawUrl = (document.value ?? '').toString().trim();
    final hasDocument = rawUrl.isNotEmpty && rawUrl.toLowerCase() != 'null';
    final url = hasDocument ? _manufacturerMediaUrl(rawUrl) : '';
    final lowerPath = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    final isPdf = lowerPath.endsWith('.pdf');
    final icon = isPdf ? Icons.picture_as_pdf_outlined : document.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasDocument ? () => _openStatusDocument(url) : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colours.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: colours.primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF263238),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      hasDocument ? _fileName(url) : 'Document not uploaded',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: hasDocument
                            ? const Color(0xFF757575)
                            : const Color(0xFFB42318),
                      ),
                    ),
                    if (hasDocument) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Tap to open file',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (hasDocument)
                Icon(Icons.open_in_new_rounded,
                    color: colours.primaryColor, size: 20)
              else
                const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// MaalMitra wordmark using the application's shared colour palette.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colours.primaryColor.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Maal',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      color: colours.logoColor,
                      letterSpacing: -1.0,
                    ),
                  ),
                  TextSpan(
                    text: 'Mitra',
                    style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      color: colours.primaryColor,
                      letterSpacing: -1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Connecting businesses and transport',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: _mutedColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared status header used by both screens.
class _StatusHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _StatusHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 38,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: _mutedColor,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _textColor,
      ),
    ),
  );
}

Widget _detailCard(List<_DetailRow> details) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        for (int i = 0; i < details.length; i++) ...[
          details[i],
          if (i < details.length - 1)
            const Divider(height: 22),
        ],
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue =
        value == null || value.toString().trim().isEmpty
            ? 'Not provided'
            : value.toString();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _mutedColor,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: Text(
            displayValue,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }
}

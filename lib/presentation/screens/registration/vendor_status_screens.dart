
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app url.dart';

import '../../../core/storage/colors.dart';
import '../../../data/controllers/vendor_registration_controller.dart';
import '../HomePages/vendor_home_page.dart';
import 'vendor_registration_screen.dart';

String _vendorMediaUrl(String path) {
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

Future<void> _openVendorDocument(String value) async {
  final uri = Uri.tryParse(_vendorMediaUrl(value));
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    Get.snackbar('Error', 'Invalid document URL.');
    return;
  }
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) Get.snackbar('Error', 'Unable to open the document.');
  } catch (e) {
    Get.snackbar('Error', 'Unable to open the document: $e');
  }
}

class VendorPendingScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const VendorPendingScreen({
    super.key,
    required this.profile,
  });

  @override
  State<VendorPendingScreen> createState() => _VendorPendingScreenState();
}

class _VendorPendingScreenState extends State<VendorPendingScreen> {
  late final VendorRegistrationController controller;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    _profile = Map<String, dynamic>.from(widget.profile);
    controller = Get.isRegistered<VendorRegistrationController>()
        ? Get.find<VendorRegistrationController>()
        : Get.put(VendorRegistrationController());
  }

  Future<void> _refreshStatus() async {
    final success = await controller.checkVendorStatus();

    if (!mounted) return;

    if (!success) {
      _showMessage(
        controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : 'Unable to refresh registration status.',
      );
      return;
    }

    final vendor = controller.vendorResponse.value?.data;
    final status = (
      vendor?.status.isNotEmpty == true
          ? vendor!.status
          : controller.registrationStatus.value
    ).trim().toLowerCase();

    final profile = <String, dynamic>{
      ...widget.profile,
      if (vendor != null) ...{
        'vendor_id': vendor.vendorId,
        'full_name': vendor.fullName,
        'email': vendor.email,
        'mobile_number': vendor.mobileNumber,
        'business_name': vendor.businessName,
        'business_type': vendor.businessType,
        'business_category': vendor.businessCategory,
        'gst_number': vendor.gstNumber,
        'business_registration_number':
            vendor.businessRegistrationNumber,
        'years_in_business': vendor.yearsInBusiness,
        'address_line1': vendor.addressLine1,
        'address_line2': vendor.addressLine2,
        'city': vendor.city,
        'district': vendor.district,
        'state': vendor.state,
        'pincode': vendor.pincode,
        'profile_photo': vendor.profilePhoto,
        'gst_certificate': vendor.gstCertificate,
        'address_proof': vendor.addressProof,
        'transport_permit_document': vendor.transportPermitDocument,
        'business_license': vendor.businessLicense,
        'status': status,
        'registration_status': status,
        'rejection_reason': vendor.rejectionReason,
      },
    };

    // Keep the latest profile (including document URLs) visible on this page.
    if (status == 'pending') {
      setState(() => _profile = profile);
    }

    if (status == 'approved') {
      Get.offAll(() => const VendorHomePage());
    } else if (status == 'rejected') {
      Get.offAll(() => VendorRejectedScreen(profile: profile));
    } else if (status == 'pending') {
      _showMessage(
        'Your registration is still pending admin approval.',
      );
    } else {
      _showMessage('The server returned an unknown registration status.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
              const _StatusCard(
                icon: Icons.hourglass_top_rounded,
                color: Color(0xFFFF9800),
                title: 'Registration Pending',
                message:
                    'Your Vendor registration is waiting for admin approval.',
              ),
              const SizedBox(height: 18),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.isCheckingStatus.value
                        ? null
                        : _refreshStatus,
                    icon: controller.isCheckingStatus.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.refresh_rounded),
                    label: Text(
                      controller.isCheckingStatus.value
                          ? 'Checking Status...'
                          : 'Refresh Status',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colours.primaryColor,
                      foregroundColor: colours.buttonTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('Business Details'),
              _detailCard([
                _DetailRow(
                  label: 'Business Name',
                  value: _profile['business_name'],
                ),
                _DetailRow(
                  label: 'Business Type',
                  value: _profile['business_type'],
                ),
                _DetailRow(
                  label: 'Business Category',
                  value: _profile['business_category'],
                ),
                _DetailRow(
                  label: 'GST Number',
                  value: _profile['gst_number'],
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Contact Details'),
              _detailCard([
                _DetailRow(
                  label: 'Full Name',
                  value: _profile['full_name'],
                ),
                _DetailRow(
                  label: 'Mobile Number',
                  value: _profile['mobile_number'],
                ),
                _DetailRow(
                  label: 'Email',
                  value: _profile['email'],
                ),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Business Address'),
              _detailCard([
                _DetailRow(
                  label: 'Address',
                  value: _profile['address_line1'],
                ),
                _DetailRow(
                  label: 'City',
                  value: _profile['city'],
                ),
                _DetailRow(
                  label: 'District',
                  value: _profile['district'],
                ),
                _DetailRow(
                  label: 'State',
                  value: _profile['state'],
                ),
                _DetailRow(
                  label: 'PIN Code',
                  value: _profile['pincode'],
                ),
              ]),
              const SizedBox(height: 20),
              _VendorDocumentsSection(profile: _profile),
            ],
          ),
        ),
      ),
    );
  }
}
class VendorRejectedScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const VendorRejectedScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final reason =
        (profile['rejection_reason'] ?? '').toString().trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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

              // Rejected Status
              const _StatusCard(
                icon: Icons.cancel_outlined,
                color: Colors.red,
                title: 'Registration Rejected',
                message:
                    'Your Vendor registration was not approved. Please review the reason below.',
              ),

              const SizedBox(height: 20),

              // Rejection Reason
              _sectionTitle('Rejection Reason'),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFFFD4D4),
                  ),
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

              const SizedBox(height: 20),

              // Business Details
              _sectionTitle('Business Details'),

              _detailCard([
                _DetailRow(
                  label: 'Business Name',
                  value: profile['business_name'],
                ),
                _DetailRow(
                  label: 'Business Type',
                  value: profile['business_type'],
                ),
                _DetailRow(
                  label: 'Business Category',
                  value: profile['business_category'],
                ),
                _DetailRow(
                  label: 'GST Number',
                  value: profile['gst_number'],
                ),
                _DetailRow(
                  label: 'Business Registration Number',
                  value: profile['business_registration_number'],
                ),
                _DetailRow(
                  label: 'Years in Business',
                  value: profile['years_in_business'],
                ),
              ]),

              const SizedBox(height: 20),

              // Contact Details
              _sectionTitle('Contact Details'),

              _detailCard([
                _DetailRow(
                  label: 'Full Name',
                  value: profile['full_name'],
                ),
                _DetailRow(
                  label: 'Email',
                  value: profile['email'],
                ),
                _DetailRow(
                  label: 'Mobile Number',
                  value: profile['mobile_number'],
                ),
                _DetailRow(
                  label: 'Alternate Mobile Number',
                  value: profile['alternate_mobile_number'],
                ),
              ]),

              const SizedBox(height: 20),

              // Business Address
              _sectionTitle('Business Address'),

              _detailCard([
                _DetailRow(
                  label: 'Address Line 1',
                  value: profile['address_line1'],
                ),
                _DetailRow(
                  label: 'Address Line 2',
                  value: profile['address_line2'],
                ),
                _DetailRow(
                  label: 'City',
                  value: profile['city'],
                ),
                _DetailRow(
                  label: 'District',
                  value: profile['district'],
                ),
                _DetailRow(
                  label: 'State',
                  value: profile['state'],
                ),
                _DetailRow(
                  label: 'PIN Code',
                  value: profile['pincode'],
                ),
              ]),

              const SizedBox(height: 20),

              // Uploaded Documents
              _VendorDocumentsSection(profile: profile),

              const SizedBox(height: 20),

              // Register Again Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAll(
                    () => const VendorRegistrationScreen(),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Register Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.primaryColor,
                    foregroundColor: colours.buttonTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VendorDocumentsSection extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _VendorDocumentsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final documents = <_VendorDocumentItem>[
      _VendorDocumentItem(
        label: 'Profile Photo',
        value: profile['profile_photo'],
        icon: Icons.person_outline_rounded,
        isImage: true,
      ),
      _VendorDocumentItem(
        label: 'GST Certificate',
        value: profile['gst_certificate'],
        icon: Icons.receipt_long_outlined,
      ),
      _VendorDocumentItem(
        label: 'Business Address Proof',
        value: profile['address_proof'],
        icon: Icons.location_on_outlined,
      ),
      _VendorDocumentItem(
        label: 'Transport Permit',
        value: profile['transport_permit_document'],
        icon: Icons.local_shipping_outlined,
      ),
      _VendorDocumentItem(
        label: 'Business License',
        value: profile['business_license'],
        icon: Icons.description_outlined,
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
                _VendorDocumentRow(document: documents[i]),
                if (i < documents.length - 1)
                  const Divider(height: 24),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _VendorDocumentItem {
  final String label;
  final dynamic value;
  final IconData icon;
  final bool isImage;

  const _VendorDocumentItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isImage = false,
  });
}

class _VendorDocumentRow extends StatelessWidget {
  final _VendorDocumentItem document;

  const _VendorDocumentRow({required this.document});

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
    final url = hasDocument ? _vendorMediaUrl(rawUrl) : '';
    final lowerPath = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    final isPdf = lowerPath.endsWith('.pdf');
    final fileIcon = isPdf
        ? Icons.picture_as_pdf_outlined
        : document.isImage
            ? Icons.image_outlined
            : document.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasDocument ? () => _openVendorDocument(url) : null,
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
                child: Icon(fileIcon, color: colours.primaryColor, size: 22),
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colours.primaryColor.withOpacity(0.25),
        ),
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
                  ),
                ),
                TextSpan(
                  text: 'Mitra',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    color: colours.primaryColor,
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
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  const _StatusCard({
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
            child: Icon(icon, size: 38, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF757575),
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
        color: Color(0xFF263238),
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
              color: Color(0xFF757575),
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
              color: Color(0xFF263238),
            ),
          ),
        ),
      ],
    );
  }
}

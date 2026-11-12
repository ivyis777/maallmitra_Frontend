
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:maalmitra/presentation/screens/HomePages/driver_home_page.dart';
import '../../../core/storage/colors.dart';
import '../../../core/constants/app url.dart';
import '../../../data/controllers/driver_registration_controller.dart';
import '../LoginPage/loginPage.dart';
import 'driver_registration_screen.dart';

const Color _backgroundColor = Color(0xFFF7F7F7);
const Color _textColor = Color(0xFF263238);
const Color _mutedColor = Color(0xFF757575);


String _driverMediaUrl(String path) {
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

Future<void> _openDriverDocument(String value) async {
  final uri = Uri.tryParse(_driverMediaUrl(value));
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

String _getDriverStatus(Map<String, dynamic> profile) {
  final value = profile['registration_status'] ??
      profile['status'] ??
      profile['driver_status'] ??
      profile['approval_status'];
  return (value ?? 'pending').toString().trim().toLowerCase();
}

String _getRejectionReason(Map<String, dynamic> profile) {
  final value = profile['rejection_reason'] ??
      profile['rejected_reason'] ??
      profile['reason'] ??
      profile['remarks'];
  final reason = (value ?? '').toString().trim();
  return reason.isEmpty
      ? 'No rejection reason was provided. Please contact the administrator.'
      : reason;
}

dynamic _value(Map<String, dynamic> profile, String key, [String? alternate]) {
  final value = profile[key] ?? (alternate == null ? null : profile[alternate]);
  if (value == null || value.toString().trim().isEmpty) return null;
  return value;
}

Map<String, dynamic> _companyProfile(Map<String, dynamic> profile) {
  final company = profile['company'];
  if (company is Map) return Map<String, dynamic>.from(company);
  return profile;
}

List<_DetailRow> _companyDetailRows(Map<String, dynamic> company) {
  final rows = <_DetailRow>[
    _DetailRow(
      label: 'Company Name',
      value: _value(company, 'company_name', 'name'),
    ),
    _DetailRow(
      label: 'Company Type',
      value: _value(company, 'company_type', 'type'),
    ),
  ];

  // Company fields are optional for the default Ivyis selection.
  // Show extra rows only when real values are available (e.g. an
  // existing registered company or a company added by the user).
  final optionalFields = <(String, String, String?)>[
    ('GST Number', 'gst_number', null),
    ('Registration Number', 'company_registration_id', 'registration_number'),
    ('Email Address', 'company_email', 'email'),
    ('Phone Number', 'company_phone_number', 'phone_number'),
    ('Address', 'company_address', 'address'),
    ('City', 'company_city', 'city'),
    ('State', 'company_state', 'state'),
    ('PIN Code', 'company_pincode', 'company_pin_code'),
    ('Country', 'company_country', 'country'),
  ];

  for (final field in optionalFields) {
    final value = _value(company, field.$2, field.$3);
    if (value != null) {
      rows.add(_DetailRow(label: field.$1, value: value));
    }
  }
  return rows;
}

class DriverPendingScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const DriverPendingScreen({super.key, required this.profile});

  @override
  State<DriverPendingScreen> createState() => _DriverPendingScreenState();
}

class _DriverPendingScreenState extends State<DriverPendingScreen> {
  late final DriverRegistrationController controller;
  late Map<String, dynamic> profile;

  @override
  void initState() {
    super.initState();
    profile = Map<String, dynamic>.from(widget.profile);
    controller = Get.isRegistered<DriverRegistrationController>()
        ? Get.find<DriverRegistrationController>()
        : Get.put(DriverRegistrationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handleStatus(profile);
    });
  }

  Future<void> _refreshStatus() async {
    final latestProfile = await controller.fetchDriverStatus();
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

    final mergedProfile = <String, dynamic>{...profile, ...latestProfile};
    setState(() => profile = mergedProfile);
    await _handleStatus(profile);
  }

  Future<void> _handleStatus(Map<String, dynamic> currentProfile) async {
    if (!mounted) return;
    final status = _getDriverStatus(currentProfile);

    if (status == 'approved' || status == 'approve') {
      Get.offAll(() => const DriverHomePage());
    } else if (status == 'rejected' || status == 'reject') {
      Get.offAll(() => DriverRejectedScreen(profile: currentProfile));
    } else if (status == 'pending') {
      // Pending is the expected initial state; no extra message is needed.
    } else if (status.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration status: $status'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = _companyProfile(profile);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Driver Registration Status',
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
                    'Your driver registration is waiting for admin approval.',
              ),
              const SizedBox(height: 16),
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
                            width: 18,
                            height: 18,
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
              if (profile['registration_id'] != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Registration ID: ${profile['registration_id']}',
                    style: const TextStyle(color: _mutedColor, fontSize: 12),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _sectionTitle('Personal Details'),
              _detailCard([
                _DetailRow(label: 'Full Name', value: _value(profile, 'name', 'full_name')),
                _DetailRow(label: 'Age', value: profile['age']),
                _DetailRow(label: 'Gender', value: profile['gender']),
                _DetailRow(label: 'Mobile Number', value: _value(profile, 'mobile_number', 'mobile')),
                _DetailRow(label: 'Aadhaar Number', value: _value(profile, 'aadhaar_number', 'aadhar_number')),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Driving Licence Details'),
              _detailCard([
                _DetailRow(label: 'Driving Licence Number', value: _value(profile, 'driving_licence_number', 'driving_license_number')),
                _DetailRow(label: 'Licence Type', value: _value(profile, 'dl_type', 'licence_type')),
                _DetailRow(label: 'Issued Date', value: _value(profile, 'dl_issued_date', 'issued_date')),
                _DetailRow(label: 'Expiry Date', value: _value(profile, 'dl_expired_date', 'expiry_date')),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Address Details'),
              _detailCard([
                _DetailRow(label: 'Permanent Address', value: profile['permanent_address']),
                _DetailRow(label: 'Current Address', value: profile['current_address']),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Company Details'),
              _detailCard(_companyDetailRows(company)),
              const SizedBox(height: 20),
              _DriverDocumentsSection(profile: profile),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverRejectedScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const DriverRejectedScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final company = _companyProfile(profile);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Driver Registration Status',
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
                message:
                    'Your driver registration was not approved. Please review the reason below.',
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
                  _getRejectionReason(profile),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFFB42318),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('Personal Details'),
              _detailCard([
                _DetailRow(label: 'Full Name', value: _value(profile, 'name', 'full_name')),
                _DetailRow(label: 'Age', value: profile['age']),
                _DetailRow(label: 'Gender', value: profile['gender']),
                _DetailRow(label: 'Mobile Number', value: _value(profile, 'mobile_number', 'mobile')),
                _DetailRow(label: 'Aadhaar Number', value: _value(profile, 'aadhaar_number', 'aadhar_number')),
                _DetailRow(label: 'Driving Licence Number', value: _value(profile, 'driving_licence_number', 'driving_license_number')),
              ]),
              const SizedBox(height: 20),
              _sectionTitle('Company Details'),
              _detailCard(_companyDetailRows(company)),
              const SizedBox(height: 20),
              _DriverDocumentsSection(profile: profile),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAll(
                    () => const DriverRegistrationScreen(),
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
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Get.offAll(() => const LoginPage()),
                  child: const Text('Back to Login'),
                ),
              ),
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
            child: Icon(icon, size: 38, color: color),
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
          if (i < details.length - 1) const Divider(height: 22),
        ],
      ],
    ),
  );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const _DetailRow({required this.label, required this.value});

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
            style: const TextStyle(fontSize: 13, color: _mutedColor),
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


class _DriverDocumentsSection extends StatelessWidget {
  final Map<String, dynamic> profile;

  const _DriverDocumentsSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    final documents = <_DriverDocumentItem>[
      _DriverDocumentItem(
        label: 'Medical Certificate',
        value: profile['medical_certificate'],
        icon: Icons.medical_services_outlined,
      ),
      _DriverDocumentItem(
        label: 'Police Verification Certificate',
        value: profile['police_verification_certificate'],
        icon: Icons.verified_user_outlined,
      ),
      _DriverDocumentItem(
        label: 'Driver Photo',
        value: profile['photo'],
        icon: Icons.person_outline_rounded,
        isImage: true,
      ),
      _DriverDocumentItem(
        label: 'Aadhaar Card - Front',
        value: profile['aadhaar_front'],
        icon: Icons.badge_outlined,
        isImage: true,
      ),
      _DriverDocumentItem(
        label: 'Aadhaar Card - Back',
        value: profile['aadhaar_back'],
        icon: Icons.badge_outlined,
        isImage: true,
      ),
      _DriverDocumentItem(
        label: 'Driving Licence - Front',
        value: profile['dl_front'],
        icon: Icons.credit_card_outlined,
        isImage: true,
      ),
      _DriverDocumentItem(
        label: 'Driving Licence - Back',
        value: profile['dl_back'],
        icon: Icons.credit_card_outlined,
        isImage: true,
      ),
      if ((profile['company_bond_document'] ?? '').toString().trim().isNotEmpty)
        _DriverDocumentItem(
          label: 'Company Bond Document',
          value: profile['company_bond_document'],
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
                _DriverDocumentRow(document: documents[i]),
                if (i < documents.length - 1) const Divider(height: 24),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DriverDocumentItem {
  final String label;
  final dynamic value;
  final IconData icon;
  final bool isImage;

  const _DriverDocumentItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isImage = false,
  });
}

class _DriverDocumentRow extends StatelessWidget {
  final _DriverDocumentItem document;

  const _DriverDocumentRow({required this.document});

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
    final url = hasDocument ? _driverMediaUrl(rawUrl) : '';
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    final isPdf = path.endsWith('.pdf');
    final icon = isPdf
        ? Icons.picture_as_pdf_outlined
        : document.isImage
            ? Icons.image_outlined
            : document.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasDocument ? () => _openDriverDocument(url) : null,
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
                Icon(
                  Icons.open_in_new_rounded,
                  color: colours.primaryColor,
                  size: 20,
                )
              else
                const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

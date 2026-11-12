import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app url.dart';
import '../../../core/storage/colors.dart';
import '../../../data/controllers/truck_owner_registration_controller.dart';
import '../Registration/truck_owner_registration_screen.dart';

// Update this import if your HomePage folder or filename is different.
import '../HomePages/owner_home_page.dart';

const Color _backgroundColor = Color(0xFFF7F7F7);
const Color _textColor = Color(0xFF263238);
const Color _mutedColor = Color(0xFF757575);

String _truckOwnerMediaUrl(String path) {
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

Future<void> _openTruckOwnerDocument(String value) async {
  final uri = Uri.tryParse(_truckOwnerMediaUrl(value));

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

// ------------------------------------------------------------
// PENDING SCREEN
// ------------------------------------------------------------

class TruckOwnerPendingScreen extends StatefulWidget {
  final Map<String, dynamic> profile;

  const TruckOwnerPendingScreen({
    super.key,
    required this.profile,
  });

  @override
  State<TruckOwnerPendingScreen> createState() =>
      _TruckOwnerPendingScreenState();
}

class _TruckOwnerPendingScreenState extends State<TruckOwnerPendingScreen> {
  late final TruckOwnerRegistrationController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<TruckOwnerRegistrationController>()
        ? Get.find<TruckOwnerRegistrationController>()
        : Get.put(TruckOwnerRegistrationController());
  }

  Map<String, dynamic> _latestProfile() {
    final latest = controller.ownerStatusDetails.value;

    return {
      ...widget.profile,
      if (latest != null) ...latest,
    };
  }

  Future<void> _refreshRegistrationStatus() async {
    await controller.checkTruckOwnerStatus();

    if (!mounted) return;

    final latest = controller.ownerStatusDetails.value;

    if (latest == null) {
      final message = controller.statusErrorMessage.value.isNotEmpty
          ? controller.statusErrorMessage.value
          : 'Unable to refresh registration status. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final profile = _latestProfile();

    final status = (latest['registration_status'] ??
            latest['status'] ??
            '')
        .toString()
        .trim()
        .toLowerCase();

    if (status == 'approved') {
      Get.offAll(() => const OwnerHomePage());
    } else if (status == 'rejected') {
      Get.offAll(
        () => TruckOwnerRejectedScreen(profile: profile),
      );
    } else if (status == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your registration is still pending admin approval.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The server returned an unknown registration status.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _latestProfile();
    // Backend returns Self Driver data under driver_registration.
    // Keep self_driver as a fallback for older API responses.
    final selfDriver = _asMap(
      profile['driver_registration'] ?? profile['self_driver'],
    );
    final company = _asMap(selfDriver['company']);

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

              const _StatusHeader(
                icon: Icons.hourglass_top_rounded,
                color: colours.primaryColor,
                title: 'Registration Pending',
                message:
                    'Your truck owner registration is waiting for admin approval.',
              ),

              const SizedBox(height: 16),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value
                        ? null
                        : _refreshRegistrationStatus,
                    icon: controller.isLoading.value
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
                      controller.isLoading.value
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

              _sectionTitle('Owner Details'),

              _detailCard([
                _DetailRow(
                  label: 'Owner ID',
                  value: profile['owner_id'],
                ),
                _DetailRow(
                  label: 'Owner Name',
                  value: profile['name'],
                ),
                _DetailRow(
                  label: 'Mobile Number',
                  value: profile['mobile_number'],
                ),
                _DetailRow(
                  label: 'Date of Birth',
                  value: profile['date_of_birth'],
                ),
                _DetailRow(
                  label: 'Gender',
                  value: profile['gender'],
                ),
                _DetailRow(
                  label: 'Permanent Address',
                  value: profile['permanent_address'],
                ),
                _DetailRow(
                  label: 'Current Address',
                  value: profile['current_address'],
                ),
                _DetailRow(
                  label: 'Self Driver',
                  value: _boolLabel(profile['is_self_driver']),
                ),
                _DetailRow(
                  label: 'Registration Date',
                  value: profile['created_at'],
                ),
              ]),

              const SizedBox(height: 20),

              if (selfDriver.isNotEmpty) ...[
                _sectionTitle('Driving Licence Details'),

                _detailCard([
                  _DetailRow(
                    label: 'Driver ID',
                    value: selfDriver['driver_id'],
                  ),
                  _DetailRow(
                    label: 'Driver Name',
                    value: selfDriver['name'],
                  ),
                  _DetailRow(
                    label: 'Age',
                    value: selfDriver['age'],
                  ),
                  _DetailRow(
                    label: 'Gender',
                    value: selfDriver['gender'],
                  ),
                  _DetailRow(
                    label: 'Mobile Number',
                    value: selfDriver['mobile_number'],
                  ),
                  _DetailRow(
                    label: 'Aadhaar Number',
                    value: _maskAadhaar(selfDriver['aadhaar_number']),
                  ),
                  _DetailRow(
                    label: 'Driving Licence Number',
                    value: selfDriver['driving_licence_number'],
                  ),
                  _DetailRow(
                    label: 'DL Type',
                    value: selfDriver['dl_type'],
                  ),
                  _DetailRow(
                    label: 'DL Issued Date',
                    value: selfDriver['dl_issued_date'],
                  ),
                  _DetailRow(
                    label: 'DL Expiry Date',
                    value: selfDriver['dl_expired_date'],
                  ),
                  _DetailRow(
                    label: 'Permanent Address',
                    value: selfDriver['permanent_address'],
                  ),
                  _DetailRow(
                    label: 'Current Address',
                    value: selfDriver['current_address'],
                  ),
                  _DetailRow(
                    label: 'Driver Registration Status',
                    value: selfDriver['status'],
                  ),
                ]),

                if (company.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('Company Details'),
                  _detailCard(_companyDetailRows(company, selfDriver)),
                ],

                const SizedBox(height: 20),
              ],

              _TruckOwnerDocumentsSection(
                profile: profile,
                selfDriver: selfDriver,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// REJECTED SCREEN
// ------------------------------------------------------------

class TruckOwnerRejectedScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  const TruckOwnerRejectedScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final reason =
        (profile['rejection_reason'] ?? '').toString().trim();

    final selfDriver = _asMap(
      profile['driver_registration'] ?? profile['self_driver'],
    );
    final company = _asMap(selfDriver['company']);

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

              const _StatusHeader(
                icon: Icons.cancel_outlined,
                color: Colors.red,
                title: 'Registration Rejected',
                message:
                    'Your truck owner registration was not approved. Please review the reason below.',
              ),

              const SizedBox(height: 24),

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

              const SizedBox(height: 24),

              _sectionTitle('Owner Details'),

              _detailCard([
                _DetailRow(
                  label: 'Owner ID',
                  value: profile['owner_id'],
                ),
                _DetailRow(
                  label: 'Owner Name',
                  value: profile['name'],
                ),
                _DetailRow(
                  label: 'Mobile Number',
                  value: profile['mobile_number'],
                ),
                _DetailRow(
                  label: 'Date of Birth',
                  value: profile['date_of_birth'],
                ),
                _DetailRow(
                  label: 'Gender',
                  value: profile['gender'],
                ),
                _DetailRow(
                  label: 'Permanent Address',
                  value: profile['permanent_address'],
                ),
                _DetailRow(
                  label: 'Current Address',
                  value: profile['current_address'],
                ),
                _DetailRow(
                  label: 'Self Driver',
                  value: _boolLabel(profile['is_self_driver']),
                ),
                _DetailRow(
                  label: 'Registration Date',
                  value: profile['created_at'],
                ),
              ]),

              if (selfDriver.isNotEmpty) ...[
                const SizedBox(height: 20),

                _sectionTitle('Driving Licence Details'),

                _detailCard([
                  _DetailRow(label: 'Driver ID', value: selfDriver['driver_id']),
                  _DetailRow(label: 'Driver Name', value: selfDriver['name']),
                  _DetailRow(label: 'Age', value: selfDriver['age']),
                  _DetailRow(label: 'Gender', value: selfDriver['gender']),
                  _DetailRow(label: 'Mobile Number', value: selfDriver['mobile_number']),
                  _DetailRow(label: 'Aadhaar Number', value: _maskAadhaar(selfDriver['aadhaar_number'])),
                  _DetailRow(label: 'Driving Licence Number', value: selfDriver['driving_licence_number']),
                  _DetailRow(label: 'DL Type', value: selfDriver['dl_type']),
                  _DetailRow(label: 'DL Issued Date', value: selfDriver['dl_issued_date']),
                  _DetailRow(label: 'DL Expiry Date', value: selfDriver['dl_expired_date']),
                  _DetailRow(label: 'Permanent Address', value: selfDriver['permanent_address']),
                  _DetailRow(label: 'Current Address', value: selfDriver['current_address']),
                  _DetailRow(label: 'Driver Registration Status', value: selfDriver['status']),
                ]),
                if (company.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('Company Details'),
                  _detailCard(_companyDetailRows(company, selfDriver)),
                ],
              ],

              const SizedBox(height: 20),

              _TruckOwnerDocumentsSection(
                profile: profile,
                selfDriver: selfDriver,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.offAll(
                      () => const TruckOwnerRegistrationScreen(),
                    );
                  },
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

              const Center(
                child: Text(
                  'You can start the registration process again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: _mutedColor,
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
// ------------------------------------------------------------
// DOCUMENTS SECTION
// ------------------------------------------------------------
class _TruckOwnerDocumentsSection extends StatelessWidget {
  final Map<String, dynamic> profile;
  final Map<String, dynamic> selfDriver;
  const _TruckOwnerDocumentsSection({
    required this.profile,
    required this.selfDriver,
  });
  @override
  Widget build(BuildContext context) {
    final allDocuments = <_TruckOwnerDocumentItem>[
      _TruckOwnerDocumentItem(
        label: 'Owner Aadhaar Card',
        value: profile['aadhaar_card_document'],
        icon: Icons.badge_outlined,
      ),
      _TruckOwnerDocumentItem(
        label: 'Owner PAN Card',
        value: profile['pan_card_document'],
        icon: Icons.credit_card_outlined,
      ),
      if (selfDriver.isNotEmpty) ...[
        _TruckOwnerDocumentItem(label: 'Medical Certificate', value: selfDriver['medical_certificate'], icon: Icons.medical_services_outlined),
        _TruckOwnerDocumentItem(label: 'Police Verification Certificate', value: selfDriver['police_verification_certificate'], icon: Icons.verified_user_outlined),
        _TruckOwnerDocumentItem(label: 'Driver Photo', value: selfDriver['photo'], icon: Icons.person_outline_rounded),
        _TruckOwnerDocumentItem(label: 'Aadhaar Front', value: selfDriver['aadhaar_front'], icon: Icons.credit_card_outlined),
        _TruckOwnerDocumentItem(label: 'Aadhaar Back', value: selfDriver['aadhaar_back'], icon: Icons.credit_card_outlined),
        _TruckOwnerDocumentItem(label: 'Driving Licence Front', value: selfDriver['dl_front'], icon: Icons.badge_outlined),
        _TruckOwnerDocumentItem(label: 'Driving Licence Back', value: selfDriver['dl_back'], icon: Icons.badge_outlined),
        if ((selfDriver['company_type'] ??
                    _asMap(selfDriver['company'])['company_type'] ??
                    '')
                .toString()
                .trim()
                .toLowerCase() !=
            'ivyis') ...[
          if (_hasDisplayValue(selfDriver['company_bond_document']))
            _TruckOwnerDocumentItem(
              label: 'Company Proof Document',
              value: selfDriver['company_bond_document'],
              icon: Icons.description_outlined,
            )
          else
            _TruckOwnerDocumentItem(
              label: 'Uploaded Company Document',
              value: _asMap(selfDriver['company'])['document'],
              icon: Icons.business_outlined,
            ),
          _TruckOwnerDocumentItem(
            label: 'Company Other Document',
            value: _asMap(selfDriver['company'])['other_document'],
            icon: Icons.description_outlined,
          ),
        ],
      ],
    ];

    // Hide document rows when no file was uploaded.
    final documents = allDocuments
        .where((document) => _hasDisplayValue(document.value))
        .toList();

    if (documents.isEmpty) return const SizedBox.shrink();

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
                _TruckOwnerDocumentRow(
                  document: documents[i],
                ),
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

class _TruckOwnerDocumentItem {
  final String label;
  final dynamic value;
  final IconData icon;

  const _TruckOwnerDocumentItem({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class _TruckOwnerDocumentRow extends StatelessWidget {
  final _TruckOwnerDocumentItem document;

  const _TruckOwnerDocumentRow({
    required this.document,
  });

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

    final hasDocument =
        rawUrl.isNotEmpty && rawUrl.toLowerCase() != 'null';

    final url = hasDocument ? _truckOwnerMediaUrl(rawUrl) : '';

    final lowerPath =
        Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();

    final isPdf = lowerPath.endsWith('.pdf');

    final icon = isPdf
        ? Icons.picture_as_pdf_outlined
        : document.icon;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasDocument
            ? () => _openTruckOwnerDocument(url)
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colours.primaryColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: colours.primaryColor,
                  size: 22,
                ),
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
                        color: _textColor,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      hasDocument
                          ? _fileName(url)
                          : 'Document not uploaded',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: hasDocument
                            ? _mutedColor
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
                const Icon(
                  Icons.cancel_rounded,
                  color: Colors.red,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// COMMON HELPERS AND WIDGETS
// ------------------------------------------------------------

// Company display follows the exact choice made during registration:
/// Ivyis: only type and name.
/// Existing company: type/name; its separately uploaded proof appears in Documents.
/// Add Company: show the company information entered in the registration form.
List<_DetailRow> _companyDetailRows(
  Map<String, dynamic> company,
  Map<String, dynamic> selfDriver,
) {
  final type = (company['company_type'] ??
          selfDriver['company_type'] ??
          '')
      .toString()
      .trim()
      .toLowerCase();

  final isIvyis = type == 'ivyis';
  final hasExistingCompanyProof =
      _hasDisplayValue(selfDriver['company_bond_document']);

  final rows = <_DetailRow>[
    _DetailRow(
      label: 'Company Type',
      value: type == 'ivyis'
          ? 'Ivyis Technologies'
          : (type.isEmpty ? null : 'Other'),
    ),
    _DetailRow(
      label: 'Company Name',
      value: company['company_name'] ?? selfDriver['company_name'],
    ),
  ];

  if (isIvyis || hasExistingCompanyProof) {
    return rows;
  }

  // Add Company: include the entered company details. The detail keys below
  // support both the registration payload aliases and company profile API keys.
  final extraFields = <(String, String, String?)>[
    ('Company Registration ID', 'company_registration_id', 'registration_id'),
    ('Company Unique ID', 'company_uniqueid', 'company_unique_id'),
    ('GST Number', 'gst_number', null),
    ('Company Email', 'email', 'company_email'),
    ('Company Phone Number', 'phone_number', 'company_phone_number'),
    ('Contact Person Number', 'company_person_number', 'contact_person_number'),
    ('Company Address', 'address', 'company_address'),
    ('City', 'city', 'company_city'),
    ('State', 'state', 'company_state'),
    ('Pincode', 'pincode', 'company_pincode'),
    ('Country', 'country', 'company_country'),
    ('Document Type', 'document_type', 'company_document_type'),
  ];

  for (final field in extraFields) {
    rows.add(
      _DetailRow(
        label: field.$1,
        value: company[field.$2] ?? (field.$3 == null ? null : company[field.$3]),
      ),
    );
  }

  return rows;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

String _maskAadhaar(dynamic value) {
  final number = (value ?? '').toString().trim();
  if (number.isEmpty || number.toLowerCase() == 'null') {
    return '';
  }
  if (number.length <= 4) return number;
  return 'XXXX XXXX ${number.substring(number.length - 4)}';
}

String _boolLabel(dynamic value) {
  if (value == true || value.toString().toLowerCase() == 'true') {
    return 'Yes';
  }

  if (value == false || value.toString().toLowerCase() == 'false') {
    return 'No';
  }

  return '';
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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

bool _hasDisplayValue(dynamic value) {
  if (value == null) return false;
  final text = value.toString().trim();
  return text.isNotEmpty &&
      text.toLowerCase() != 'null' &&
      text.toLowerCase() != 'not provided';
}

Widget _detailCard(List<_DetailRow> details) {
  // Remove optional fields that the user did not enter.
  final visibleDetails = details
      .where((detail) => _hasDisplayValue(detail.value))
      .toList();

  if (visibleDetails.isEmpty) return const SizedBox.shrink();

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        for (int i = 0; i < visibleDetails.length; i++) ...[
          visibleDetails[i],
          if (i < visibleDetails.length - 1)
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
    final displayValue = value.toString().trim();

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
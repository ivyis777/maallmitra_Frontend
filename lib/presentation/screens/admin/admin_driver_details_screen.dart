import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/controllers/admin_driver_controller.dart';
import '../../../data/models/driver_details_model.dart';
import '../../../core/storage/colors.dart';
import '../../../core/constants/app url.dart';
class AdminDriverDetailsScreen extends StatefulWidget {
  final int registrationId;
  const AdminDriverDetailsScreen({
    super.key,
    required this.registrationId,
  });

  @override
  State<AdminDriverDetailsScreen> createState() =>
      _AdminDriverDetailsScreenState();
}

class _AdminDriverDetailsScreenState
    extends State<AdminDriverDetailsScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color dark = Color(0xFF171717);

  late final AdminDriverController controller;

  final TextEditingController reasonController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminDriverController>()
        ? Get.find<AdminDriverController>()
        : Get.put(AdminDriverController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDriverAndCompanyDetails();
      }
    });
  }

  Future<void> _loadDriverAndCompanyDetails() async {
    final success = await controller.fetchDriverDetails(
      widget.registrationId,
    );

    if (!success || !mounted) return;

    final driver = controller.driverDetails.value?.data;
    final companyId = int.tryParse(driver?.companyId ?? '');

    if (companyId != null && companyId > 0) {
      await controller.fetchCompanyDetails(companyId);
    }
  }

  Future<void> _refreshDetails() async {
    await _loadDriverAndCompanyDetails();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  // Convert relative media paths into complete URLs.
  String _mediaUrl(String path) {
    if (path.isEmpty) return '';

    final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
      RegExp(r'/user/?$'),
      '',
    );

    if (path.startsWith('https://') ||
        path.startsWith('http://')) {
      final mediaUri = Uri.tryParse(path);
      final baseUri = Uri.tryParse(serverBaseUrl);

      if (mediaUri != null &&
          baseUri != null &&
          (mediaUri.host == '127.0.0.1' ||
              mediaUri.host == 'localhost')) {
        return mediaUri.replace(
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : mediaUri.port,
          scheme: baseUri.scheme,
        ).toString();
      }

      return path;
    }

    final normalizedPath =
        path.startsWith('/') ? path : '/$path';

    return '$serverBaseUrl$normalizedPath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: dark,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Driver Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _refreshDetails,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isDetailsLoading.value &&
            controller.driverDetails.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (controller.driverDetails.value == null) {
          return _errorView();
        }

        final driver = controller.driverDetails.value!.data;

        return RefreshIndicator(
          color: orange,
          onRefresh: _refreshDetails,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // Driver profile header
              _profileHeader(driver),

              const SizedBox(height: 16),

              // Personal details
              _section('Personal Details', [
                _detail('Name', driver.name),
                _detail('Age', '${driver.age}'),
                _detail('Gender', driver.gender),
                _detail('Mobile Number', driver.mobileNumber),
                _detail('Aadhaar Number', driver.aadhaarNumber),
              ]),

              // Company details
              Obx(() {
                final company = controller.companyDetails.value;

                if (controller.isCompanyDetailsLoading.value &&
                    company == null) {
                  return _section('Company Details', [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          color: orange,
                        ),
                      ),
                    ),
                  ]);
                }

                if (company == null) {
                  return _section('Company Details', [
                    _detail('Company Type', driver.companyType),
                    _detail('Company Name', driver.companyName),
                    if (controller.companyDetailsError.value.isNotEmpty)
                      _detail(
                        'Company Details Error',
                        controller.companyDetailsError.value,
                      ),
                  ]);
                }

                return _section('Company Details', [
                  _detail('Company Type', driver.companyType),
                  _detail('Company ID', company.company_Id),
                  _detail(
                    'Company Unique ID',
                    company.company_uniqueid,
                  ),
                  _detail('Company Name', company.companyName),
                  _detail('GST Number', company.gstNumber),
                  _detail('Email', company.email),
                  _detail('Phone Number', company.phoneNumber),
                  _detail(
                    'Contact Person Number',
                    company.companyPersonNumber,
                  ),
                  _detail('Address', company.address),
                  _detail('City', company.city),
                  _detail('State', company.state),
                  _detail('Pincode', company.pincode),
                  _detail('Country', company.country),
                  _detail('Document Type', company.documentType),
                  _detail('Created At', company.createdAt),
                  _detail('Updated At', company.updatedAt),
                  _document(
                    'Company Document',
                    company.document,
                  ),
                ]);
              }),

              // Driving licence details
              _section('Driving Licence Details', [
                _detail(
                  'Licence Number',
                  driver.drivingLicenceNumber,
                ),
                _detail('DL Type', driver.dlType),
                _detail('Issued Date', driver.dlIssuedDate),
                _detail('Expiry Date', driver.dlExpiredDate),
              ]),

              // Address details
              _section('Addresses', [
                _detail(
                  'Permanent Address',
                  driver.permanentAddress,
                ),
                _detail(
                  'Current Address',
                  driver.currentAddress,
                ),
              ]),

              // Documents
              _documentSection(driver),

              // Rejection information
              if (driver.status.toLowerCase() == 'rejected')
                _section('Rejection Information', [
                  _detail(
                    'Reason',
                    driver.rejectionReason ?? '',
                  ),
                  _detail(
                    'Reviewed At',
                    driver.reviewedAt ?? '',
                  ),
                ]),

              const SizedBox(height: 8),

              // Approve and reject actions
              if (driver.status.toLowerCase() == 'pending')
                _actionButtons(),

              if (driver.status.toLowerCase() != 'pending')
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'This registration is ${driver.status}. '
                    'No further action is available here.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  // PROFILE HEADER
  Widget _profileHeader(DriverDetails driver) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
        CircleAvatar(
            radius: 38,
            backgroundColor: orange.withValues(alpha: 0.15),
            child: const Icon(
              colours.person,
              size: 44,
              color: orange,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            driver.name.isEmpty ? 'Driver' : driver.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Registration ID: ${driver.id}',
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              driver.status.toUpperCase(),
              style: const TextStyle(
                color: orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder() {
    return Container(
      width: 76,
      height: 76,
      color: orange.withValues(alpha: 0.15),
      child: const Icon(
        colours.person,
        size: 42,
        color: dark,
      ),
    );
  }

  // SECTION CARD
  Widget _section(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),

            const Divider(height: 24),

            ...children,
          ],
        ),
      ),
    );
  }

  // DETAIL FIELD
  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value.trim().isEmpty ? 'Not provided' : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // DOCUMENT SECTION
  Widget _documentSection(DriverDetails driver) {
    final documents = <MapEntry<String, String>>[
      MapEntry('Driver Photo', driver.photo),
      MapEntry('Aadhaar Front', driver.aadhaarFront),
      MapEntry('Aadhaar Back', driver.aadhaarBack),
      MapEntry('DL Front', driver.dlFront),
      MapEntry('DL Back', driver.dlBack),
      MapEntry('Medical Certificate', driver.medicalCertificate),
      MapEntry(
        'Police Verification',
        driver.policeVerificationCertificate,
      ),
    ];

    return _section(
      'Driver Documents',
      documents.map((document) {
        return _document(document.key, document.value);
      }).toList(),
    );
  }

  // REUSABLE DOCUMENT CARD
  Widget _document(String title, String path) {
    final available = path.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(
              colours.file,
              color: orange,
              size: 30,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    available
                        ? path.split('/').last
                        : 'Document unavailable',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: available
                  ? () => _showDocument(title, path)
                  : null,
              child: Text(
                available ? 'View' : 'Unavailable',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Open image documents inside the app and other documents externally.
  Future<void> _showDocument(String title, String path) async {
    final url = _mediaUrl(path.trim());
    final uri = Uri.tryParse(url);

    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      Get.snackbar(
        'Invalid Document',
        'The document URL is invalid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Use the URI path so query parameters do not affect file detection.
    final lowerPath = uri.path.toLowerCase();
    final isImage = lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.webp');

    if (isImage) {
      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: InteractiveViewer(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: orange),
                  );
                },
                errorBuilder: (_, __, ___) => const Center(
                  child: Text(
                    'Unable to load this image. Check the server address, '
                    'media permissions, and document URL.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    // PDFs and other files are opened using an installed external app/browser.
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened) {
        Get.snackbar(
          'Unable to Open',
          'No application could open this document.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Document Error',
        'Could not open the document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // APPROVE / REJECT BUTTONS
  Widget _actionButtons() {
    return Obx(() {
      final busy = controller.isActionLoading.value;

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: busy ? null : _approve,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Approve Driver'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: busy ? null : _showRejectDialog,
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Reject Driver'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          if (busy)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(color: orange),
            ),
        ],
      );
    });
  }

  // APPROVE CONFIRMATION
  Future<void> _approve() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Approve Driver?'),
        content: const Text(
          'Are you sure you want to approve this driver registration?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (!mounted || confirmed != true) return;

    final success = await controller.approveDriver(
      widget.registrationId,
    );

    if (!mounted) return;

    if (success) {
      Get.back();
    } else {
      Get.snackbar(
        'Request Failed',
        controller.actionMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // REJECT CONFIRMATION
  Future<void> _showRejectDialog() async {
    reasonController.clear();

    final reason = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Reject Driver'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Rejection reason',
            hintText: 'Enter the reason for rejection',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back<String>(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();

              if (reason.isEmpty) {
                Get.snackbar(
                  'Required',
                  'Please enter a rejection reason.',
                );
                return;
              }

              Get.back<String>(result: reason);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (!mounted || reason == null || reason.trim().isEmpty) {
      return;
    }

    final success = await controller.rejectDriver(
      registrationId: widget.registrationId,
      rejectionReason: reason,
    );

    if (!mounted) return;

    if (success) {
      Get.back();
    } else {
      Get.snackbar(
        'Request Failed',
        controller.actionMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // ERROR VIEW
  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 45,
            ),

            const SizedBox(height: 12),

            Text(
              controller.detailsError.value.isEmpty
                  ? 'Unable to load driver details.'
                  : controller.detailsError.value,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 14),

            ElevatedButton(
              onPressed: _refreshDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: dark,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

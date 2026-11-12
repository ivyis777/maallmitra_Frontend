
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/storage/colors.dart';
import '../../../core/constants/app url.dart';
import '../../../data/controllers/admin_truck_owner_controller.dart';
import '../../../data/models/truck_owner_details_model.dart';

class AdminTruckOwnerDetailsScreen extends StatefulWidget {
  final int ownerId;

  const AdminTruckOwnerDetailsScreen({
    super.key,
    required this.ownerId,
  });

  @override
  State<AdminTruckOwnerDetailsScreen> createState() =>
      _AdminTruckOwnerDetailsScreenState();
}

class _AdminTruckOwnerDetailsScreenState
    extends State<AdminTruckOwnerDetailsScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color dark = Color(0xFF171717);

  late final AdminTruckOwnerController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminTruckOwnerController>()
        ? Get.find<AdminTruckOwnerController>()
        : Get.put(AdminTruckOwnerController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.fetchTruckOwnerDetails(widget.ownerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: dark,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Truck Owner Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                controller.fetchTruckOwnerDetails(widget.ownerId),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        final owner = controller.details.value?.data;

        if (owner == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 45),
                  const SizedBox(height: 12),
                  Text(
                    controller.detailsError.value.isEmpty
                        ? 'Unable to load truck owner details.'
                        : controller.detailsError.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () =>
                        controller.fetchTruckOwnerDetails(widget.ownerId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: orange,
          onRefresh: () =>
              controller.fetchTruckOwnerDetails(widget.ownerId),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _profileHeader(owner),
              const SizedBox(height: 16),

              _section('Personal Details', [
                _detail('Owner ID', owner.ownerId.toString()),
                _detail('Name', owner.name),
                _detail('Mobile Number', owner.mobileNumber),
                _detail('Date of Birth', owner.dateOfBirth),
                _detail('Gender', owner.gender),
                _detail('Permanent Address', owner.permanentAddress),
                _detail('Current Address', owner.currentAddress),
                _detail(
                  'Self Driver',
                  owner.isSelfDriver ? 'Yes' : 'No',
                ),
                _detail('Created At', owner.createdAt),
                _detail('Updated At', owner.updatedAt),
              ]),

              _section('Owner Documents', [
                _document(
                  'PAN Card',
                  owner.panCardDocument,
                ),
              ]),

              if (owner.selfDriver != null)
                _selfDriverSection(owner.selfDriver!),

              if (owner.status.trim().toLowerCase() == 'rejected')
                _section('Rejection Information', [
                  _detail(
                    'Rejection Reason',
                    owner.rejectionReason ?? '',
                  ),
                  _detail(
                    'Reviewed At',
                    owner.reviewedAt ?? '',
                  ),
                ]),

              const SizedBox(height: 16),

              if (owner.status.trim().toLowerCase() == 'pending')
                Obx(
                  () => Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.isActionLoading.value
                              ? null
                              : () => _confirmApprove(owner),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Approve Truck Owner'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: controller.isActionLoading.value
                              ? null
                              : _showRejectDialog,
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Reject Truck Owner'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      if (controller.isActionLoading.value)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            color: orange,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  // Profile header - same dimensions as Manufacturer module.
  Widget _profileHeader(TruckOwnerDetails item) {
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
            item.name.isEmpty ? 'Truck Owner' : item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${item.ownerId}',
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
              item.status.toUpperCase(),
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

  // Same section card size and padding as Manufacturer module.
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

  // Same vertical label/value arrangement as Manufacturer module.
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
            value.isEmpty ? 'Not provided' : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Self-driver details
  Widget _selfDriverSection(TruckOwnerSelfDriver driver) {
    return _section('Self-driver Details', [
      _detail('Self-driver ID', driver.selfDriverId.toString()),
      _detail(
        'Driving Licence Number',
        driver.drivingLicenceNumber,
      ),
      _detail('DL Type', driver.dlType),
      _detail('DL Issued Date', driver.dlIssuedDate),
      _detail('DL Expiry Date', driver.dlExpiredDate),
      _detail('Driver Status', driver.status),
      _detail(
        'Driver Rejection Reason',
        driver.rejectionReason ?? '',
      ),
      _detail(
        'Driver Reviewed At',
        driver.reviewedAt ?? '',
      ),

      if (driver.company != null) ...[
        _detail(
          'Company ID',
          driver.company!.companyId.toString(),
        ),
        _detail(
          'Company Name',
          driver.company!.companyName,
        ),
        _detail(
          'Company Status',
          driver.company!.status,
        ),
      ],

      const Divider(height: 24),

      _document('Aadhaar Card Document', driver.aadhaarCardDocument),
      _document('Driver Photo', driver.photo),
      _document('Aadhaar Front', driver.aadhaarFront),
      _document('Aadhaar Back', driver.aadhaarBack),
      _document('DL Front', driver.dlFront),
      _document('DL Back', driver.dlBack),
      _document('Medical Certificate', driver.medicalCertificate),
      _document(
        'Police Verification Certificate',
        driver.policeVerificationCertificate,
      ),
      _document('Company Bond Document', driver.companyBondDocument),
    ]);
  }

  // Same document card design as Manufacturer module.
  Widget _document(String title, String path) {
    final available = path.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: available
                  ? () => _openDocument(path)
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

  // Convert localhost document URLs to the configured backend host.
  String _mediaUrl(String path) {
    if (path.isEmpty) return '';

    final baseUri = Uri.tryParse(
      AppUrl.baseUrl.replaceFirst(
        RegExp(r'/user/?$'),
        '',
      ),
    );

    final mediaUri = Uri.tryParse(path);

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

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return path;
    }

    final normalized =
        path.startsWith('/') ? path : '/$path';

    return '${baseUri ?? Uri.parse(AppUrl.baseUrl)}$normalized';
  }

  Future<void> _openDocument(String path) async {
    final url = _mediaUrl(path);
    final uri = Uri.tryParse(url);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      Get.snackbar('Error', 'Invalid document URL.');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        Get.snackbar('Error', 'Unable to open the document.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to open the document: $e');
    }
  }

  // Approve confirmation
  Future<void> _confirmApprove(TruckOwnerDetails owner) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Approve Truck Owner?'),
        content: Text('Approve ${owner.name}?'),
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

    if (!mounted || confirm != true) return;

    final success =
        await controller.approveTruckOwner(widget.ownerId);

    if (!mounted) return;

    if (success) {
      final message = controller.actionMessage.value.isEmpty
          ? 'Truck owner approved successfully.'
          : controller.actionMessage.value;

      Get.back(result: true);
      Get.snackbar(
        'Approved',
        message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Approval Failed',
        controller.actionMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Reject dialog
  Future<void> _showRejectDialog() async {
    final reasonController = TextEditingController();

    try {
      final reason = await Get.dialog<String>(
        AlertDialog(
          title: const Text('Reject Truck Owner'),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
            maxLength: 500,
            decoration: const InputDecoration(
              labelText: 'Rejection reason',
              hintText: 'Enter the reason for rejection',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back<String>(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = reasonController.text.trim();

                if (value.isEmpty) {
                  Get.snackbar(
                    'Required',
                    'Please enter a rejection reason.',
                  );
                  return;
                }

                Get.back<String>(result: value);
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

      final success = await controller.rejectTruckOwner(
        ownerId: widget.ownerId,
        rejectionReason: reason.trim(),
      );

      if (!mounted) return;

      if (success) {
        final message = controller.actionMessage.value.isEmpty
            ? 'Truck owner rejected successfully.'
            : controller.actionMessage.value;

        Get.back(result: true);
        Get.snackbar(
          'Rejected',
          message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Rejection Failed',
          controller.actionMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      reasonController.dispose();
    }
  }
}

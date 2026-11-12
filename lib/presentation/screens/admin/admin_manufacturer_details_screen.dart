import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/storage/colors.dart';
import '../../../data/controllers/admin_manufacturer_controller.dart';
import '../../../data/models/admin_manufacturer_model.dart';

class AdminManufacturerDetailsScreen extends StatefulWidget {
  final int manufacturerId;

  const AdminManufacturerDetailsScreen({
    super.key,
    required this.manufacturerId,
  });

  @override
  State<AdminManufacturerDetailsScreen> createState() =>
      _AdminManufacturerDetailsScreenState();
}

class _AdminManufacturerDetailsScreenState
    extends State<AdminManufacturerDetailsScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color dark = Color(0xFF171717);

  late final AdminManufacturerController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminManufacturerController>()
        ? Get.find<AdminManufacturerController>()
        : Get.put(AdminManufacturerController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.fetchManufacturerDetails(widget.manufacturerId);
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
          'Manufacturer Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                controller.fetchManufacturerDetails(widget.manufacturerId),
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

        final manufacturer = controller.selectedManufacturer.value;

        if (manufacturer == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 45),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value.isEmpty
                        ? 'Unable to load manufacturer details.'
                        : controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => controller.fetchManufacturerDetails(
                      widget.manufacturerId,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: orange,
          onRefresh: () => controller.fetchManufacturerDetails(
            widget.manufacturerId,
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _profileHeader(manufacturer),
              const SizedBox(height: 16),

              _section('Company Details', [
                _detail('Company Name', manufacturer.companyName),
                _detail('GST Number', manufacturer.gstNumber),
                _detail(
                  'Registration Number',
                  manufacturer.companyRegistrationNumber,
                ),
                _detail(
                  'Year of Establishment',
                  manufacturer.yearOfEstablishment?.toString() ?? '',
                ),
                _detail(
                  'Landline Number',
                  manufacturer.companyLandlineNumber,
                ),
              ]),

              _section('Contact Person Details', [
                _detail('Contact Person', manufacturer.contactPersonName),
                _detail('Mobile Number', manufacturer.mobileNumber),
                _detail('Email Address', manufacturer.emailAddress),
              ]),

              _section('Factory and Business Details', [
                _detail('Factory Address', manufacturer.factoryAddress),
                _detail('City', manufacturer.city),
                _detail('State', manufacturer.state),
                _detail('PIN Code', manufacturer.pinCode),
                _detail('Country', manufacturer.country),
                _detail(
                  'Product Categories',
                  manufacturer.productCategories.join(', '),
                ),
              ]),

              _section('Verification Documents', [
                _document(
                  'Company Registration Certificate',
                  manufacturer.companyRegistrationCertificate,
                ),
                _document(
                  'GST Certificate',
                  manufacturer.gstCertificate,
                ),
                _document(
                  'Business Address Proof',
                  manufacturer.businessAddressProof,
                ),
              ]),

              if (manufacturer.rejectionReason.isNotEmpty)
                _section('Rejection Information', [
                  _detail('Reason', manufacturer.rejectionReason),
                  _detail('Reviewed At', manufacturer.createdAt),
                ]),

              const SizedBox(height: 16),

              if (manufacturer.status.trim().toLowerCase() == 'pending')
                Obx(
                  () => Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.isReviewing.value
                              ? null
                              : () => _confirmApprove(manufacturer),
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Approve Manufacturer'),
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
                          onPressed: controller.isReviewing.value
                              ? null
                              : () => _showRejectDialog(manufacturer),
                          icon: const Icon(Icons.cancel_outlined),
                          label: const Text('Reject Manufacturer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      if (controller.isReviewing.value)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(color: orange),
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

  Widget _profileHeader(AdminManufacturerModel item) {
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
            item.companyName.isEmpty ? 'Manufacturer' : item.companyName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${item.manufacturerId}',
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

  Widget _document(String title, String url) {
    final available = url.isNotEmpty;

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
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: available ? () => _openDocument(url) : null,
              child: Text(available ? 'View' : 'Unavailable'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDocument(String value) async {
    final uri = Uri.tryParse(value);

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

  Future<void> _confirmApprove(
    AdminManufacturerModel manufacturer,
  ) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Approve Manufacturer?'),
        content: Text('Approve ${manufacturer.companyName}?'),
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

    await controller.reviewManufacturer(
      manufacturerId: manufacturer.manufacturerId,
      approve: true,
    );
  }

  Future<void> _showRejectDialog(
    AdminManufacturerModel manufacturer,
  ) async {
    final reasonController = TextEditingController();

    try {
      final reason = await Get.dialog<String>(
        AlertDialog(
          title: const Text('Reject Manufacturer'),
          content: TextField(
            controller: reasonController,
            maxLines: 3,
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

      if (!mounted || reason == null || reason.trim().isEmpty) return;

      await controller.reviewManufacturer(
        manufacturerId: manufacturer.manufacturerId,
        approve: false,
        rejectionReason: reason.trim(),
      );
    } finally {
      reasonController.dispose();
    }
  }
}

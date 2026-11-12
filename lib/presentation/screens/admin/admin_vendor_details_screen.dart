import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/storage/colors.dart';
import '../../../core/constants/app url.dart';
import '../../../data/controllers/admin_vendor_controller.dart';
import '../../../data/models/admin_vendor_model.dart';

class AdminVendorDetailsScreen extends StatefulWidget {
  final int vendorId;

  const AdminVendorDetailsScreen({
    super.key,
    required this.vendorId,
  });

  @override
  State<AdminVendorDetailsScreen> createState() =>
      _AdminVendorDetailsScreenState();
}

class _AdminVendorDetailsScreenState
    extends State<AdminVendorDetailsScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color dark = Color(0xFF171717);

  late final AdminVendorController controller;
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminVendorController>()
        ? Get.find<AdminVendorController>()
        : Get.put(AdminVendorController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadVendorDetails();
    });
  }

  Future<void> _loadVendorDetails() async {
    await controller.fetchVendorDetails(widget.vendorId);
  }

  Future<void> _refreshDetails() async {
    await _loadVendorDetails();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  String _mediaUrl(String path) {
    if (path.trim().isEmpty) return '';

    final serverBaseUrl = AppUrl.baseUrl.replaceFirst(
      RegExp(r'/user/?$'),
      '',
    );

    final uri = Uri.tryParse(path);
    final baseUri = Uri.tryParse(serverBaseUrl);

    if (uri != null &&
        baseUri != null &&
        (uri.host == '127.0.0.1' || uri.host == 'localhost')) {
      return uri.replace(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : uri.port,
      ).toString();
    }

    if (uri != null && uri.hasScheme) return path;

    final normalized = path.startsWith('/') ? path : '/$path';
    return '$serverBaseUrl$normalized';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: dark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Vendor Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _refreshDetails,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final vendor = controller.selectedVendor.value;

        if (controller.isDetailsLoading.value && vendor == null) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (vendor == null) return _errorView();

        return RefreshIndicator(
          color: orange,
          onRefresh: _refreshDetails,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _profileHeader(vendor),
              const SizedBox(height: 16),

              _section('Personal Details', [
                _detail('Full Name', vendor.fullName),
                _detail('Email', vendor.email),
                _detail('Mobile Number', vendor.mobileNumber),
                _detail('Alternate Mobile', vendor.alternateMobileNumber),
              ]),

              _section('Business Details', [
                _detail('Business Name', vendor.businessName),
                _detail('Business Type', vendor.businessType),
                _detail('Business Category', vendor.businessCategory),
                _detail('GST Number', vendor.gstNumber),
                _detail(
                  'Registration Number',
                  vendor.businessRegistrationNumber,
                ),
                _detail(
                  'Years in Business',
                  vendor.yearsInBusiness?.toString() ?? '',
                ),
              ]),

              _section('Business Address', [
                _detail('Address Line 1', vendor.addressLine1),
                _detail('Address Line 2', vendor.addressLine2),
                _detail('City', vendor.city),
                _detail('District', vendor.district),
                _detail('State', vendor.state),
                _detail('PIN Code', vendor.pincode),
              ]),

              _documentSection(vendor),

              if (vendor.status.toLowerCase() == 'rejected')
                _section('Rejection Information', [
                  _detail('Reason', vendor.rejectionReason),
                  _detail('Reviewed At', vendor.reviewedAt),
                ]),


              const SizedBox(height: 8),

              if (vendor.status.toLowerCase() == 'pending')
                _actionButtons()
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'This registration is ${vendor.status}. '
                    'No further action is available here.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _profileHeader(AdminVendorModel vendor) {
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
            vendor.fullName.isEmpty ? 'Vendor' : vendor.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Vendor ID: ${vendor.vendorId}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          _statusChip(vendor.status),
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

  Widget _documentSection(AdminVendorModel vendor) {
    final documents = <MapEntry<String, String>>[
      MapEntry('GST Certificate', vendor.gstCertificate),
      MapEntry('Business Address Proof', vendor.addressProof),
      MapEntry('Transport Permit', vendor.transportPermitDocument),
      MapEntry('Business License', vendor.businessLicense),
    ];

    return _section(
      'Vendor Documents',
      documents
          .map((document) => _document(document.key, document.value))
          .toList(),
    );
  }

  Widget _document(String title, String path) {
    final available = path.trim().isNotEmpty;
    final filename = available
        ? (Uri.tryParse(path)?.path.split('/').last ?? path.split('/').last)
        : 'Document unavailable';

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
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    filename,
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
              onPressed:
                  available ? () => _showDocument(title, path) : null,
              child: Text(available ? 'View' : 'Unavailable'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDocument(String title, String path) async {
    final url = _mediaUrl(path);
    final uri = Uri.tryParse(url);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      Get.snackbar(
        'Invalid Document',
        'Unable to open this document URL.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

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
                  child: Text('Unable to load this image.'),
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
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _statusChip(String status) {
    final normalized = status.trim().toLowerCase();
    final color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    final label = normalized.isEmpty
        ? 'UNKNOWN'
        : normalized.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: orange.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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
              label: const Text('Approve Vendor'),
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
              label: const Text('Reject Vendor'),
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

  Future<void> _approve() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Approve Vendor?'),
        content: const Text(
          'Are you sure you want to approve this vendor registration?',
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

    final success = await controller.approveVendor(widget.vendorId);
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

  Future<void> _showRejectDialog() async {
    reasonController.clear();

    final reason = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Reject Vendor'),
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

    if (!mounted || reason == null || reason.trim().isEmpty) return;

    final success = await controller.rejectVendor(
      vendorId: widget.vendorId,
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

  Widget _errorView() {
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
                  ? 'Unable to load vendor details.'
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

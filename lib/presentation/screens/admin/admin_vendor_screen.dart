import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/storage/colors.dart';
import '../../../data/controllers/admin_vendor_controller.dart';
import '../../../data/models/admin_vendor_model.dart';
import 'admin_vendor_details_screen.dart';

class AdminVendorScreen extends StatelessWidget {
  AdminVendorScreen({super.key});

  final AdminVendorController controller =
      Get.put(AdminVendorController());

  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);
  static const Color background = Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Vendor Requests',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: orange,
        foregroundColor: black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.fetchVendors(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.pendingVendors.isEmpty &&
            controller.approvedVendors.isEmpty &&
            controller.rejectedVendors.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: orange,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.pendingVendors.isEmpty &&
            controller.approvedVendors.isEmpty &&
            controller.rejectedVendors.isEmpty) {
          return _errorView();
        }

        final vendors = controller.filteredVendors;

        return RefreshIndicator(
          color: orange,
          onRefresh: () => controller.fetchVendors(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              _summaryCards(),

              const SizedBox(height: 18),

              const Text(
                'Registration Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),

              const SizedBox(height: 12),

              _filterSection(),

              const SizedBox(height: 14),

              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),

              if (vendors.isEmpty)
                _emptyView()
              else
                ...vendors.map(_vendorCard),
            ],
          ),
        );
      }),
    );
  }

  // Summary cards
  Widget _summaryCards() {
    final summary = controller.summary.value;

    return Row(
      children: [
        _summaryCard(
          'Total',
          summary.total,
          black,
        ),
        _summaryCard(
          'Pending',
          summary.pending,
          orange,
        ),
        _summaryCard(
          'Approved',
          summary.approved,
          Colors.green,
        ),
        _summaryCard(
          'Rejected',
          summary.rejected,
          Colors.red,
        ),
      ],
    );
  }

  Widget _summaryCard(
    String title,
    int count,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 3,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Status filters
  Widget _filterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('All', 'all'),
          _filterChip('Pending', 'pending'),
          _filterChip('Approved', 'approved'),
          _filterChip('Rejected', 'rejected'),
        ],
      ),
    );
  }

  Widget _filterChip(
    String label,
    String value,
  ) {
    return Obx(() {
      final selected =
          controller.selectedStatus.value == value;

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          selectedColor: orange.withValues(alpha: 0.18),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: selected ? orange : Colors.black12,
          ),
          labelStyle: TextStyle(
            color: selected ? black : Colors.black54,
            fontWeight: selected
                ? FontWeight.bold
                : FontWeight.w500,
          ),
          onSelected: (_) {
            controller.changeStatus(value);
          },
        ),
      );
    });
  }

  // Vendor registration card
  Widget _vendorCard(AdminVendorModel vendor) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () async {
          await Get.to(
            () => AdminVendorDetailsScreen(
              vendorId: vendor.vendorId,
            ),
          );

          await controller.fetchVendors(
            showLoader: false,
          );
        },

        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        orange.withValues(alpha: 0.18),
                    child: const Icon(
                      colours.person,
                      color: black,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor.fullName.isEmpty
                              ? 'Vendor'
                              : vendor.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          vendor.businessName.isEmpty
                              ? 'Business name not provided'
                              : vendor.businessName,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),

                  _statusBadge(vendor.status),
                ],
              ),

              const Divider(height: 24),

              _infoLine(
                Icons.phone_outlined,
                vendor.mobileNumber,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.category_outlined,
                vendor.businessCategory,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.location_on_outlined,
                [
                  vendor.city,
                  vendor.state,
                ]
                    .where(
                      (part) => part.trim().isNotEmpty,
                    )
                    .join(', '),
              ),

              const SizedBox(height: 14),

              const Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 5),

                    Icon(
                      Icons.chevron_right,
                      color: orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Information row
  Widget _infoLine(
    IconData icon,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.black54,
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Text(
            value.trim().isEmpty
                ? 'Not provided'
                : value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // Status badge
  Widget _statusBadge(String status) {
    final normalized = status.trim().toLowerCase();

    final Color color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    final displayStatus = normalized.isEmpty
        ? 'Pending'
        : '${normalized[0].toUpperCase()}${normalized.substring(1)}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Empty view
  Widget _emptyView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 64,
            color: Colors.grey,
          ),

          SizedBox(height: 16),

          Text(
            'No vendor requests found.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Error view
  Widget _errorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 55,
              color: Colors.grey,
            ),

            const SizedBox(height: 12),

            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: black,
              ),
              onPressed: () {
                controller.fetchVendors();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
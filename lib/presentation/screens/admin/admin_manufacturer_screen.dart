import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/storage/colors.dart';
import '../../../data/controllers/admin_manufacturer_controller.dart';
import '../../../data/models/admin_manufacturer_model.dart';
import 'admin_manufacturer_details_screen.dart';

class AdminManufacturerScreen extends StatelessWidget {
  AdminManufacturerScreen({super.key});

  final AdminManufacturerController controller =
      Get.put(AdminManufacturerController());

  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);
  static const Color background = Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Manufacturer Requests',
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
            onPressed: () => controller.fetchManufacturers(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.manufacturers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.manufacturers.isEmpty) {
          return _errorView();
        }

        final items = controller.filteredManufacturers;

        return RefreshIndicator(
          color: orange,
          onRefresh: () => controller.fetchManufacturers(),
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
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              if (items.isEmpty)
                _emptyView()
              else
                ...items.map(_manufacturerCard),
            ],
          ),
        );
      }),
    );
  }

  // Summary cards styled like the Admin Driver screen.
  Widget _summaryCards() {
    return Row(
      children: [
        _summaryCard(
          'Total',
          controller.manufacturers.length,
          black,
        ),
        _summaryCard(
          'Pending',
          controller.pendingCount,
          orange,
        ),
        _summaryCard(
          'Approved',
          controller.approvedCount,
          Colors.green,
        ),
        _summaryCard(
          'Rejected',
          controller.rejectedCount,
          Colors.red,
        ),
      ],
    );
  }

  Widget _summaryCard(String title, int count, Color color) {
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

  // Existing status filter behavior is preserved.
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

  Widget _filterChip(String label, String value) {
    return Obx(() {
      final selected = controller.selectedStatus.value == value;

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
            fontWeight:
                selected ? FontWeight.bold : FontWeight.w500,
          ),
          onSelected: (_) => controller.changeStatusFilter(value),
        ),
      );
    });
  }

  Widget _manufacturerCard(AdminManufacturerModel item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Get.to(
            () => AdminManufacturerDetailsScreen(
              manufacturerId: item.manufacturerId,
            ),
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
                    backgroundColor: orange.withValues(alpha: 0.18),
                    child: const Icon(
                      colours.person,
                      color: black,
                    ),
                  ),


                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.companyName.isEmpty
                              ? 'Manufacturer'
                              : item.companyName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.contactPersonName.isEmpty
                              ? 'Contact person not provided'
                              : item.contactPersonName,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),
                  _statusBadge(item.status),
                ],
              ),

              const Divider(height: 24),

              _infoLine(
                Icons.phone_outlined,
                item.mobileNumber,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.email_outlined,
                item.emailAddress,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.location_on_outlined,
                '${item.city}, ${item.state}',
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

  Widget _infoLine(IconData icon, String value) {
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
            value.trim().isEmpty ? 'Not provided' : value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    final normalized = status.toLowerCase();

    final Color color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    final displayStatus = status.trim().isEmpty
        ? 'Pending'
        : '${status[0].toUpperCase()}${status.substring(1)}';

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

  Widget _emptyView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.factory_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No manufacturer requests found.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

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
              onPressed: () => controller.fetchManufacturers(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

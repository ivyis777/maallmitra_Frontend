

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controllers/admin_driver_controller.dart';
import '../../../data/models/admin_driver_model.dart';
import '../../../core/storage/colors.dart';
import 'admin_driver_details_screen.dart';

class AdminDriverScreen extends StatefulWidget {
  const AdminDriverScreen({super.key});

  @override
  State<AdminDriverScreen> createState() =>
      _AdminDriverScreenState();
}

class _AdminDriverScreenState extends State<AdminDriverScreen> {
  late final AdminDriverController controller;

  final RxString selectedStatus = 'all'.obs;

  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);
  static const Color background = Color(0xFFF7F7F7);

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminDriverController>()
        ? Get.find<AdminDriverController>()
        : Get.put(AdminDriverController());

    controller.fetchDrivers();
  }

  // Get all drivers based on selected status.
  List<AdminDriver> get filteredDrivers {
    final pending = controller.pendingDrivers;
    final approved = controller.approvedDrivers;
    final rejected = controller.rejectedDrivers;

    switch (selectedStatus.value) {
      case 'pending':
        return pending;

      case 'approved':
        return approved;

      case 'rejected':
        return rejected;

      default:
        return [
          ...pending,
          ...approved,
          ...rejected,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Driver Requests',
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
            onPressed: () => controller.fetchDrivers(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.driverResponse.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.driverResponse.value == null) {
          return _errorView();
        }

        final items = filteredDrivers;
        final summary = controller.summary;

        return RefreshIndicator(
          color: orange,
          onRefresh: () => controller.fetchDrivers(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            children: [
              // Summary cards
              _summaryCards(
                total: summary?.total ?? 0,
                pending: summary?.pending ?? 0,
                approved: summary?.approved ?? 0,
                rejected: summary?.rejected ?? 0,
              ),

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

              // Status filters
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

              // Driver list
              if (items.isEmpty)
                _emptyView()
              else
                ...items.map(_driverCard),
            ],
          ),
        );
      }),
    );
  }

  // SUMMARY CARDS
  Widget _summaryCards({
    required int total,
    required int pending,
    required int approved,
    required int rejected,
  }) {
    return Row(
      children: [
        _summaryCard('Total', total, black),
        _summaryCard('Pending', pending, orange),
        _summaryCard('Approved', approved, Colors.green),
        _summaryCard('Rejected', rejected, Colors.red),
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

  // STATUS FILTER SECTION
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
      final selected = selectedStatus.value == value;

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
          onSelected: (_) {
            selectedStatus.value = value;
          },
        ),
      );
    });
  }

  // DRIVER REGISTRATION CARD
  Widget _driverCard(AdminDriver driver) {
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
            () => AdminDriverDetailsScreen(
              registrationId: driver.id,
            ),
          );

          await controller.fetchDrivers(showLoader: false);
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
                          driver.name.isEmpty
                              ? 'Driver'
                              : driver.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          driver.companyName.isEmpty
                              ? 'Company not provided'
                              : driver.companyName,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),

                  _statusBadge(driver.status),
                ],
              ),

              const Divider(height: 24),

              _infoLine(
                Icons.phone_outlined,
                driver.mobileNumber,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.badge_outlined,
                driver.drivingLicenceNumber,
              ),

              const SizedBox(height: 9),

              _infoLine(
                Icons.business_outlined,
                driver.companyType,
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

  // INFORMATION ROW
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

  // STATUS BADGE
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

  // EMPTY VIEW
  Widget _emptyView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No driver requests found.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
              onPressed: () => controller.fetchDrivers(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

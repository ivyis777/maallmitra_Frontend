
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/storage/colors.dart';
import '../../../data/controllers/admin_driver_controller.dart';
import '../../../data/models/admin_driver_model.dart';
import 'admin_driver_details_screen.dart';

class AdminDriverScreen extends StatefulWidget {
  const AdminDriverScreen({super.key});

  @override
  State<AdminDriverScreen> createState() =>
      _AdminDriverScreenState();
}

class _AdminDriverScreenState extends State<AdminDriverScreen>
    with SingleTickerProviderStateMixin {
  late final AdminDriverController controller;
  late final TabController tabController;

  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);
  static const Color background = Color(0xFFF7F7F7);

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminDriverController>()
        ? Get.find<AdminDriverController>()
        : Get.put(AdminDriverController());

    tabController = TabController(length: 3, vsync: this);
    controller.fetchDrivers();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: orange,
        foregroundColor: black,
        elevation: 0,
        title: const Text(
          'Driver Registrations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => controller.fetchDrivers(),
            icon: const Icon(Icons.refresh),
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

        if (controller.driverResponse.value == null) {
          return _errorView(
            controller.errorMessage.value.isEmpty
                ? 'Unable to load driver registrations.'
                : controller.errorMessage.value,
          );
        }

        final summary = controller.summary;

        return Column(
          children: [
            _summaryCards(
              total: summary?.total ?? 0,
              pending: summary?.pending ?? 0,
              approved: summary?.approved ?? 0,
              rejected: summary?.rejected ?? 0,
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: tabController,
                labelColor: orange,
                unselectedLabelColor: Colors.black54,
                indicatorColor: orange,
                indicatorWeight: 3,
                tabs: [
                  Tab(
                    text:
                        'Pending (${controller.pendingDrivers.length})',
                  ),
                  Tab(
                    text:
                        'Approved (${controller.approvedDrivers.length})',
                  ),
                  Tab(
                    text:
                        'Rejected (${controller.rejectedDrivers.length})',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _driverList(controller.pendingDrivers),
                  _driverList(controller.approvedDrivers),
                  _driverList(controller.rejectedDrivers),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryCards({
    required int total,
    required int pending,
    required int approved,
    required int rejected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _summaryCard('Total', total, black),
          _summaryCard('Pending', pending, orange),
          _summaryCard('Approved', approved, Colors.green),
          _summaryCard('Rejected', rejected, Colors.red),
        ],
      ),
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
          border: Border.all(color: color.withValues(alpha: 0.25)),
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

  Widget _driverList(List<AdminDriver> drivers) {
    if (drivers.isEmpty) {
      return RefreshIndicator(
        color: orange,
        onRefresh: () => controller.fetchDrivers(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 140),
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No driver registrations found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: orange,
      onRefresh: () => controller.fetchDrivers(),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: drivers.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final driver = drivers[index];

          return Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                backgroundColor: orange.withValues(alpha: 0.18),
                child: const Icon(
                  Icons.person_outline,
                  color: black,
                ),
              ),
              title: Text(
                driver.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.companyName),
                    const SizedBox(height: 3),
                    Text('DL: ${driver.drivingLicenceNumber}'),
                    const SizedBox(height: 5),
                    _statusChip(driver.status),
                  ],
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: orange,
              ),
              // onTap: () async {
              //   await Get.to(
              //     () => AdminDriverDetailsScreen(
              //       registrationId: driver.id,
              //     ),
              //   );

              //   if (mounted) {
              //     controller.fetchDrivers(showLoader: false);
              //   }
              // },
              onTap: () async {
  final result = await Get.to(
    () => AdminDriverDetailsScreen(
      registrationId: driver.id,
    ),
  );

  controller.fetchDrivers(showLoader: false);
},

            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final normalized = status.toLowerCase();

    final Color color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.isEmpty
            ? 'Unknown'
            : '${status[0].toUpperCase()}${status.substring(1)}',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _errorView(String message) {
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
              message,
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

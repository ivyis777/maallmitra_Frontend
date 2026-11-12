import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controllers/admin_truck_owner_controller.dart';
import '../../../data/models/admin_truck_owner_model.dart';
import 'admin_truck_owner_details_screen.dart';

class AdminTruckOwnerScreen extends StatefulWidget {
  const AdminTruckOwnerScreen({super.key});

  @override
  State<AdminTruckOwnerScreen> createState() =>
      _AdminTruckOwnerScreenState();
}

class _AdminTruckOwnerScreenState extends State<AdminTruckOwnerScreen> {
  static const Color orange = Color(0xFFFF9800);
  static const Color black = Color(0xFF171717);
  static const Color background = Color(0xFFF7F7F7);

  late final AdminTruckOwnerController controller;
  String selectedStatus = 'all';

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<AdminTruckOwnerController>()
        ? Get.find<AdminTruckOwnerController>()
        : Get.put(AdminTruckOwnerController());

    controller.fetchTruckOwners();
  }

  List<AdminTruckOwner> _filteredOwners() {
    final allOwners = [
      ...controller.pendingOwners,
      ...controller.approvedOwners,
      ...controller.rejectedOwners,
    ];

    switch (selectedStatus) {
      case 'pending':
        return controller.pendingOwners;
      case 'approved':
        return controller.approvedOwners;
      case 'rejected':
        return controller.rejectedOwners;
      default:
        return allOwners;
    }
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
          'Truck Owner Registrations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => controller.fetchTruckOwners(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final hasOwners = controller.pendingOwners.isNotEmpty ||
            controller.approvedOwners.isNotEmpty ||
            controller.rejectedOwners.isNotEmpty;

        if (controller.isLoading.value && !hasOwners) {
          return const Center(
            child: CircularProgressIndicator(color: orange),
          );
        }

        if (controller.response.value == null) {
          return _errorView(
            controller.errorMessage.value.isEmpty
                ? 'Unable to load truck owner registrations.'
                : controller.errorMessage.value,
          );
        }

        return Column(
          children: [
            _summaryCards(),
            _statusFilters(),
            if (controller.errorMessage.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                child: Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: _ownerList(_filteredOwners()),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryCards() {
    final summary = controller.summary;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _summaryCard('Total', summary?.total ?? 0, black),
          _summaryCard('Pending', summary?.pending ?? 0, orange),
          _summaryCard('Approved', summary?.approved ?? 0, Colors.green),
          _summaryCard('Rejected', summary?.rejected ?? 0, Colors.red),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 3,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
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

  Widget _statusFilters() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip('All', 'all'),
            _filterChip('Pending', 'pending'),
            _filterChip('Approved', 'approved'),
            _filterChip('Rejected', 'rejected'),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = selectedStatus == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: orange.withValues(alpha: 0.18),
        labelStyle: TextStyle(
          color: selected ? black : Colors.black54,
          fontWeight:
              selected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: selected ? orange : Colors.black12,
        ),
        onSelected: (_) {
          setState(() {
            selectedStatus = value;
          });
        },
      ),
    );
  }

  Widget _ownerList(List<AdminTruckOwner> owners) {
    if (owners.isEmpty) {
      return RefreshIndicator(
        color: orange,
        onRefresh: () => controller.fetchTruckOwners(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(
              Icons.person_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No truck owner registrations found',
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
      onRefresh: () => controller.fetchTruckOwners(),
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: owners.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final owner = owners[index];

          return Card(
            elevation: 1,
            color: Colors.white,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0x29FF9800),
                child: Icon(
                  Icons.person,
                  color: black,
                  size: 28,
                ),
              ),
              title: Text(
                owner.name.isEmpty ? 'Unnamed Owner' : owner.name,
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
                    Text('Owner ID: ${owner.ownerId}'),
                    const SizedBox(height: 3),
                    Text('Mobile: ${owner.mobileNumber}'),
                    const SizedBox(height: 3),
                    Text(
                      owner.isSelfDriver
                          ? 'Self-driver'
                          : 'Owner only',
                    ),
                    const SizedBox(height: 7),
                    _statusChip(owner.status),
                  ],
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: orange,
              ),
              onTap: () async {
                await Get.to(
                  () => AdminTruckOwnerDetailsScreen(
                    ownerId: owner.ownerId,
                  ),
                );

                if (mounted) {
                  await controller.fetchTruckOwners(
                    showLoader: false,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    final normalized = status.trim().toLowerCase();

    final color = normalized == 'approved'
        ? Colors.green
        : normalized == 'rejected'
            ? Colors.red
            : orange;

    final label = normalized.isEmpty
        ? 'Unknown'
        : '${normalized[0].toUpperCase()}${normalized.substring(1)}';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
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
              onPressed: () => controller.fetchTruckOwners(),
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
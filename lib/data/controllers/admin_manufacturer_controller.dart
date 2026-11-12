import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/admin_manufacturer_model.dart';
import '../../services/admin_manufacturer_service.dart';
class AdminManufacturerController extends GetxController {
  final AdminManufacturerService _service =
      AdminManufacturerService();
  final RxList<AdminManufacturerModel> manufacturers =
      <AdminManufacturerModel>[].obs;
  final Rxn<AdminManufacturerModel> selectedManufacturer =
     Rxn<AdminManufacturerModel>();
  final RxBool isLoading = false.obs;
  final RxBool isDetailsLoading = false.obs;
  final RxBool isReviewing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedStatus = 'all'.obs;
  // Normalize statuses to avoid case-sensitive filter issues.
  String _normalizeStatus(String? status) {
    return (status ?? '').trim().toLowerCase();
  }

  List<AdminManufacturerModel> get filteredManufacturers {
    final filter = _normalizeStatus(selectedStatus.value);

    if (filter == 'all') {
      return manufacturers.toList();
    }

    return manufacturers
        .where((item) => _normalizeStatus(item.status) == filter)
        .toList();
  }

  int get pendingCount => manufacturers
      .where((e) => _normalizeStatus(e.status) == 'pending')
      .length;

  int get approvedCount => manufacturers
      .where((e) => _normalizeStatus(e.status) == 'approved')
      .length;

  int get rejectedCount => manufacturers
      .where((e) => _normalizeStatus(e.status) == 'rejected')
      .length;

  @override
  void onInit() {
    super.onInit();
    fetchManufacturers();
  }
  // Fetch all registrations.
  Future<void> fetchManufacturers() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.fetchManufacturers();
      manufacturers.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Fetch manufacturers error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // Fetch one manufacturer's details.
  Future<void> fetchManufacturerDetails(int id) async {
    isDetailsLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _service.fetchManufacturerDetails(id);
      selectedManufacturer.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Fetch manufacturer details error: $e');
    } finally {
      isDetailsLoading.value = false;
    }
  }
  void changeStatusFilter(String status) {
    selectedStatus.value = _normalizeStatus(status);
  }
  // Approve or reject a manufacturer registration.
  Future<bool> reviewManufacturer({
    required int manufacturerId,
    required bool approve,
    String rejectionReason = '',
  }) async {
    if (isReviewing.value) return false;

    if (!approve && rejectionReason.trim().isEmpty) {
      Get.snackbar(
        'Rejection Reason Required',
        'Please enter a reason before rejecting this registration.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    isReviewing.value = true;
    try {
      final response = await _service.reviewManufacturer(
        manufacturerId: manufacturerId,
        approve: approve,
        rejectionReason: rejectionReason.trim(),
      );

      debugPrint('Manufacturer review response: $response');

      Get.snackbar(
        'Success',
        approve
            ? 'Manufacturer approved successfully.'
            : 'Manufacturer rejected successfully.',
        snackPosition: SnackPosition.TOP,
      );

      // Refresh the list after the backend confirms success.
      await fetchManufacturers();

      // Refresh the selected manufacturer's details.
      await fetchManufacturerDetails(manufacturerId);

      return true;
    } catch (e) {
      debugPrint('Manufacturer review error: $e');

      Get.snackbar(
        'Request Failed',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );

      return false;
    } finally {
      isReviewing.value = false;
    }
  }
}

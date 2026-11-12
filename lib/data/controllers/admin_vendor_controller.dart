import 'package:get/get.dart';

import '../models/admin_vendor_model.dart';
import '../../services/admin_vendor_service.dart';

class AdminVendorController extends GetxController {
  final AdminVendorService _service = AdminVendorService();

  final isLoading = false.obs;
  final isDetailsLoading = false.obs;
  final isActionLoading = false.obs;

  final errorMessage = ''.obs;
  final detailsError = ''.obs;
  final actionMessage = ''.obs;

  final summary = const AdminVendorSummary().obs;

  final pendingVendors = <AdminVendorModel>[].obs;
  final approvedVendors = <AdminVendorModel>[].obs;
  final rejectedVendors = <AdminVendorModel>[].obs;

  final selectedStatus = 'all'.obs;
  final selectedVendor = Rxn<AdminVendorModel>();

  List<AdminVendorModel> get filteredVendors {
    switch (selectedStatus.value) {
      case 'pending':
        return pendingVendors.toList();
      case 'approved':
        return approvedVendors.toList();
      case 'rejected':
        return rejectedVendors.toList();
      case 'all':
      default:
        return [
          ...pendingVendors,
          ...approvedVendors,
          ...rejectedVendors,
        ];
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchVendors();
  }

  Future<void> fetchVendors({bool showLoader = true}) async {
    if (showLoader && isLoading.value) return;

    if (showLoader) isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.fetchVendors();
      final vendors = response['vendors'];

      if (vendors is! Map) {
        throw Exception('Vendor list missing from server response.');
      }

      final groups = Map<String, dynamic>.from(vendors);
      final summaryJson = groups['summary'];

      if (summaryJson is Map) {
        summary.value = AdminVendorSummary.fromJson(
          Map<String, dynamic>.from(summaryJson),
        );
      }

      List<AdminVendorModel> parseGroup(String key) {
        final items = groups[key];
        if (items is! List) return [];

        return items
            .whereType<Map>()
            .map(
              (item) => AdminVendorModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      pendingVendors.assignAll(parseGroup('pending'));
      approvedVendors.assignAll(parseGroup('approved'));
      rejectedVendors.assignAll(parseGroup('rejected'));
    } catch (e) {
      errorMessage.value = _cleanError(e);
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }

  void changeStatus(String status) {
    selectedStatus.value = status.toLowerCase();
  }

  Future<bool> fetchVendorDetails(int vendorId) async {
    isDetailsLoading.value = true;
    detailsError.value = '';
    selectedVendor.value = null;

    try {
      selectedVendor.value = await _service.fetchVendorDetails(vendorId);
      return true;
    } catch (e) {
      detailsError.value = _cleanError(e);
      return false;
    } finally {
      isDetailsLoading.value = false;
    }
  }

  Future<bool> approveVendor(int vendorId) async {
    if (isActionLoading.value) return false;

    isActionLoading.value = true;
    actionMessage.value = '';

    try {
      final response = await _service.approveVendor(vendorId);
      actionMessage.value = response['message']?.toString() ??
          'Vendor approved successfully.';

      await fetchVendors(showLoader: false);
      await fetchVendorDetails(vendorId);
      return true;
    } catch (e) {
      actionMessage.value = _cleanError(e);
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> rejectVendor({
    required int vendorId,
    required String rejectionReason,
  }) async {
    if (isActionLoading.value) return false;

    final reason = rejectionReason.trim();
    if (reason.isEmpty) {
      actionMessage.value = 'Please enter a rejection reason.';
      return false;
    }

    isActionLoading.value = true;
    actionMessage.value = '';

    try {
      final response = await _service.rejectVendor(
        vendorId: vendorId,
        rejectionReason: reason,
      );

      actionMessage.value = response['message']?.toString() ??
          'Vendor rejected successfully.';

      await fetchVendors(showLoader: false);
      await fetchVendorDetails(vendorId);
      return true;
    } catch (e) {
      actionMessage.value = _cleanError(e);
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  String _cleanError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}

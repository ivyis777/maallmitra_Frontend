
import 'package:get/get.dart';

import '../models/admin_truck_owner_model.dart';
import '../models/truck_owner_details_model.dart';
import '/services/admin_truck_owner_service.dart';
class AdminTruckOwnerController extends GetxController {
  final AdminTruckOwnerService _service =
      AdminTruckOwnerService();
  final Rxn<AdminTruckOwnerModel> response =
      Rxn<AdminTruckOwnerModel>();
  final Rxn<TruckOwnerDetailsModel> details =
      Rxn<TruckOwnerDetailsModel>();
  final RxBool isLoading = false.obs;
  final RxBool isDetailsLoading = false.obs;
  final RxBool isActionLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString detailsError = ''.obs;
  final RxString actionMessage = ''.obs;
  List<AdminTruckOwner> get pendingOwners =>
      response.value?.pending ?? [];
  List<AdminTruckOwner> get approvedOwners =>
      response.value?.approved ?? [];
  List<AdminTruckOwner> get rejectedOwners =>
      response.value?.rejected ?? [];
  TruckOwnerSummary? get summary => response.value?.summary;
  Future<void> fetchTruckOwners({
    bool showLoader = true,
  }) async {
    if (showLoader) isLoading.value = true;
    errorMessage.value = '';
    try {
      response.value = await _service.fetchTruckOwners();
    } catch (e) {
      errorMessage.value = _cleanError(e);
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> fetchTruckOwnerDetails(int ownerId) async {
    isDetailsLoading.value = true;
    detailsError.value = '';
    details.value = null;
    try {
      details.value =
          await _service.fetchTruckOwnerDetails(ownerId);
      return true;
    } catch (e) {
      detailsError.value = _cleanError(e);
      return false;
    } finally {
      isDetailsLoading.value = false;
    }
  }
  Future<bool> approveTruckOwner(int ownerId) async {
    isActionLoading.value = true;
    actionMessage.value = '';
    try {
      final result = await _service.approveTruckOwner(ownerId);
      actionMessage.value =
          result['message']?.toString() ??
              'Truck owner approved successfully.';

      await fetchTruckOwners(showLoader: false);
      await fetchTruckOwnerDetails(ownerId);
      return true;
    } catch (e) {
      actionMessage.value = _cleanError(e);
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }
  Future<bool> rejectTruckOwner({
    required int ownerId,
    required String rejectionReason,
  }) async {
    isActionLoading.value = true;
    actionMessage.value = '';
    try {
      final result = await _service.rejectTruckOwner(
        ownerId: ownerId,
        rejectionReason: rejectionReason,
      );
      actionMessage.value =
          result['message']?.toString() ??
              'Truck owner rejected successfully.';

      await fetchTruckOwners(showLoader: false);
      await fetchTruckOwnerDetails(ownerId);
      return true;
    } catch (e) {
      actionMessage.value = _cleanError(e);
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}

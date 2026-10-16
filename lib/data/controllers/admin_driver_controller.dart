
// import 'package:get/get.dart';

// import '../models/admin_driver_model.dart';
// import '../models/driver_details_model.dart';
// import '../../services/admin_driver_service.dart';

// class AdminDriverController extends GetxController {
//   final AdminDriverService _service = AdminDriverService();

//   final RxBool isLoading = false.obs;
//   final RxBool isDetailsLoading = false.obs;
//   final RxBool isActionLoading = false.obs;

//   final Rxn<AdminDriverModel> driverResponse =
//       Rxn<AdminDriverModel>();

//   final Rxn<DriverDetailsModel> driverDetails =
//       Rxn<DriverDetailsModel>();

//   final RxString errorMessage = ''.obs;
//   final RxString detailsError = ''.obs;

//   final RxString actionMessage = ''.obs;

//   List<AdminDriver> get pendingDrivers =>
//       driverResponse.value?.pending ?? [];

//   List<AdminDriver> get approvedDrivers =>
//       driverResponse.value?.approved ?? [];

//   List<AdminDriver> get rejectedDrivers =>
//       driverResponse.value?.rejected ?? [];

//   DriverSummary? get summary =>
//       driverResponse.value?.summary;

//   // ============================================================
//   // FETCH DRIVER LISTS
//   // ============================================================

//   Future<void> fetchDrivers({
//     bool showLoader = true,
//   }) async {
//     if (showLoader) {
//       isLoading.value = true;
//     }

//     errorMessage.value = '';

//     try {
//       driverResponse.value = await _service.fetchDrivers();
//     } catch (e) {
//       errorMessage.value = _cleanError(e);
//     } finally {
//       if (showLoader) {
//         isLoading.value = false;
//       }
//     }
//   }

//   // ============================================================
//   // FETCH DRIVER DETAILS
//   // ============================================================

//   Future<bool> fetchDriverDetails(int registrationId) async {
//     isDetailsLoading.value = true;
//     detailsError.value = '';
//     driverDetails.value = null;

//     try {
//       driverDetails.value =
//           await _service.fetchDriverDetails(registrationId);
//       return true;
//     } catch (e) {
//       detailsError.value = _cleanError(e);
//       return false;
//     } finally {
//       isDetailsLoading.value = false;
//     }
//   }

//   // ============================================================
//   // APPROVE DRIVER
//   // ============================================================

//   Future<bool> approveDriver(int registrationId) async {
//     if (isActionLoading.value) return false;

//     isActionLoading.value = true;
//     actionMessage.value = '';

//     try {
//       final response =
//           await _service.approveDriver(registrationId);

//       actionMessage.value =
//           response['message']?.toString() ??
//               'Driver approved successfully';

//       await fetchDrivers(showLoader: false);
//       await fetchDriverDetails(registrationId);

//       return true;
//     } catch (e) {
//       actionMessage.value = _cleanError(e);
//       return false;
//     } finally {
//       isActionLoading.value = false;
//     }
//   }

//   // ============================================================
//   // REJECT DRIVER
//   // ============================================================

//   Future<bool> rejectDriver({
//     required int registrationId,
//     required String rejectionReason,
//   }) async {
//     if (isActionLoading.value) return false;

//     final reason = rejectionReason.trim();

//     if (reason.isEmpty) {
//       actionMessage.value = 'Please enter a rejection reason';
//       return false;
//     }

//     isActionLoading.value = true;
//     actionMessage.value = '';

//     try {
//       final response = await _service.rejectDriver(
//         registrationId: registrationId,
//         rejectionReason: reason,
//       );

//       actionMessage.value =
//           response['message']?.toString() ??
//               'Driver rejected successfully';

//       await fetchDrivers(showLoader: false);
//       await fetchDriverDetails(registrationId);

//       return true;
//     } catch (e) {
//       actionMessage.value = _cleanError(e);
//       return false;
//     } finally {
//       isActionLoading.value = false;
//     }
//   }

//   String _cleanError(Object error) {
//     return error.toString().replaceFirst('Exception: ', '');
//   }
// }


import 'package:get/get.dart';

import '../models/admin_driver_model.dart';
import '../models/company_model.dart';
import '../models/driver_details_model.dart';
import '../../services/admin_driver_service.dart';

class AdminDriverController extends GetxController {
  final AdminDriverService _service = AdminDriverService();

  final RxBool isLoading = false.obs;
  final RxBool isDetailsLoading = false.obs;
  final RxBool isCompanyDetailsLoading = false.obs;
  final RxBool isActionLoading = false.obs;

  final Rxn<AdminDriverModel> driverResponse = Rxn<AdminDriverModel>();
  final Rxn<DriverDetailsModel> driverDetails = Rxn<DriverDetailsModel>();
  final Rxn<CompanyModel> companyDetails = Rxn<CompanyModel>();

  final RxString errorMessage = ''.obs;
  final RxString detailsError = ''.obs;
  final RxString companyDetailsError = ''.obs;
  final RxString actionMessage = ''.obs;

  List<AdminDriver> get pendingDrivers => driverResponse.value?.pending ?? [];
  List<AdminDriver> get approvedDrivers => driverResponse.value?.approved ?? [];
  List<AdminDriver> get rejectedDrivers => driverResponse.value?.rejected ?? [];
  DriverSummary? get summary => driverResponse.value?.summary;

  Future<void> fetchDrivers({bool showLoader = true}) async {
    if (showLoader) isLoading.value = true;
    errorMessage.value = '';

    try {
      driverResponse.value = await _service.fetchDrivers();
    } catch (e) {
      errorMessage.value = _cleanError(e);
    } finally {
      if (showLoader) isLoading.value = false;
    }
  }
  Future<bool> fetchDriverDetails(int registrationId) async {
    isDetailsLoading.value = true;
    detailsError.value = '';
    driverDetails.value = null;
    try {
      driverDetails.value = await _service.fetchDriverDetails(registrationId);
      return true;
    } catch (e) {
      detailsError.value = _cleanError(e);
      return false;
    } finally {
      isDetailsLoading.value = false;
    }
  }

  Future<bool> fetchCompanyDetails(int companyId) async {
    if (companyId <= 0) {
      companyDetails.value = null;
      companyDetailsError.value = 'Invalid company ID';
      return false;
    }

    isCompanyDetailsLoading.value = true;
    companyDetailsError.value = '';
    companyDetails.value = null;

    try {
      companyDetails.value = await _service.fetchCompanyDetails(companyId);
      return true;
    } catch (e) {
      companyDetailsError.value = _cleanError(e);
      return false;
    } finally {
      isCompanyDetailsLoading.value = false;
    }
  }

  Future<bool> approveDriver(int registrationId) async {
    if (isActionLoading.value) return false;
    isActionLoading.value = true;
    actionMessage.value = '';

    try {
      final response = await _service.approveDriver(registrationId);
      actionMessage.value = response['message']?.toString() ??
          'Driver approved successfully';
      await fetchDrivers(showLoader: false);
      await fetchDriverDetails(registrationId);
      final driver = driverDetails.value?.data;
      final companyId = int.tryParse(driver?.companyId ?? '');
      if (companyId != null && companyId > 0) {
        await fetchCompanyDetails(companyId);
      }
      return true;
    } catch (e) {
      actionMessage.value = _cleanError(e);
      return false;
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<bool> rejectDriver({
    required int registrationId,
    required String rejectionReason,
  }) async {
    if (isActionLoading.value) return false;
    final reason = rejectionReason.trim();
    if (reason.isEmpty) {
      actionMessage.value = 'Please enter a rejection reason';
      return false;
    }

    isActionLoading.value = true;
    actionMessage.value = '';

    try {
      final response = await _service.rejectDriver(
        registrationId: registrationId,
        rejectionReason: reason,
      );
      actionMessage.value = response['message']?.toString() ??
          'Driver rejected successfully';
      await fetchDrivers(showLoader: false);
      await fetchDriverDetails(registrationId);
      final driver = driverDetails.value?.data;
      final companyId = int.tryParse(driver?.companyId ?? '');
      if (companyId != null && companyId > 0) {
        await fetchCompanyDetails(companyId);
      }
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
}

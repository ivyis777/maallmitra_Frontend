import 'package:get/get.dart';

import '../../services/driver_registration_service.dart';
import '../models/driver_registration_model.dart';

class DriverRegistrationController extends GetxController {
  final DriverRegistrationService _service =
      DriverRegistrationService();

  final RxBool isLoading = false.obs;
  final RxBool isCheckingStatus = false.obs;

  final Rxn<DriverRegistrationModel> registration =
      Rxn<DriverRegistrationModel>();

  final RxString errorMessage = ''.obs;

  Future<bool> registerDriver({
    required String companyType,
    required String name,
    required String age,
    required String gender,
    required String mobileNumber,
    required String aadhaarNumber,
    required String drivingLicenceNumber,
    required String dlType,
    required String dlIssuedDate,
    required String dlExpiredDate,
    required String permanentAddress,
    required String currentAddress,
    required String medicalCertificate,
    required String policeVerificationCertificate,
    required String photo,
    required String aadhaarFront,
    required String aadhaarBack,
    required String dlFront,
    required String dlBack,

    // Existing company or new company details.
    String? companyId,
    String? companyRegistrationId,
    String? companyUniqueId,
    String? companyName,
    String? gstNumber,
    String? companyEmail,
    String? companyPhoneNumber,
    String? companyPersonNumber,
    String? companyAddress,
    String? companyCity,
    String? companyState,
    String? companyPincode,
    String? companyCountry,

    // Separate document paths for each company flow.
    String? companyDocumentPath,
    String? companyBondDocumentPath,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      registration.value = await _service.registerDriver(
        companyType: companyType,
        name: name,
        age: age,
        gender: gender,
        mobileNumber: mobileNumber,
        aadhaarNumber: aadhaarNumber,
        drivingLicenceNumber: drivingLicenceNumber,
        dlType: dlType,
        dlIssuedDate: dlIssuedDate,
        dlExpiredDate: dlExpiredDate,
        permanentAddress: permanentAddress,
        currentAddress: currentAddress,
        medicalCertificate: medicalCertificate,
        policeVerificationCertificate:
            policeVerificationCertificate,
        photo: photo,
        aadhaarFront: aadhaarFront,
        aadhaarBack: aadhaarBack,
        dlFront: dlFront,
        dlBack: dlBack,

        // Company details.
        companyId: companyId,
        companyRegistrationId: companyRegistrationId,
        companyUniqueId: companyUniqueId,
        companyName: companyName,
        gstNumber: gstNumber,
        companyEmail: companyEmail,
        companyPhoneNumber: companyPhoneNumber,
        companyPersonNumber: companyPersonNumber,
        companyAddress: companyAddress,
        companyCity: companyCity,
        companyState: companyState,
        companyPincode: companyPincode,
        companyCountry: companyCountry,

        // Forward the correct document for each flow.
        companyDocumentPath: companyDocumentPath,
        companyBondDocumentPath: companyBondDocumentPath,
      );

      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> fetchDriverStatus() async {
    try {
      isCheckingStatus.value = true;
      errorMessage.value = '';

      return await _service.fetchDriverProfile();
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      isCheckingStatus.value = false;
    }
  }
}

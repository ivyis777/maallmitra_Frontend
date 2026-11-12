
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/truck_owner_registration_model.dart';
import '../../services/truck_owner_registration_service.dart';

class TruckOwnerRegistrationController extends GetxController {
  final TruckOwnerRegistrationService _service =
      TruckOwnerRegistrationService();

  // Registration state
  final RxBool isLoading = false.obs;

  final Rxn<TruckOwnerRegistrationModel> registration =
      Rxn<TruckOwnerRegistrationModel>();

  final RxString errorMessage = ''.obs;

  // Status-check state
  final RxString statusErrorMessage = ''.obs;
  final RxString registrationStatus = ''.obs;

  final Rxn<Map<String, dynamic>> ownerStatusDetails =
      Rxn<Map<String, dynamic>>();

  int? get registeredOwnerId =>
      registration.value?.data?.ownerId;

  // ============================================================
  // REGISTER TRUCK OWNER
  // ============================================================

  Future<bool> registerTruckOwner({
    required String name,
    required String mobileNumber,
    required String dateOfBirth,
    required String gender,
    required String permanentAddress,
    required String currentAddress,
   required String panCardDocumentPath,
    required String aadhaarCardDocumentPath,
    required bool isSelfDriver,
   
    String? drivingLicenceNumber,
    String? dlType,
    String? dlIssuedDate,
    String? dlExpiredDate,
    String? medicalCertificatePath,
    String? policeVerificationCertificatePath,
    String? photoPath,
    String? aadhaarNumber,
    String? aadhaarFrontPath,
    String? aadhaarBackPath,
    String? dlFrontPath,
    String? dlBackPath,
    String? companyType,
    String? companyId,
    String? companyBondDocumentPath,
    String? companyName,
    String? companyEmail,
    String? companyPhoneNumber,
    String? companyPersonNumber,
    String? companyAddress,
    String? companyCity,
    String? companyState,
    String? companyPincode,
    String? companyCountry,
    String? companyDocumentType,
    String? companyDocumentPath,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Clear previous registration response.
      registration.value = null;
      registrationStatus.value = '';

      // Owner validation
      if (name.trim().isEmpty) {
        errorMessage.value = 'Please enter the owner name.';
        return false;
      }

      if (!RegExp(r'^[6-9][0-9]{9}$')
          .hasMatch(mobileNumber.trim())) {
        errorMessage.value =
            'Please enter a valid 10-digit mobile number.';
        return false;
      }

      if (dateOfBirth.trim().isEmpty) {
        errorMessage.value = 'Please select the date of birth.';
        return false;
      }

      if (gender.trim().isEmpty) {
        errorMessage.value = 'Please select the gender.';
        return false;
      }

      if (permanentAddress.trim().isEmpty ||
          currentAddress.trim().isEmpty) {
        errorMessage.value = 'Please enter both addresses.';
        return false;
      }

      if (aadhaarCardDocumentPath.trim().isEmpty) {
        errorMessage.value =
            'Please select the required Aadhaar document.';
        return false;
      }
      if (panCardDocumentPath.trim().isEmpty) {
  errorMessage.value = 'Please select the PAN card document.';
  return false;
}

      // Call registration service
      final result = await _service.registerTruckOwner(
        name: name.trim(),
        mobileNumber: mobileNumber.trim(),
        dateOfBirth: dateOfBirth,
        gender: gender,
        permanentAddress: permanentAddress.trim(),
        currentAddress: currentAddress.trim(),
        aadhaarCardDocumentPath: aadhaarCardDocumentPath,
        panCardDocumentPath: panCardDocumentPath,
        
isSelfDriver: isSelfDriver,
aadhaarNumber: aadhaarNumber,

        drivingLicenceNumber: drivingLicenceNumber,
        dlType: dlType,
        dlIssuedDate: dlIssuedDate,
        dlExpiredDate: dlExpiredDate,
        medicalCertificatePath: medicalCertificatePath,
        policeVerificationCertificatePath:
            policeVerificationCertificatePath,
        photoPath: photoPath,
        aadhaarFrontPath: aadhaarFrontPath,
        aadhaarBackPath: aadhaarBackPath,
        dlFrontPath: dlFrontPath,
        dlBackPath: dlBackPath,
        companyType: companyType,
        companyId: companyId,
        companyBondDocumentPath: companyBondDocumentPath,
        companyName: companyName,
        companyEmail: companyEmail,
        companyPhoneNumber: companyPhoneNumber,
        companyPersonNumber: companyPersonNumber,
        companyAddress: companyAddress,
        companyCity: companyCity,
        companyState: companyState,
        companyPincode: companyPincode,
        companyCountry: companyCountry,
        companyDocumentType: companyDocumentType,
        companyDocumentPath: companyDocumentPath,
      );

      // Verify API success response.
      if (!result.success) {
        errorMessage.value = result.message.isNotEmpty
            ? result.message
            : 'Truck owner registration failed.';
        return false;
      }

      // Verify registration data.
      final owner = result.data;

      if (owner == null) {
        errorMessage.value =
            'Registration details were not returned by the server.';
        return false;
      }

      // Verify registration status.
      final status = owner.status.toLowerCase().trim();

      if (status.isEmpty) {
        errorMessage.value =
            'Registration status was not returned by the server.';
        return false;
      }

      // Save successful registration response.
      registration.value = result;
      registrationStatus.value = status;

      statusErrorMessage.value = '';
      ownerStatusDetails.value = null;

      debugPrint(
        'TRUCK OWNER REGISTRATION SUCCESS: ${result.success}',
      );

      debugPrint(
        'TRUCK OWNER REGISTRATION STATUS: $status',
      );

      debugPrint(
        'TRUCK OWNER ID: ${owner.ownerId}',
      );

      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');

      debugPrint('TRUCK OWNER REGISTRATION ERROR: $e');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CHECK TRUCK OWNER STATUS
  // ============================================================

  Future<Map<String, dynamic>?> checkTruckOwnerStatus() async {
    try {
      isLoading.value = true;
      statusErrorMessage.value = '';

      debugPrint('CHECK STATUS: Calling profile API');

      final result = await _service.checkTruckOwnerStatus();

      ownerStatusDetails.value = result;

      final status = (
        result['status'] ??
        result['registration_status'] ??
        ''
      ).toString().toLowerCase().trim();

      if (status.isEmpty) {
        statusErrorMessage.value =
            'Registration status was not provided by the server.';
        return null;
      }

      registrationStatus.value = status;

      debugPrint('CHECK STATUS: $status');
      debugPrint('CHECK STATUS DETAILS: $result');

      return {
        ...result,
        'status': status,
        'registration_status': status,
      };
    } catch (e) {
      statusErrorMessage.value =
          e.toString().replaceFirst('Exception: ', '');

      debugPrint('CHECK STATUS ERROR: $e');

      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // CLEAR REGISTRATION STATE
  // ============================================================

  void clearRegistrationState() {
    registration.value = null;
    errorMessage.value = '';
    statusErrorMessage.value = '';
    registrationStatus.value = '';
    ownerStatusDetails.value = null;
  }
}

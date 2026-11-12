
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/vendor_registration_model.dart';
import '../../services/vendor_registration_service.dart';

class VendorRegistrationController extends GetxController {
  final VendorRegistrationService _service = VendorRegistrationService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Loading and status
  final RxBool isLoading = false.obs;
  final RxBool isCheckingStatus = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString registrationStatus = ''.obs;
  final RxString successMessage = ''.obs;

  // Vendor details
  final Rxn<VendorRegistrationModel> vendorResponse =
      Rxn<VendorRegistrationModel>();

  // Register vendor
  Future<bool> registerVendor({
    required String fullName,
    required String email,
    required String mobileNumber,
    String? alternateMobileNumber,
    required String businessName,
    required String businessType,
    required String businessCategory,
    required String gstNumber,
    String? businessRegistrationNumber,
    required String yearsInBusiness,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String district,
    required String state,
    required String pincode,
    String? profilePhotoPath,
    String? gstCertificatePath,
    String? addressProofPath,
    String? transportPermitDocumentPath,
    String? businessLicensePath,
  }) async {
    if (isLoading.value) return false;

    errorMessage.value = '';
    successMessage.value = '';
    isLoading.value = true;

    try {
      final result = await _service.registerVendor(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        alternateMobileNumber: alternateMobileNumber,
        businessName: businessName,
        businessType: businessType,
        businessCategory: businessCategory,
        gstNumber: gstNumber,
        businessRegistrationNumber: businessRegistrationNumber,
        yearsInBusiness: yearsInBusiness,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        district: district,
        state: state,
        pincode: pincode,
        profilePhotoPath: profilePhotoPath,
        gstCertificatePath: gstCertificatePath,
        addressProofPath: addressProofPath,
        transportPermitDocumentPath: transportPermitDocumentPath,
        businessLicensePath: businessLicensePath,
      );

      // vendorResponse.value = result;
      // registrationStatus.value =
      //     result.registrationStatus.isNotEmpty
      //         ? result.registrationStatus
      //         : result.data?.status ?? 'pending';
     vendorResponse.value = result;
     final vendor = result.data;

debugPrint('========== MODEL DOCUMENT VALUES ==========');
debugPrint('Profile Photo: ${vendor?.profilePhoto}');
debugPrint('GST Certificate: ${vendor?.gstCertificate}');
debugPrint('Address Proof: ${vendor?.addressProof}');
debugPrint('Transport Permit: ${vendor?.transportPermitDocument}');
debugPrint('Business License: ${vendor?.businessLicense}');
debugPrint('============================================');


debugPrint('========== MODEL DOCUMENT VALUES ==========');
debugPrint('Profile Photo: ${vendor?.profilePhoto}');
debugPrint('GST Certificate: ${vendor?.gstCertificate}');
debugPrint('Address Proof: ${vendor?.addressProof}');
debugPrint(
  'Transport Permit: ${vendor?.transportPermitDocument}',
);
debugPrint('Business License: ${vendor?.businessLicense}');
debugPrint('============================================');

registrationStatus.value =
    result.registrationStatus.isNotEmpty
        ? result.registrationStatus
        : result.data?.status ?? 'pending';

      successMessage.value = result.message.isNotEmpty
          ? result.message
          : 'Vendor registration submitted successfully.';

      return true;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch the logged-in vendor's profile and registration status
  Future<bool> checkVendorStatus() async {
    if (isCheckingStatus.value) return false;

    errorMessage.value = '';
    isCheckingStatus.value = true;

    try {
      final result = await _service.fetchVendorProfile();

      vendorResponse.value = result;
      registrationStatus.value =
          result.registrationStatus.isNotEmpty
              ? result.registrationStatus
              : result.data?.status ?? 'pending';

      successMessage.value = result.message;
      return true;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      return false;
    } finally {
      isCheckingStatus.value = false;
    }
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .trim();
  }

  void clearMessages() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  void clearFormState() {
    clearMessages();
    registrationStatus.value = '';
    vendorResponse.value = null;
  }
}

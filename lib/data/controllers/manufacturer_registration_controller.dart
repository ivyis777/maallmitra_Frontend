import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/manufacturer_registration_model.dart';
import '../../services/manufacturer_registration_service.dart';
class ManufacturerRegistrationController extends GetxController {
  final ManufacturerRegistrationService _service =
      ManufacturerRegistrationService();
  // Form key
  final formKey = GlobalKey<FormState>();
  // Company details
  final companyNameController = TextEditingController();
  final gstController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final yearController = TextEditingController();
  final landlineController = TextEditingController();

  // Contact person details
  final contactNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pinCodeController = TextEditingController();
  final countryController = TextEditingController(text: 'India');

  final isLoading = false.obs;
  final isCheckingStatus = false.obs;
  final registrationStatus = ''.obs;
  final rejectionReason = ''.obs;
  final selectedCategories = <String>{}.obs;

  // Uploaded documents
  final companyCertificate = Rxn<PlatformFile>();
  final gstCertificate = Rxn<PlatformFile>();
  final addressProof = Rxn<PlatformFile>();

  // Registration API response
  final registrationResponse =
      Rxn<ManufacturerRegistrationResponse>();

  // Error message
  final errorMessage = ''.obs;


  // PRODUCT CATEGORY
  

  void toggleCategory(String category, bool selected) {
    if (selected) {
      selectedCategories.add(category);
    } else {
      selectedCategories.remove(category);
    }
  }
  // DOCUMENT SELECTION
  void setDocument(String type, PlatformFile file) {
    switch (type) {
      case 'company':
        companyCertificate.value = file;
        break;

      case 'gst':
        gstCertificate.value = file;
        break;

      case 'address':
        addressProof.value = file;
        break;
    }
  }
  // REGISTER MANUFACTURER
  Future<bool> registerManufacturer() async {
    if (isLoading.value) return false;

    errorMessage.value = '';
    registrationResponse.value = null;

    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (selectedCategories.isEmpty) {
      errorMessage.value =
          'Select at least one product category.';
      return false;
    }

    if (companyCertificate.value == null ||
        gstCertificate.value == null ||
        addressProof.value == null) {
      errorMessage.value =
          'Please upload all three documents.';
      return false;
    }

    isLoading.value = true;

    try {
      final fields = <String, String>{
        'company_name': companyNameController.text.trim(),
        'gst_number': gstController.text.trim(),
        'company_registration_number':
            registrationNumberController.text.trim(),
        'year_of_establishment': yearController.text.trim(),
        'company_landline_number':
            landlineController.text.trim(),
        'contact_person_name': contactNameController.text.trim(),
        'mobile_number': mobileController.text.trim(),
        'email_address': emailController.text.trim(),
        'factory_address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'pin_code': pinCodeController.text.trim(),
        'country': countryController.text.trim(),
      };

      final result = await _service.registerManufacturer(
        fields: fields,
        productCategories: selectedCategories.toList(),
        companyCertificate: companyCertificate.value!,
        gstCertificate: gstCertificate.value!,
        addressProof: addressProof.value!,
      );

      registrationResponse.value = ManufacturerRegistrationResponse.fromJson(result);

      final response = registrationResponse.value!;
      registrationStatus.value =
          response.registrationStatus.trim().isEmpty
              ? 'pending'
              : response.registrationStatus.trim().toLowerCase();
      return true;
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>?> fetchManufacturerStatus() async {
  if (isCheckingStatus.value) return null;

  isCheckingStatus.value = true;
  errorMessage.value = '';

  try {
    final response = await _service.checkManufacturerStatus();

    debugPrint('Manufacturer status API response: $response');

    // Extract profile data from the API response.
    final dynamic rawData = response['data'];

    final Map<String, dynamic> profile;

    if (rawData is Map) {
      profile = Map<String, dynamic>.from(rawData);
    } else {
      profile = Map<String, dynamic>.from(response);
    }

    // Check status in both response and profile.
    final String status = (
      profile['registration_status'] ??
      profile['status'] ??
      response['registration_status'] ??
      response['status'] ??
      ''
    ).toString().trim().toLowerCase();

    if (!['pending', 'approved', 'rejected'].contains(status)) {
      errorMessage.value =
          'Unable to determine registration status from the server.';
      return null;
    }

    final String reason = (
      profile['rejection_reason'] ??
      response['rejection_reason'] ??
      ''
    ).toString();

    registrationStatus.value = status;
    rejectionReason.value = reason;

    // Preserve all profile fields, including document paths.
    final Map<String, dynamic> result = {
      ...profile,
      'status': status,
      'registration_status': status,
      'rejection_reason': reason,
    };

    debugPrint(
      'Manufacturer document fields: '
      'company_registration_certificate=${result['company_registration_certificate']}, '
      'gst_certificate=${result['gst_certificate']}, '
      'business_address_proof=${result['business_address_proof']}',
    );

    return result;
  } catch (e) {
    errorMessage.value =
        e.toString().replaceFirst('Exception: ', '');
    debugPrint('Manufacturer status error: $e');
    return null;
  } finally {
    isCheckingStatus.value = false;
  }
}

// Future<Map<String, dynamic>?> fetchManufacturerStatus() async {
//   if (isCheckingStatus.value) return null;

//   isCheckingStatus.value = true;
//   errorMessage.value = '';

//   try {
//     final response = await _service.checkManufacturerStatus();

//     final dynamic rawData = response['data'];

//     final Map<String, dynamic> profile =
//         rawData is Map
//             ? Map<String, dynamic>.from(rawData)
//             : <String, dynamic>{};

//     final String status = (
//       response['registration_status'] ??
//       profile['status'] ??
//       response['status'] ??
//       ''
//     ).toString().trim().toLowerCase();

//     if (!['pending', 'approved', 'rejected'].contains(status)) {
//       errorMessage.value =
//           'Unable to determine registration status from the server.';
//       return null;
//     }

//     final String reason =
//         (profile['rejection_reason'] ??
//                 response['rejection_reason'] ??
//                 '')
//             .toString();

//     registrationStatus.value = status;
//     rejectionReason.value = reason;

//     // Return the full profile along with its status.
//     return <String, dynamic>{
//       ...profile,
//       'status': status,
//       'registration_status': status,
//       'rejection_reason': reason,
//     };
//   } catch (e) {
//     errorMessage.value =
//         e.toString().replaceFirst('Exception: ', '');
//     return null;
//   } finally {
//     isCheckingStatus.value = false;
//   }
// }

  // Future<Map<String, dynamic>?> fetchManufacturerStatus() async {
  //   if (isCheckingStatus.value) return null;

  //   isCheckingStatus.value = true;
  //   errorMessage.value = '';

  //   try {
  //     final response = await _service.checkManufacturerStatus();

  //     final dynamic rawData = response['data'];

  //     final Map<String, dynamic> data =
  //         rawData is Map<String, dynamic>
  //             ? rawData
  //             : <String, dynamic>{};

  //     final String status = (
  //       data['registration_status'] ??
  //       data['status'] ??
  //       response['registration_status'] ??
  //       response['status'] ??
  //       ''
  //     ).toString().trim().toLowerCase();

  //     if (!['pending', 'approved', 'rejected'].contains(status)) {
  //       errorMessage.value =
  //           'Unable to determine registration status from the server.';
  //       return null;
  //     }

  //     final String reason = (
  //       data['rejection_reason'] ??
  //       response['rejection_reason'] ??
  //       ''
  //     ).toString();

  //     registrationStatus.value = status;
  //     rejectionReason.value = reason;

  //     return <String, dynamic>{
  //       'status': status,
  //       'rejection_reason': reason,
  //     };
  //   } catch (e) {
  //     errorMessage.value =
  //         e.toString().replaceFirst('Exception: ', '');
  //     return null;
  //   } finally {
  //     isCheckingStatus.value = false;
  //   }
  // }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    for (final textController in <TextEditingController>[
      companyNameController,
      gstController,
      registrationNumberController,
      yearController,
      landlineController,
      contactNameController,
      mobileController,
      emailController,
      addressController,
      cityController,
      stateController,
      pinCodeController,
    ]) {
      textController.clear();
    }

    countryController.text = 'India';

    selectedCategories.clear();

    companyCertificate.value = null;
    gstCertificate.value = null;
    addressProof.value = null;

    registrationResponse.value = null;
    registrationStatus.value = '';
    rejectionReason.value = '';
    errorMessage.value = '';
  }

  // ============================================================
  // DISPOSE CONTROLLERS
  // ============================================================

  @override
  void onClose() {
    companyNameController.dispose();
    gstController.dispose();
    registrationNumberController.dispose();
    yearController.dispose();
    landlineController.dispose();

    contactNameController.dispose();
    mobileController.dispose();
    emailController.dispose();

    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinCodeController.dispose();
    countryController.dispose();

    super.onClose();
  }
}


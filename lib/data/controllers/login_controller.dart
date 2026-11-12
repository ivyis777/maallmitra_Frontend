
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

// import '../../presentation/screens/registration/vendor_status_screens.dart';
// import '../models/auth_model.dart';
// import '../../services/auth_service.dart';
// import '../../services/driver_registration_service.dart';
// import '../../services/vendor_registration_service.dart';
// import '../../core/storage/LocalStorageConstants.dart';

// // Adjust the ManufacturerStatus folder name here if your project uses a
// // different folder for manufacturer_status_screens.dart.
// import '../../presentation/screens/Registration/manufacturer_status_screens.dart';
// import '../../presentation/screens/Registration/driver_status_screens.dart';
// import '../../presentation/screens/HomePages/driver_home_page.dart';
// import '../../presentation/screens/HomePages/vendor_home_page.dart';
// import '../../presentation/screens/RolePage/role_selection_screen.dart';
// import '../../presentation/screens/registration/truck_owner_status_screens.dart';
// import '../../presentation/screens/HomePages/owner_home_page.dart';
// import 'truck_owner_registration_controller.dart';

// class AuthController extends GetxController {
//   final AuthService _authService = AuthService();

//   final RxBool isLoading = false.obs;
//   final RxBool otpVisible = false.obs;
//   final RxInt verificationId = 0.obs;
//   final RxString expiresAt = ''.obs;

//   final RxString userRole = ''.obs;
//   final RxString authenticatedMobile = ''.obs;

//   final RxMap<String, dynamic> manufacturerProfile =
//       <String, dynamic>{}.obs;

//   final RxBool isCheckingManufacturerStatus = false.obs;
//   final RxBool isCheckingVendorStatus = false.obs;

//   // Extract a useful error message from different API response formats.
//   String _getErrorMessage(
//     Map<String, dynamic> response,
//     String fallback,
//   ) {
//     final message = response['message'];

//     if (message != null && message.toString().trim().isNotEmpty) {
//       return message.toString();
//     }

//     final errors = response['errors'];

//     if (errors is Map) {
//       return errors.entries.map((entry) {
//         final value = entry.value;

//         if (value is List) {
//           return '${entry.key}: ${value.join(', ')}';
//         }

//         return '${entry.key}: $value';
//       }).join('\n');
//     }

//     return fallback;
//   }

//   bool _isValidMobile(String mobile) {
//     return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
//   }

//   // ============================================================
//   // SEND OTP
//   // ============================================================

//   Future<bool> sendOtp(String mobileNumber) async {
//     final mobile = mobileNumber.trim();

//     debugPrint('========== SEND OTP START ==========');

//     if (!_isValidMobile(mobile)) {
//       Get.snackbar(
//         'Invalid Mobile',
//         'Enter a valid 10-digit mobile number.',
//       );
//       return false;
//     }

//     if (isLoading.value) {
//       debugPrint('OTP request ignored: another request is running.');
//       return false;
//     }

//     try {
//       isLoading.value = true;

//       // Reset old OTP state before requesting a new OTP.
//       otpVisible.value = false;
//       verificationId.value = 0;
//       expiresAt.value = '';

//       debugPrint('Calling AuthService.sendOtp()');

//       final response = await _authService.sendOtp(mobile);

//       debugPrint('Send OTP response: $response');

//       if (response['success'] == true) {
//         final id = int.tryParse(
//           response['verification_id']?.toString() ?? '',
//         );

//         if (id == null || id <= 0) {
//           debugPrint('Send OTP failed: invalid verification ID.');

//           Get.snackbar(
//             'OTP Error',
//             'The server did not return a valid verification ID.',
//           );

//           return false;
//         }

//         verificationId.value = id;
//         expiresAt.value = response['expires_at']?.toString() ?? '';
//         otpVisible.value = true;

//         debugPrint('OTP sent successfully.');
//         debugPrint('Verification ID: ${verificationId.value}');
//         debugPrint('========== SEND OTP END ==========');

//         return true;
//       }

//       otpVisible.value = false;

//       final error = _getErrorMessage(
//         response,
//         'Unable to send OTP. Please try again.',
//       );

//       debugPrint('Send OTP API failure: $error');

//       Get.snackbar('OTP Failed', error);
//       return false;
//     } catch (e, stackTrace) {
//       otpVisible.value = false;

//       debugPrint('SEND OTP ERROR: $e');
//       debugPrintStack(stackTrace: stackTrace);

//       Get.snackbar(
//         'Connection Error',
//         'Unable to send OTP. Check your connection and try again.',
//       );

//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ============================================================
//   // RESEND OTP
//   // ============================================================

//   Future<bool> resendOtp(String mobileNumber) async {
//     final mobile = mobileNumber.trim();

//     debugPrint('========== RESEND OTP START ==========');

//     if (!_isValidMobile(mobile)) {
//       Get.snackbar(
//         'Invalid Mobile',
//         'Enter a valid 10-digit mobile number.',
//       );
//       return false;
//     }

//     if (isLoading.value) {
//       debugPrint('Resend ignored: another request is running.');
//       return false;
//     }

//     if (verificationId.value <= 0) {
//       debugPrint('Resend failed: verification ID is missing.');

//       Get.snackbar(
//         'OTP Error',
//         'Please request an OTP before trying to resend it.',
//       );

//       return false;
//     }

//     try {
//       isLoading.value = true;

//       debugPrint('Resending OTP for verification ID: '
//           '${verificationId.value}');

//       final response = await _authService.resendOtp(
//         mobile,
//         verificationId.value,
//       );

//       debugPrint('Resend OTP response: $response');

//       if (response['success'] == true) {
//         final newId = int.tryParse(
//           response['verification_id']?.toString() ?? '',
//         );

//         // Some APIs return a new verification ID; others retain the old one.
//         if (newId != null && newId > 0) {
//           verificationId.value = newId;
//         }

//         expiresAt.value =
//             response['expires_at']?.toString() ?? expiresAt.value;

//         otpVisible.value = true;

//         debugPrint('OTP resent successfully.');
//         debugPrint('Current verification ID: ${verificationId.value}');
//         debugPrint('========== RESEND OTP END ==========');

//         Get.snackbar(
//           'OTP Sent',
//           'A new OTP has been requested.',
//         );

//         return true;
//       }

//       final error = _getErrorMessage(
//         response,
//         'Unable to resend OTP. Please try again.',
//       );

//       debugPrint('Resend OTP API failure: $error');

//       Get.snackbar('Resend Failed', error);
//       return false;
//     } catch (e, stackTrace) {
//       debugPrint('RESEND OTP ERROR: $e');
//       debugPrintStack(stackTrace: stackTrace);

//       Get.snackbar(
//         'Connection Error',
//         'Unable to resend OTP. Check your connection and try again.',
//       );

//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ============================================================
//   // VERIFY OTP
//   // ============================================================

//   Future<bool> verifyOtp(String mobileNumber, String otp) async {
//     final mobile = mobileNumber.trim();
//     final enteredOtp = otp.trim();

//     debugPrint('========== VERIFY OTP START ==========');

//     if (!_isValidMobile(mobile)) {
//       Get.snackbar(
//         'Invalid Mobile',
//         'Enter a valid 10-digit mobile number.',
//       );
//       return false;
//     }

//     if (enteredOtp.isEmpty) {
//       Get.snackbar(
//         'Invalid OTP',
//         'Please enter the OTP.',
//       );
//       return false;
//     }

//     if (verificationId.value <= 0) {
//       Get.snackbar(
//         'OTP Error',
//         'Please request a new OTP before verifying.',
//       );
//       return false;
//     }

//     if (isLoading.value) {
//       debugPrint('Verification ignored: another request is running.');
//       return false;
//     }

//     try {
//       isLoading.value = true;

//       debugPrint('Calling AuthService.verifyOtp()');

//       final response = await _authService.verifyOtp(
//         mobile,
//         enteredOtp,
//         verificationId.value,
//       );

//       debugPrint('Verify OTP response: $response');

//       final authResponse = AuthResponse.fromJson(response);

//       if (!authResponse.success) {
//         final error = _getErrorMessage(
//           response,
//           'OTP verification failed.',
//         );

//         debugPrint('OTP verification rejected: $error');

//         Get.snackbar('Login Failed', error);
//         return false;
//       }

//       final accessToken = authResponse.accessToken;
//       final refreshToken = authResponse.refreshToken;

//       if (accessToken == null ||
//           accessToken.isEmpty ||
//           refreshToken == null ||
//           refreshToken.isEmpty) {
//         Get.snackbar(
//           'Login Failed',
//           'Authentication tokens were not returned by the server.',
//         );
//         return false;
//       }

//       final Map<String, dynamic> claims;

//       try {
//         claims = JwtDecoder.decode(accessToken);
//       } catch (e, stackTrace) {
//         debugPrint('JWT decoding error: $e');
//         debugPrintStack(stackTrace: stackTrace);

//         Get.snackbar(
//           'Login Failed',
//           'Unable to read authentication details.',
//         );

//         return false;
//       }

//       // Read roles from the JWT.
//       final List<String> tokenRoles = [];

//       final dynamic rolesClaim = claims['roles'];
//       final dynamic roleClaim = claims['role'];

//       if (rolesClaim is List) {
//         tokenRoles.addAll(
//           rolesClaim
//               .map((value) => value.toString().trim().toLowerCase())
//               .where((value) => value.isNotEmpty),
//         );
//       } else if (rolesClaim is String) {
//         tokenRoles.addAll(
//           rolesClaim
//               .split(',')
//               .map((value) => value.trim().toLowerCase())
//               .where((value) => value.isNotEmpty),
//         );
//       }

//       if (roleClaim is String && roleClaim.trim().isNotEmpty) {
//         final role = roleClaim.trim().toLowerCase();

//         if (!tokenRoles.contains(role)) {
//           tokenRoles.add(role);
//         }
//       }

//       // Prefer roles returned by the API; otherwise use JWT roles.
//       final List<String> apiRoles = [];
//       final dynamic apiRolesClaim = response['roles'];

//       if (apiRolesClaim is List) {
//         apiRoles.addAll(
//           apiRolesClaim
//               .map((value) => value.toString().trim().toLowerCase())
//               .where((value) => value.isNotEmpty),
//         );
//       } else if (apiRolesClaim is String &&
//           apiRolesClaim.trim().isNotEmpty) {
//         apiRoles.addAll(
//           apiRolesClaim
//               .split(',')
//               .map((value) => value.trim().toLowerCase())
//               .where((value) => value.isNotEmpty),
//         );
//       }

//       final roles = apiRoles.isNotEmpty ? apiRoles : tokenRoles;

//       if (roles.contains('admin')) {
//         userRole.value = 'admin';
//       } else if (roles.isNotEmpty) {
//         userRole.value = roles.first;
//       } else {
//         userRole.value = '';
//       }

//       authenticatedMobile.value =
//           claims['mobile_number']?.toString().trim() ??
//           claims['mobile']?.toString().trim() ??
//           mobile;

//       if (authenticatedMobile.value.isEmpty) {
//         authenticatedMobile.value = mobile;
//       }

//       // Save tokens only after successful verification and validation.
//       await LocalStorageConstants.saveAccessToken(accessToken);
//       await LocalStorageConstants.saveRefreshToken(refreshToken);
//       await LocalStorageConstants.saveMobileNumber(
//         authenticatedMobile.value,
//       );

//       debugPrint('OTP verification successful.');
//       debugPrint('Roles from API: $apiRoles');
//       debugPrint('Roles from JWT: $tokenRoles');
//       debugPrint('Authenticated role: ${userRole.value}');
//       debugPrint('Next screen: ${response['next_screen']}');
//       debugPrint('========== VERIFY OTP END ==========');

//       return true;
//     } catch (e, stackTrace) {
//       debugPrint('VERIFY OTP ERROR: $e');
//       debugPrintStack(stackTrace: stackTrace);

//       Get.snackbar(
//         'Verification Error',
//         'Unable to verify OTP. Please try again.',
//       );

//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ============================================================
//   // FETCH MANUFACTURER PROFILE / REGISTRATION STATUS
//   // ============================================================

//   Future<Map<String, dynamic>?> fetchManufacturerProfile() async {
//     try {
//       isCheckingManufacturerStatus.value = true;

//       final accessToken =
//           await LocalStorageConstants.getAccessToken();

//       if (accessToken == null || accessToken.trim().isEmpty) {
//         debugPrint(
//           'Manufacturer profile check failed: access token missing.',
//         );
//         return null;
//       }

//       final response = await _authService.getManufacturerProfile(
//         accessToken.trim(),
//       );

//       debugPrint('Manufacturer profile response: $response');

//       if (response['success'] != true) {
//         debugPrint(
//           'Manufacturer profile API failure: '
//           '${_getErrorMessage(response, 'Unknown server response')}',
//         );
//         return null;
//       }

//       final dynamic data = response['data'];

//       final Map<String, dynamic> profile;

//       if (data is Map) {
//         profile = Map<String, dynamic>.from(data);
//       } else {
//         profile = Map<String, dynamic>.from(response)
//           ..remove('success')
//           ..remove('message');
//       }

//       manufacturerProfile.assignAll(profile);

//       debugPrint(
//         'Manufacturer registration status: '
//         '${profile['registration_status'] ?? profile['status'] ?? 'unknown'}',
//       );

//       return profile;
//     } catch (e, stackTrace) {
//       debugPrint('Fetch manufacturer profile error: $e');
//       debugPrintStack(stackTrace: stackTrace);
//       return null;
//     } finally {
//       isCheckingManufacturerStatus.value = false;
//     }
//   }

//   // ============================================================
//   // FETCH VENDOR PROFILE / REGISTRATION STATUS
//   // ============================================================

//   Future<Map<String, dynamic>?> fetchVendorProfile() async {
//     try {
//       isCheckingVendorStatus.value = true;

//       final response =
//           await VendorRegistrationService().fetchVendorProfile();
//       final vendor = response.data;

//       if (vendor == null) {
//         debugPrint('Vendor profile data is missing.');
//         return null;
//       }

//       final status = vendor.status.toString().trim().toLowerCase();

//       final Map<String, dynamic> profile = {
//         'vendor_id': vendor.vendorId,
//         'full_name': vendor.fullName,
//         'email': vendor.email,
//         'mobile_number': vendor.mobileNumber,
//         'alternate_mobile_number': vendor.alternateMobileNumber,
//         'business_name': vendor.businessName,
//         'business_type': vendor.businessType,
//         'business_category': vendor.businessCategory,
//         'gst_number': vendor.gstNumber,
//         'business_registration_number':
//             vendor.businessRegistrationNumber,
//         'years_in_business': vendor.yearsInBusiness,
//         'address_line1': vendor.addressLine1,
//         'address_line2': vendor.addressLine2,
//         'city': vendor.city,
//         'district': vendor.district,
//         'state': vendor.state,
//         'pincode': vendor.pincode,
//         'profile_photo': vendor.profilePhoto,
//         'gst_certificate': vendor.gstCertificate,
//         'address_proof': vendor.addressProof,
//         'transport_permit_document': vendor.transportPermitDocument,
//         'business_license': vendor.businessLicense,
//         'status': status,
//         'registration_status': status,
//         'rejection_reason': vendor.rejectionReason,
//         'reviewed_at': vendor.reviewedAt,
//         'created_at': vendor.createdAt,
//         'updated_at': vendor.updatedAt,
//       };

//       debugPrint('Vendor registration status: $status');
//       return profile;
//     } catch (e, stackTrace) {
//       debugPrint('Fetch vendor profile error: $e');
//       debugPrintStack(stackTrace: stackTrace);
//       return null;
//     } finally {
//       isCheckingVendorStatus.value = false;
//     }
//   }
//    Future<bool> checkVendorLoginStatus() async {
//   try {
//     debugPrint('Checking vendor login status...');

//     final profile = await fetchVendorProfile();

//     if (profile == null) {
//       debugPrint('Vendor profile not found or API failed.');
//       return false;
//     }

//     final status = (profile['registration_status'] ??
//             profile['status'] ??
//             '')
//         .toString()
//         .trim()
//         .toLowerCase();

//     debugPrint('Vendor registration status: $status');

//     if (status == 'approved' || status == 'approve') {
//       Get.offAll(() => const VendorHomePage());
//       return true;
//     }

//     if (status == 'pending') {
//       Get.offAll(
//         () => VendorPendingScreen(profile: profile),
//       );
//       return true;
//     }

//     if (status == 'rejected' || status == 'reject') {
//       Get.offAll(
//         () => VendorRejectedScreen(profile: profile),
//       );
//       return true;
//     }

//     return false;
//   } catch (e, stackTrace) {
//     debugPrint('Vendor login status error: $e');
//     debugPrintStack(stackTrace: stackTrace);
//     return false;
//   }
// }
//   // ============================================================
//   // NAVIGATE AFTER SUCCESSFUL LOGIN
//   // ============================================================

//   Future<void> navigateAfterLogin() async {
//     final role = userRole.value.trim().toLowerCase();

//     // Keep the current fallback for admin users. If your app has a dedicated
//     // admin dashboard, replace this destination with that existing screen.
//     if (role == 'admin') {
//       Get.offAll(() => const RoleSelectionScreen());
//       return;
//     }

//     // ============================================================
//     // DRIVER LOGIN / REGISTRATION STATUS FLOW
//     // ============================================================
//     // Keep this branch separate so the existing manufacturer flow below
//     // remains unchanged.
//     if (role == 'driver') {
//       try {
//         final driverProfile =
//             await DriverRegistrationService().fetchDriverProfile();

//         final status = (
//           driverProfile['registration_status'] ??
//           driverProfile['status'] ??
//           driverProfile['driver_status'] ??
//           driverProfile['approval_status'] ??
//           ''
//         ).toString().trim().toLowerCase();

//         debugPrint('Navigation after login; driver status: $status');

//         if (status == 'pending') {
//           Get.offAll(
//             () => DriverPendingScreen(profile: driverProfile),
//           );
//           return;
//         }

//         if (status == 'rejected' || status == 'reject') {
//           Get.offAll(
//             () => DriverRejectedScreen(profile: driverProfile),
//           );
//           return;
//         }

//         if (status == 'approved' || status == 'approve') {
//           Get.offAll(() => const DriverHomePage());
//           return;
//         }

//         Get.snackbar(
//           'Registration Status',
//           'Unable to determine your driver registration status.',
//         );
//         return;
//       } catch (e, stackTrace) {
//         debugPrint('Driver profile fetch error: $e');
//         debugPrintStack(stackTrace: stackTrace);

//         Get.snackbar(
//           'Error',
//           'Unable to check driver registration status. Please try again.',
//         );
//         return;
//       }
//     }

//     // ============================================================
//     // VENDOR LOGIN / REGISTRATION STATUS FLOW
//     // ============================================================
//     if (role == 'vendor') {
//       final vendorProfile = await fetchVendorProfile();

//       if (vendorProfile == null) {
//         Get.snackbar(
//           'Vendor Status',
//           'Unable to fetch vendor details. Please try again.',
//         );
//         return;
//       }

//       final status = (
//         vendorProfile['registration_status'] ??
//         vendorProfile['status'] ??
//         ''
//       ).toString().trim().toLowerCase();

//       debugPrint('Navigation after login; vendor status: $status');

//       if (status == 'pending') {
//         Get.offAll(
//           () => VendorPendingScreen(profile: vendorProfile),
//         );
//         return;
//       }

//       if (status == 'rejected' || status == 'reject') {
//         Get.offAll(
//           () => VendorRejectedScreen(profile: vendorProfile),
//         );
//         return;
//       }

//       if (status == 'approved' || status == 'approve') {
//         Get.offAll(() => const VendorHomePage());
//         return;
//       }

//       Get.snackbar(
//         'Registration Status',
//         'Unable to determine your vendor registration status.',
//       );
//       return;
//     }

//     // ============================================================
//     // TRUCK OWNER LOGIN / REGISTRATION STATUS FLOW
//     // ============================================================
//     // Check the Truck Owner profile when the backend supplies a known
//     // Truck Owner role. If the role is empty, try this profile first;
//     // when no Truck Owner profile exists, continue to Manufacturer.
//     const truckOwnerRoles = {
//       'truckowner',
//       'truck_owner',
//       'truck-owner',
//       'truck owner',
//     };

//     if (truckOwnerRoles.contains(role) || role.isEmpty) {
//       debugPrint('Checking Truck Owner login status...');

//       final ownerController =
//           Get.isRegistered<TruckOwnerRegistrationController>()
//               ? Get.find<TruckOwnerRegistrationController>()
//               : Get.put(TruckOwnerRegistrationController());

//       final ownerProfile =
//           await ownerController.checkTruckOwnerStatus();

//       if (ownerProfile != null) {
//         final ownerStatus = (
//           ownerProfile['registration_status'] ??
//           ownerProfile['status'] ??
//           ''
//         ).toString().trim().toLowerCase();

//         debugPrint(
//           'Navigation after login; Truck Owner status: $ownerStatus',
//         );

//         if (ownerStatus == 'pending') {
//           Get.offAll(
//             () => TruckOwnerPendingScreen(profile: ownerProfile),
//           );
//           return;
//         }

//         if (ownerStatus == 'rejected' || ownerStatus == 'reject') {
//           Get.offAll(
//             () => TruckOwnerRejectedScreen(profile: ownerProfile),
//           );
//           return;
//         }

//         if (ownerStatus == 'approved' || ownerStatus == 'approve') {
//           Get.offAll(() => const OwnerHomePage());
//           return;
//         }

//         Get.snackbar(
//           'Registration Status',
//           'Unable to determine Truck Owner registration status.',
//         );
//         return;
//       }

//       debugPrint(
//         'Truck Owner profile was not found or could not be fetched: '
//         '${ownerController.statusErrorMessage.value}',
//       );

//       // If the backend explicitly identified this user as a Truck Owner,
//       // do not send them to another role's flow when the profile request fails.
//       if (truckOwnerRoles.contains(role)) {
//         Get.snackbar(
//           'Truck Owner Status',
//           ownerController.statusErrorMessage.value.isNotEmpty
//               ? ownerController.statusErrorMessage.value
//               : 'Unable to fetch Truck Owner details. Please try again.',
//         );
//         return;
//       }

//       // Empty role: continue to the existing Manufacturer profile check.
//     }

//     // The access token has already been saved by verifyOtp() before this
//     // method is called, so the authenticated profile request can now run.
//     final profile = await fetchManufacturerProfile();

//     if (profile != null) {
//       final status = (
//         profile['registration_status'] ??
//         profile['status'] ??
//         ''
//       ).toString().trim().toLowerCase();

//       debugPrint('Navigation after login; manufacturer status: $status');

//       if (status == 'pending') {
//         Get.offAll(
//           () => ManufacturerPendingScreen(profile: profile),
//         );
//         return;
//       }

//       if (status == 'rejected') {
//         Get.offAll(
//           () => ManufacturerRejectedScreen(profile: profile),
//         );
//         return;
//       }
//     }

//     // Users without a manufacturer profile can continue to role selection.
//     // If the profile request fails temporarily, login still remains usable.
//     Get.offAll(() => const RoleSelectionScreen());
//   }

// }



import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../presentation/screens/registration/vendor_status_screens.dart';
import '../models/auth_model.dart';
import '../../services/auth_service.dart';
import '../../services/driver_registration_service.dart';
import '../../services/vendor_registration_service.dart';
import '../../core/storage/LocalStorageConstants.dart';

// Adjust the ManufacturerStatus folder name here if your project uses a
// different folder for manufacturer_status_screens.dart.
import '../../presentation/screens/Registration/manufacturer_status_screens.dart';
import '../../presentation/screens/Registration/driver_status_screens.dart';
import '../../presentation/screens/HomePages/driver_home_page.dart';
import '../../presentation/screens/HomePages/vendor_home_page.dart';
import '../../presentation/screens/RolePage/role_selection_screen.dart';
import '../../presentation/screens/registration/truck_owner_status_screens.dart';
import '../../presentation/screens/HomePages/owner_home_page.dart';
import 'truck_owner_registration_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxBool otpVisible = false.obs;
  final RxInt verificationId = 0.obs;
  final RxString expiresAt = ''.obs;

  final RxString userRole = ''.obs;
  final RxString authenticatedMobile = ''.obs;

  final RxMap<String, dynamic> manufacturerProfile =
      <String, dynamic>{}.obs;

  final RxBool isCheckingManufacturerStatus = false.obs;
  final RxBool isCheckingVendorStatus = false.obs;

  // Extract a useful error message from different API response formats.
  String _getErrorMessage(
    Map<String, dynamic> response,
    String fallback,
  ) {
    final message = response['message'];

    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString();
    }

    final errors = response['errors'];

    if (errors is Map) {
      return errors.entries.map((entry) {
        final value = entry.value;

        if (value is List) {
          return '${entry.key}: ${value.join(', ')}';
        }

        return '${entry.key}: $value';
      }).join('\n');
    }

    return fallback;
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<bool> sendOtp(String mobileNumber) async {
    final mobile = mobileNumber.trim();

    debugPrint('========== SEND OTP START ==========');

    if (!_isValidMobile(mobile)) {
      Get.snackbar(
        'Invalid Mobile',
        'Enter a valid 10-digit mobile number.',
      );
      return false;
    }

    if (isLoading.value) {
      debugPrint('OTP request ignored: another request is running.');
      return false;
    }

    try {
      isLoading.value = true;

      // Reset old OTP state before requesting a new OTP.
      otpVisible.value = false;
      verificationId.value = 0;
      expiresAt.value = '';

      debugPrint('Calling AuthService.sendOtp()');

      final response = await _authService.sendOtp(mobile);

      debugPrint('Send OTP response: $response');

      if (response['success'] == true) {
        final id = int.tryParse(
          response['verification_id']?.toString() ?? '',
        );

        if (id == null || id <= 0) {
          debugPrint('Send OTP failed: invalid verification ID.');

          Get.snackbar(
            'OTP Error',
            'The server did not return a valid verification ID.',
          );

          return false;
        }

        verificationId.value = id;
        expiresAt.value = response['expires_at']?.toString() ?? '';
        otpVisible.value = true;

        debugPrint('OTP sent successfully.');
        debugPrint('Verification ID: ${verificationId.value}');
        debugPrint('========== SEND OTP END ==========');

        return true;
      }

      otpVisible.value = false;

      final error = _getErrorMessage(
        response,
        'Unable to send OTP. Please try again.',
      );

      debugPrint('Send OTP API failure: $error');

      Get.snackbar('OTP Failed', error);
      return false;
    } catch (e, stackTrace) {
      otpVisible.value = false;

      debugPrint('SEND OTP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar(
        'Connection Error',
        'Unable to send OTP. Check your connection and try again.',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<bool> resendOtp(String mobileNumber) async {
    final mobile = mobileNumber.trim();

    debugPrint('========== RESEND OTP START ==========');

    if (!_isValidMobile(mobile)) {
      Get.snackbar(
        'Invalid Mobile',
        'Enter a valid 10-digit mobile number.',
      );
      return false;
    }

    if (isLoading.value) {
      debugPrint('Resend ignored: another request is running.');
      return false;
    }

    if (verificationId.value <= 0) {
      debugPrint('Resend failed: verification ID is missing.');

      Get.snackbar(
        'OTP Error',
        'Please request an OTP before trying to resend it.',
      );

      return false;
    }

    try {
      isLoading.value = true;

      debugPrint('Resending OTP for verification ID: '
          '${verificationId.value}');

      final response = await _authService.resendOtp(
        mobile,
        verificationId.value,
      );

      debugPrint('Resend OTP response: $response');

      if (response['success'] == true) {
        final newId = int.tryParse(
          response['verification_id']?.toString() ?? '',
        );

        // Some APIs return a new verification ID; others retain the old one.
        if (newId != null && newId > 0) {
          verificationId.value = newId;
        }

        expiresAt.value =
            response['expires_at']?.toString() ?? expiresAt.value;

        otpVisible.value = true;

        debugPrint('OTP resent successfully.');
        debugPrint('Current verification ID: ${verificationId.value}');
        debugPrint('========== RESEND OTP END ==========');

        Get.snackbar(
          'OTP Sent',
          'A new OTP has been requested.',
        );

        return true;
      }

      final error = _getErrorMessage(
        response,
        'Unable to resend OTP. Please try again.',
      );

      debugPrint('Resend OTP API failure: $error');

      Get.snackbar('Resend Failed', error);
      return false;
    } catch (e, stackTrace) {
      debugPrint('RESEND OTP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar(
        'Connection Error',
        'Unable to resend OTP. Check your connection and try again.',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<bool> verifyOtp(String mobileNumber, String otp) async {
    final mobile = mobileNumber.trim();
    final enteredOtp = otp.trim();

    debugPrint('========== VERIFY OTP START ==========');

    if (!_isValidMobile(mobile)) {
      Get.snackbar(
        'Invalid Mobile',
        'Enter a valid 10-digit mobile number.',
      );
      return false;
    }

    if (enteredOtp.isEmpty) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the OTP.',
      );
      return false;
    }

    if (verificationId.value <= 0) {
      Get.snackbar(
        'OTP Error',
        'Please request a new OTP before verifying.',
      );
      return false;
    }

    if (isLoading.value) {
      debugPrint('Verification ignored: another request is running.');
      return false;
    }

    try {
      isLoading.value = true;

      debugPrint('Calling AuthService.verifyOtp()');

      final response = await _authService.verifyOtp(
        mobile,
        enteredOtp,
        verificationId.value,
      );

      debugPrint('Verify OTP response: $response');

      final authResponse = AuthResponse.fromJson(response);

      if (!authResponse.success) {
        final error = _getErrorMessage(
          response,
          'OTP verification failed.',
        );

        debugPrint('OTP verification rejected: $error');

        Get.snackbar('Login Failed', error);
        return false;
      }

      final accessToken = authResponse.accessToken;
      final refreshToken = authResponse.refreshToken;

      if (accessToken == null ||
          accessToken.isEmpty ||
          refreshToken == null ||
          refreshToken.isEmpty) {
        Get.snackbar(
          'Login Failed',
          'Authentication tokens were not returned by the server.',
        );
        return false;
      }

      final Map<String, dynamic> claims;

      try {
        claims = JwtDecoder.decode(accessToken);
      } catch (e, stackTrace) {
        debugPrint('JWT decoding error: $e');
        debugPrintStack(stackTrace: stackTrace);

        Get.snackbar(
          'Login Failed',
          'Unable to read authentication details.',
        );

        return false;
      }

      // Read roles from the JWT.
      final List<String> tokenRoles = [];

      final dynamic rolesClaim = claims['roles'];
      final dynamic roleClaim = claims['role'];

      if (rolesClaim is List) {
        tokenRoles.addAll(
          rolesClaim
              .map((value) => value.toString().trim().toLowerCase())
              .where((value) => value.isNotEmpty),
        );
      } else if (rolesClaim is String) {
        tokenRoles.addAll(
          rolesClaim
              .split(',')
              .map((value) => value.trim().toLowerCase())
              .where((value) => value.isNotEmpty),
        );
      }

      if (roleClaim is String && roleClaim.trim().isNotEmpty) {
        final role = roleClaim.trim().toLowerCase();

        if (!tokenRoles.contains(role)) {
          tokenRoles.add(role);
        }
      }

      // Prefer roles returned by the API; otherwise use JWT roles.
      final List<String> apiRoles = [];
      final dynamic apiRolesClaim = response['roles'];

      if (apiRolesClaim is List) {
        apiRoles.addAll(
          apiRolesClaim
              .map((value) => value.toString().trim().toLowerCase())
              .where((value) => value.isNotEmpty),
        );
      } else if (apiRolesClaim is String &&
          apiRolesClaim.trim().isNotEmpty) {
        apiRoles.addAll(
          apiRolesClaim
              .split(',')
              .map((value) => value.trim().toLowerCase())
              .where((value) => value.isNotEmpty),
        );
      }

      final roles = apiRoles.isNotEmpty ? apiRoles : tokenRoles;

      if (roles.contains('admin')) {
        userRole.value = 'admin';
      } else if (roles.isNotEmpty) {
        userRole.value = roles.first;
      } else {
        userRole.value = '';
      }

      authenticatedMobile.value =
          claims['mobile_number']?.toString().trim() ??
          claims['mobile']?.toString().trim() ??
          mobile;

      if (authenticatedMobile.value.isEmpty) {
        authenticatedMobile.value = mobile;
      }

      // Save tokens only after successful verification and validation.
      await LocalStorageConstants.saveAccessToken(accessToken);
      await LocalStorageConstants.saveRefreshToken(refreshToken);
      await LocalStorageConstants.saveMobileNumber(
        authenticatedMobile.value,
      );

      debugPrint('OTP verification successful.');
      debugPrint('Roles from API: $apiRoles');
      debugPrint('Roles from JWT: $tokenRoles');
      debugPrint('Authenticated role: ${userRole.value}');
      debugPrint('Next screen: ${response['next_screen']}');
      debugPrint('========== VERIFY OTP END ==========');

      return true;
    } catch (e, stackTrace) {
      debugPrint('VERIFY OTP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar(
        'Verification Error',
        'Unable to verify OTP. Please try again.',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // FETCH MANUFACTURER PROFILE / REGISTRATION STATUS
  // ============================================================

  Future<Map<String, dynamic>?> fetchManufacturerProfile() async {
    try {
      isCheckingManufacturerStatus.value = true;

      final accessToken =
          await LocalStorageConstants.getAccessToken();

      if (accessToken == null || accessToken.trim().isEmpty) {
        debugPrint(
          'Manufacturer profile check failed: access token missing.',
        );
        return null;
      }

      final response = await _authService.getManufacturerProfile(
        accessToken.trim(),
      );

      debugPrint('Manufacturer profile response: $response');

      if (response['success'] != true) {
        debugPrint(
          'Manufacturer profile API failure: '
          '${_getErrorMessage(response, 'Unknown server response')}',
        );
        return null;
      }

      final dynamic data = response['data'];

      final Map<String, dynamic> profile;

      if (data is Map) {
        profile = Map<String, dynamic>.from(data);
      } else {
        profile = Map<String, dynamic>.from(response)
          ..remove('success')
          ..remove('message');
      }

      manufacturerProfile.assignAll(profile);

      debugPrint(
        'Manufacturer registration status: '
        '${profile['registration_status'] ?? profile['status'] ?? 'unknown'}',
      );

      return profile;
    } catch (e, stackTrace) {
      debugPrint('Fetch manufacturer profile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    } finally {
      isCheckingManufacturerStatus.value = false;
    }
  }

  // ============================================================
  // FETCH VENDOR PROFILE / REGISTRATION STATUS
  // ============================================================

  Future<Map<String, dynamic>?> fetchVendorProfile() async {
    try {
      isCheckingVendorStatus.value = true;

      final response =
          await VendorRegistrationService().fetchVendorProfile();
      final vendor = response.data;

      if (vendor == null) {
        debugPrint('Vendor profile data is missing.');
        return null;
      }

      final status = vendor.status.toString().trim().toLowerCase();

      final Map<String, dynamic> profile = {
        'vendor_id': vendor.vendorId,
        'full_name': vendor.fullName,
        'email': vendor.email,
        'mobile_number': vendor.mobileNumber,
        'alternate_mobile_number': vendor.alternateMobileNumber,
        'business_name': vendor.businessName,
        'business_type': vendor.businessType,
        'business_category': vendor.businessCategory,
        'gst_number': vendor.gstNumber,
        'business_registration_number':
            vendor.businessRegistrationNumber,
        'years_in_business': vendor.yearsInBusiness,
        'address_line1': vendor.addressLine1,
        'address_line2': vendor.addressLine2,
        'city': vendor.city,
        'district': vendor.district,
        'state': vendor.state,
        'pincode': vendor.pincode,
        'profile_photo': vendor.profilePhoto,
        'gst_certificate': vendor.gstCertificate,
        'address_proof': vendor.addressProof,
        'transport_permit_document': vendor.transportPermitDocument,
        'business_license': vendor.businessLicense,
        'status': status,
        'registration_status': status,
        'rejection_reason': vendor.rejectionReason,
        'reviewed_at': vendor.reviewedAt,
        'created_at': vendor.createdAt,
        'updated_at': vendor.updatedAt,
      };

      debugPrint('Vendor registration status: $status');
      return profile;
    } catch (e, stackTrace) {
      debugPrint('Fetch vendor profile error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    } finally {
      isCheckingVendorStatus.value = false;
    }
  }
   Future<bool> checkVendorLoginStatus() async {
  try {
    debugPrint('Checking vendor login status...');

    final profile = await fetchVendorProfile();

    if (profile == null) {
      debugPrint('Vendor profile not found or API failed.');
      return false;
    }

    final status = (profile['registration_status'] ??
            profile['status'] ??
            '')
        .toString()
        .trim()
        .toLowerCase();

    debugPrint('Vendor registration status: $status');

    if (status == 'approved' || status == 'approve') {
      Get.offAll(() => const VendorHomePage());
      return true;
    }

    if (status == 'pending') {
      Get.offAll(
        () => VendorPendingScreen(profile: profile),
      );
      return true;
    }

    if (status == 'rejected' || status == 'reject') {
      Get.offAll(
        () => VendorRejectedScreen(profile: profile),
      );
      return true;
    }

    return false;
  } catch (e, stackTrace) {
    debugPrint('Vendor login status error: $e');
    debugPrintStack(stackTrace: stackTrace);
    return false;
  }
}
  // ============================================================
  // NAVIGATE AFTER SUCCESSFUL LOGIN
  // ============================================================

  Future<void> navigateAfterLogin() async {
    final role = userRole.value.trim().toLowerCase();

    // Keep the current fallback for admin users. If your app has a dedicated
    // admin dashboard, replace this destination with that existing screen.
    if (role == 'admin') {
      Get.offAll(() => const RoleSelectionScreen());
      return;
    }

    // ============================================================
    // DRIVER ROLE: CHECK TRUCK OWNER SELF-DRIVER FIRST
    // ============================================================
    if (role == 'driver') {
      bool isTruckOwnerSelfDriver = false;

      try {
        final ownerController =
            Get.isRegistered<TruckOwnerRegistrationController>()
                ? Get.find<TruckOwnerRegistrationController>()
                : Get.put(TruckOwnerRegistrationController());

        debugPrint('Checking Truck Owner profile for Driver role...');

        final ownerProfile =
            await ownerController.checkTruckOwnerStatus();

        if (ownerProfile != null) {
          final selfDriverValue = ownerProfile['is_self_driver'];
          isTruckOwnerSelfDriver =
              selfDriverValue == true ||
              selfDriverValue.toString().trim().toLowerCase() == 'true';

          debugPrint(
            'Truck Owner Self Driver: $isTruckOwnerSelfDriver',
          );

          if (isTruckOwnerSelfDriver) {
            final ownerStatus = (
              ownerProfile['registration_status'] ??
              ownerProfile['status'] ??
              ''
            ).toString().trim().toLowerCase();

            debugPrint(
              'Truck Owner registration status: $ownerStatus',
            );

            if (ownerStatus == 'pending') {
              Get.offAll(
                () => TruckOwnerPendingScreen(profile: ownerProfile),
              );
              return;
            }

            if (ownerStatus == 'rejected' || ownerStatus == 'reject') {
              Get.offAll(
                () => TruckOwnerRejectedScreen(profile: ownerProfile),
              );
              return;
            }

            if (ownerStatus == 'approved' || ownerStatus == 'approve') {
              Get.offAll(() => const OwnerHomePage());
              return;
            }

            Get.snackbar(
              'Truck Owner Status',
              'Unable to determine Truck Owner registration status.',
            );
            return;
          }
        }
      } catch (e, stackTrace) {
        debugPrint('Truck Owner profile check error: $e');
        debugPrintStack(stackTrace: stackTrace);
      }

      // ============================================================
      // EXISTING INDEPENDENT DRIVER FLOW - KEEP AS IT IS
      // ============================================================
      if (!isTruckOwnerSelfDriver) {
        try {
          final driverProfile =
              await DriverRegistrationService().fetchDriverProfile();

          final status = (
            driverProfile['registration_status'] ??
            driverProfile['status'] ??
            driverProfile['driver_status'] ??
            driverProfile['approval_status'] ??
            ''
          ).toString().trim().toLowerCase();

          debugPrint('Navigation after login; driver status: $status');

          if (status == 'pending') {
            Get.offAll(
              () => DriverPendingScreen(profile: driverProfile),
            );
            return;
          }

          if (status == 'rejected' || status == 'reject') {
            Get.offAll(
              () => DriverRejectedScreen(profile: driverProfile),
            );
            return;
          }

          if (status == 'approved' || status == 'approve') {
            Get.offAll(() => const DriverHomePage());
            return;
          }

          Get.snackbar(
            'Registration Status',
            'Unable to determine your driver registration status.',
          );
          return;
        } catch (e, stackTrace) {
          debugPrint('Driver profile fetch error: $e');
          debugPrintStack(stackTrace: stackTrace);

          Get.snackbar(
            'Error',
            'Unable to check driver registration status. Please try again.',
          );
          return;
        }
      }
    }

    // ============================================================
    // VENDOR LOGIN / REGISTRATION STATUS FLOW
    // ============================================================
    if (role == 'vendor') {
      final vendorProfile = await fetchVendorProfile();

      if (vendorProfile == null) {
        Get.snackbar(
          'Vendor Status',
          'Unable to fetch vendor details. Please try again.',
        );
        return;
      }

      final status = (
        vendorProfile['registration_status'] ??
        vendorProfile['status'] ??
        ''
      ).toString().trim().toLowerCase();

      debugPrint('Navigation after login; vendor status: $status');

      if (status == 'pending') {
        Get.offAll(
          () => VendorPendingScreen(profile: vendorProfile),
        );
        return;
      }

      if (status == 'rejected' || status == 'reject') {
        Get.offAll(
          () => VendorRejectedScreen(profile: vendorProfile),
        );
        return;
      }

      if (status == 'approved' || status == 'approve') {
        Get.offAll(() => const VendorHomePage());
        return;
      }

      Get.snackbar(
        'Registration Status',
        'Unable to determine your vendor registration status.',
      );
      return;
    }

    // ============================================================
    // TRUCK OWNER LOGIN / REGISTRATION STATUS FLOW
    // ============================================================
    // Check the Truck Owner profile when the backend supplies a known
    // Truck Owner role. If the role is empty, try this profile first;
    // when no Truck Owner profile exists, continue to Manufacturer.
    const truckOwnerRoles = {
      'truckowner',
      'truck_owner',
      'truck-owner',
      'truck owner',
    };

    if (truckOwnerRoles.contains(role) || role.isEmpty) {
      debugPrint('Checking Truck Owner login status...');

      final ownerController =
          Get.isRegistered<TruckOwnerRegistrationController>()
              ? Get.find<TruckOwnerRegistrationController>()
              : Get.put(TruckOwnerRegistrationController());

      final ownerProfile =
          await ownerController.checkTruckOwnerStatus();

      if (ownerProfile != null) {
        final ownerStatus = (
          ownerProfile['registration_status'] ??
          ownerProfile['status'] ??
          ''
        ).toString().trim().toLowerCase();

        debugPrint(
          'Navigation after login; Truck Owner status: $ownerStatus',
        );

        if (ownerStatus == 'pending') {
          Get.offAll(
            () => TruckOwnerPendingScreen(profile: ownerProfile),
          );
          return;
        }

        if (ownerStatus == 'rejected' || ownerStatus == 'reject') {
          Get.offAll(
            () => TruckOwnerRejectedScreen(profile: ownerProfile),
          );
          return;
        }

        if (ownerStatus == 'approved' || ownerStatus == 'approve') {
          Get.offAll(() => const OwnerHomePage());
          return;
        }

        Get.snackbar(
          'Registration Status',
          'Unable to determine Truck Owner registration status.',
        );
        return;
      }

      debugPrint(
        'Truck Owner profile was not found or could not be fetched: '
        '${ownerController.statusErrorMessage.value}',
      );

      // If the backend explicitly identified this user as a Truck Owner,
      // do not send them to another role's flow when the profile request fails.
      if (truckOwnerRoles.contains(role)) {
        Get.snackbar(
          'Truck Owner Status',
          ownerController.statusErrorMessage.value.isNotEmpty
              ? ownerController.statusErrorMessage.value
              : 'Unable to fetch Truck Owner details. Please try again.',
        );
        return;
      }

      // Empty role: continue to the existing Manufacturer profile check.
    }

    // The access token has already been saved by verifyOtp() before this
    // method is called, so the authenticated profile request can now run.
    final profile = await fetchManufacturerProfile();

    if (profile != null) {
      final status = (
        profile['registration_status'] ??
        profile['status'] ??
        ''
      ).toString().trim().toLowerCase();

      debugPrint('Navigation after login; manufacturer status: $status');

      if (status == 'pending') {
        Get.offAll(
          () => ManufacturerPendingScreen(profile: profile),
        );
        return;
      }

      if (status == 'rejected') {
        Get.offAll(
          () => ManufacturerRejectedScreen(profile: profile),
        );
        return;
      }
    }

    // Users without a manufacturer profile can continue to role selection.
    // If the profile request fails temporarily, login still remains usable.
    Get.offAll(() => const RoleSelectionScreen());
  }

}

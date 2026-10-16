
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/auth_model.dart';
import '../../services/auth_service.dart';
import '../../core/storage/LocalStorageConstants.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool isLoading = false.obs;
  final RxBool otpVisible = false.obs;

  final RxInt verificationId = 0.obs;
  final RxString expiresAt = ''.obs;

  // Authenticated user information
  final RxString userRole = ''.obs;
  final RxString authenticatedMobile = ''.obs;

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<bool> sendOtp(String mobileNumber) async {
    final mobile = mobileNumber.trim();

    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      Get.snackbar(
        'Invalid Mobile',
        'Enter a valid 10-digit mobile number',
      );
      return false;
    }

    try {
      isLoading.value = true;

      final response = await _authService.sendOtp(mobile);

      if (response['success'] == true) {
        verificationId.value =
            int.tryParse(
              response['verification_id']?.toString() ?? '',
            ) ??
            0;

        expiresAt.value =
            response['expires_at']?.toString() ?? '';

        otpVisible.value = true;
        return true;
      }

      Get.snackbar(
        'OTP Failed',
        response['message']?.toString() ??
            'Unable to send OTP',
      );

      return false;
    } catch (e) {
      debugPrint('Send OTP error: $e');

      Get.snackbar(
        'Error',
        'Unable to send OTP. Please try again.',
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
    try {
      isLoading.value = true;

      final response = await _authService.resendOtp(
        mobileNumber.trim(),
        verificationId.value,
      );

      if (response['success'] == true) {
        verificationId.value =
            int.tryParse(
              response['verification_id']?.toString() ?? '',
            ) ??
            verificationId.value;

        expiresAt.value =
            response['expires_at']?.toString() ?? '';

        return true;
      }

      Get.snackbar(
        'Resend Failed',
        response['message']?.toString() ??
            'Unable to resend OTP',
      );

      return false;
    } catch (e) {
      debugPrint('Resend OTP error: $e');

      Get.snackbar(
        'Error',
        'Unable to resend OTP',
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<bool> verifyOtp(
    String mobileNumber,
    String otp,
  ) async {
    try {
      isLoading.value = true;

      final mobile = mobileNumber.trim();

      if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
        Get.snackbar(
          'Invalid Mobile',
          'Enter a valid 10-digit mobile number',
        );
        return false;
      }

      final response = await _authService.verifyOtp(
        mobile,
        otp.trim(),
        verificationId.value,
      );

      final authResponse = AuthResponse.fromJson(response);

      if (!authResponse.success) {
        Get.snackbar(
          'Login Failed',
          response['message']?.toString() ??
              'OTP verification failed',
        );
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
          'Authentication tokens were not returned by the server',
        );
        return false;
      }

      // Clear previous user details before processing this login.
      userRole.value = '';
      authenticatedMobile.value = '';

      // Decode JWT claims.
      final Map<String, dynamic> claims;

      try {
        claims = JwtDecoder.decode(accessToken);
      } catch (e) {
        debugPrint('JWT decoding error: $e');

        Get.snackbar(
          'Login Failed',
          'Unable to read authentication details',
        );

        return false;
      }

      // Support either "role" or "roles".
      final List<String> roles = [];

      final dynamic rolesClaim = claims['roles'];
      final dynamic roleClaim = claims['role'];

      if (rolesClaim is List) {
        roles.addAll(
          rolesClaim
              .map(
                (value) =>
                    value.toString().trim().toLowerCase(),
              )
              .where((value) => value.isNotEmpty),
        );
      } else if (rolesClaim is String) {
        roles.addAll(
          rolesClaim
              .split(',')
              .map(
                (value) =>
                    value.trim().toLowerCase(),
              )
              .where((value) => value.isNotEmpty),
        );
      }

      if (roleClaim is String &&
          roleClaim.trim().isNotEmpty) {
        final role = roleClaim.trim().toLowerCase();

        if (!roles.contains(role)) {
          roles.add(role);
        }
      }

      // Select the authenticated user's role.
      if (roles.contains('admin')) {
        userRole.value = 'admin';
      } else if (roles.isNotEmpty) {
        userRole.value = roles.first;
      }

      // Read the mobile number from the token when available.
      authenticatedMobile.value =
          claims['mobile_number']?.toString().trim() ??
          claims['mobile']?.toString().trim() ??
          mobile;

      if (authenticatedMobile.value.isEmpty) {
        authenticatedMobile.value = mobile;
      }

      // Save tokens and authenticated mobile number.
      await LocalStorageConstants.saveAccessToken(
        accessToken,
      );

      await LocalStorageConstants.saveRefreshToken(
        refreshToken,
      );

      await LocalStorageConstants.saveMobileNumber(
        authenticatedMobile.value,
      );

      debugPrint('OTP verification successful');
      debugPrint('Authenticated role: ${userRole.value}');
      debugPrint(
        'Authenticated mobile available: '
        '${authenticatedMobile.value.isNotEmpty}',
      );

      // OTP succeeded even if the token has no recognized role.
      // The login screen should handle an empty role explicitly.
      return true;
    // } catch (e) {
    //   debugPrint('Verify OTP error: $e');

    //   Get.snackbar(
    //     'Invalid OTP',
    //     ' Please Try Again.',
    //   );
    //   return false;
    // } finally {
    //   isLoading.value = false;
    // }
    } catch (e, stackTrace) {
  debugPrint('Verify OTP error: $e');
  debugPrintStack(stackTrace: stackTrace);

  Get.snackbar(
    'Invalid OTP',
    'Please enter valid OTP.',
  );

  return false;
} finally {
  isLoading.value = false;
}
  }
}

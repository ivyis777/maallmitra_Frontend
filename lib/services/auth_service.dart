


import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/app url.dart';

class AuthService {
  static const Duration _timeout = Duration(seconds: 15);

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<Map<String, dynamic>> sendOtp(
    String mobileNumber,
  ) {
    return _postRequest(
      AppUrl.sendOtp,
      {
        'mobile_number': mobileNumber.trim(),
        'channel': 'sms',
      },
    );
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<Map<String, dynamic>> verifyOtp(
    String mobileNumber,
    String otp,
    int verificationId,
  ) {
    return _postRequest(
      AppUrl.verifyOtp,
      {
        'mobile_number': mobileNumber.trim(),
        'otp': otp.trim(),
        'verification_id': verificationId.toString(),
        'channel': 'sms',
      },
    );
  }

  // ============================================================
  // RESEND OTP
  // ============================================================

  Future<Map<String, dynamic>> resendOtp(
    String mobileNumber,
    int verificationId,
  ) {
    return _postRequest(
      AppUrl.resendOtp,
      {
        'mobile_number': mobileNumber.trim(),
        'verification_id': verificationId,
        'channel': 'sms',
      },
    );
  }

  // ============================================================
  // MANUFACTURER PROFILE
  // ============================================================

  Future<Map<String, dynamic>> getManufacturerProfile(
    String accessToken,
  ) async {
    final uri = Uri.parse(AppUrl.manufacturerProfile);

    try {
      debugPrint('========== MANUFACTURER PROFILE ==========');
      debugPrint('API URL: $uri');

      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          )
          .timeout(_timeout);

      return _decodeResponse(response);
    } on TimeoutException {
      debugPrint('Manufacturer profile request timed out.');
      throw Exception('Server connection timed out.');
    } catch (e, stackTrace) {
      debugPrint('Manufacturer profile request error: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================
  // COMMON POST REQUEST
  // ============================================================

  Future<Map<String, dynamic>> _postRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(url);

    try {
      debugPrint('========== AUTH API REQUEST ==========');
      debugPrint('API URL: $uri');

      // Do not print OTPs or authentication secrets.
      debugPrint('Request fields: ${body.keys.toList()}');

      final response = await http
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      debugPrint('HTTP Status: ${response.statusCode}');
      debugPrint('API Response: ${response.body}');

      return _decodeResponse(response);
    } on TimeoutException {
      debugPrint('Auth request timed out: $uri');
      throw Exception(
        'Server connection timed out. Please try again.',
      );
    } on FormatException catch (e) {
      debugPrint('Invalid JSON response: $e');
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Auth API request failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  // ============================================================
  // COMMON RESPONSE DECODER
  // ============================================================

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'Server returned an invalid JSON response '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw Exception(
      'Unexpected server response format '
      '(HTTP ${response.statusCode}).',
    );
  }
}

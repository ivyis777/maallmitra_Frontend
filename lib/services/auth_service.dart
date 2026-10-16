import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app url.dart';
class AuthService {
  static const String _sendOtpUrl = '${AppUrl.baseUrl}send-otp/';  
  static const String _resendOtpUrl = '${AppUrl.baseUrl}resend-otp/'; 
  static const String _loginUrl = '${AppUrl.baseUrl}login/';

  // ==========================================================
  // SEND OTP
  // ==========================================================

  Future<Map<String, dynamic>> sendOtp(
    String mobileNumber,
  ) async {
    return _postRequest(
      _sendOtpUrl,
      {
        'mobile_number': mobileNumber,
        'channel': 'sms',
      },
    );
  }

  // ==========================================================
  // VERIFY OTP / LOGIN
  // ==========================================================

  Future<Map<String, dynamic>> verifyOtp(
    String mobileNumber,
    String otp,
    int verificationId,
  ) async {
    return _postRequest(
      _loginUrl,
      {
        'mobile_number': mobileNumber,
        'otp': otp,
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
) async {
  return _postRequest(
    _resendOtpUrl
    ,
    {
      'mobile_number': mobileNumber,
      'verification_id': verificationId,
      'channel': 'sms',
    },
  );
}

  // ==========================================================
  // COMMON POST REQUEST
  // ==========================================================

  Future<Map<String, dynamic>> _postRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    try {
      debugPrint('API URL: $url');
      debugPrint('API Request: $body');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 15),
          );

      debugPrint(
        'API Status: ${response.statusCode}',
      );

      debugPrint(
        'API Response: ${response.body}',
      );

      Map<String, dynamic> data = {};

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      }

      // Your API returns 200 even for many false responses,
      // so return the response body to the controller.
      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return data;
      }
      String message = 'Request failed';
      if (data['errors'] != null) {
        message = data['errors'].toString();
      } else if (data['message'] != null) {
        message = data['message'].toString();
      } else if (data['detail'] != null) {
        message = data['detail'].toString();
      }

      throw Exception(message);
    } on TimeoutException {
      throw Exception(
        'Server connection timed out',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception(
        'Unable to connect to server',
      );
    }
  }
}

class SendOtpRequest {
  final String mobileNumber;

  SendOtpRequest({
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile_number': mobileNumber,
      'channel': 'sms',
    };
  }
}

// ============================================================
// VERIFY OTP REQUEST
// ============================================================

class VerifyOtpRequest {
  final String mobileNumber;
  final String otp;

  VerifyOtpRequest({
    required this.mobileNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'mobile_number': mobileNumber,
      'otp': otp,
    };
  }
}

// ============================================================
// AUTH RESPONSE
// ============================================================

class AuthResponse {
  final bool success;
  final String message;

  // Old token field
  final String? token;

  // OTP details
  final int? verificationId;
  final String? expiresAt;

  // Login tokens
  final String? accessToken;
  final String? refreshToken;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.verificationId,
    this.expiresAt,
    this.accessToken,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthResponse(
      success: json['success'] == true,

      message:
          json['message']?.toString() ?? '',

      token:
          json['token']?.toString(),

      verificationId:
          json['verification_id'] != null
              ? int.tryParse(
                  json['verification_id'].toString(),
                )
              : null,

      expiresAt:
          json['expires_at']?.toString(),

      accessToken:
          json['access_token']?.toString(),

      refreshToken:
          json['refresh_token']?.toString(),
    );
  }
}

 class Validators {
  static String? mobile(String value) {
    final mobile = value.trim();

    if (mobile.isEmpty) {
      return 'Mobile number is required';
    }

    if (mobile.length != 10) {
      return 'Enter a valid 10-digit mobile number';
    }

    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(mobile)) {
      return 'Enter a valid mobile number';
    }

    return null;
  }

  static String? otp(String value) {
    if (value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != 4) {
      return 'Enter 4-digit OTP';
    }

    if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }

    return null;
  }
}
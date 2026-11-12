
class Validators {
  // ============================================================
  // NAME VALIDATION
  // ============================================================

  static String? name(String value) {
    final name = value.trim();

    if (name.isEmpty) {
      return 'Name is required';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters';
    }

    if (name.length > 100) {
      return 'Name cannot exceed 100 characters';
    }

    if (!RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(name)) {
      return 'Enter a valid name';
    }

    return null;
  }

  // ============================================================
  // MOBILE NUMBER VALIDATION
  // ============================================================

  static String? mobile(String value) {
    final mobile = value.trim();

    if (mobile.isEmpty) {
      return 'Mobile number is required';
    }

    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(mobile)) {
      return 'Enter a valid 10-digit mobile number';
    }

    return null;
  }

  // ============================================================
  // OTP VALIDATION
  // ============================================================

  static String? otp(String value) {
    final otp = value.trim();

    if (otp.isEmpty) {
      return 'OTP is required';
    }

    if (!RegExp(r'^[0-9]{4}$').hasMatch(otp)) {
      return 'Enter a valid 4-digit OTP';
    }

    return null;
  }

  // ============================================================
  // EMAIL VALIDATION
  // ============================================================

  static String? email(String value) {
    final email = value.trim();

    if (email.isEmpty) {
      return 'Email address is required';
    }

    if (!RegExp(
      r'^[A-Za-z0-9.!#$%&amp;'
      r"'*+/=?^_`{|}~-]+@"
      r'[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?'
      r'(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)+$',
    ).hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // ============================================================
  // REQUIRED TEXT VALIDATION
  // ============================================================

  static String? required(String value, {String field = 'This field'}) {
    if (value.trim().isEmpty) {
      return '$field is required';
    }

    return null;
  }

  // ============================================================
  // ADDRESS VALIDATION
  // ============================================================

  static String? address(String value) {
    final address = value.trim();

    if (address.isEmpty) {
      return 'Address is required';
    }

    if (address.length < 5) {
      return 'Enter a complete address';
    }

    if (address.length > 250) {
      return 'Address cannot exceed 250 characters';
    }

    return null;
  }

  // ============================================================
  // CITY / STATE / COUNTRY VALIDATION
  // ============================================================

  static String? locationName(
    String value, {
    String field = 'This field',
  }) {
    final location = value.trim();

    if (location.isEmpty) {
      return '$field is required';
    }

    if (location.length < 2 ||
        !RegExp(r"^[a-zA-Z][a-zA-Z .'-]*$").hasMatch(location)) {
      return 'Enter a valid ${field.toLowerCase()}';
    }

    return null;
  }

  // ============================================================
  // PIN CODE VALIDATION (INDIA)
  // ============================================================

  static String? pinCode(String value) {
    final pin = value.trim();

    if (pin.isEmpty) {
      return 'PIN code is required';
    }

    if (!RegExp(r'^[1-9][0-9]{5}$').hasMatch(pin)) {
      return 'Enter a valid 6-digit PIN code';
    }

    return null;
  }

  // ============================================================
  // COMPANY NAME VALIDATION
  // ============================================================

  static String? companyName(String value) {
    final company = value.trim();

    if (company.isEmpty) {
      return 'Company name is required';
    }

    if (company.length < 2 || company.length > 150) {
      return 'Company name must contain 2–150 characters';
    }

    if (!RegExp(r"^[a-zA-Z0-9][a-zA-Z0-9 &.,'()/\-]*$")
        .hasMatch(company)) {
      return 'Enter a valid company name';
    }

    return null;
  }

  // ============================================================
  // GST NUMBER VALIDATION (INDIA)
  // ============================================================

  static String? gstNumber(String value) {
    final gst = value.trim().toUpperCase();

    if (gst.isEmpty) {
      return 'GST number is required';
    }

    // if (!RegExp(
    //   r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]'
    //   r'[1-9A-Z]Z[0-9A-Z]$',
    // ).hasMatch(gst)) {
    //   return 'Enter a valid GST number';
    // }

    return null;
  }

  // ============================================================
  // COMPANY REGISTRATION NUMBER
  // ============================================================

  static String? companyRegistrationNumber(String value) {
    final number = value.trim();

    if (number.isEmpty) {
      return 'Company registration number is required';
    }

    if (number.length < 3 || number.length > 50) {
      return 'Enter a valid registration number';
    }

    return null;
  }

  // ============================================================
  // YEAR OF ESTABLISHMENT
  // ============================================================

  static String? establishmentYear(String value) {
    final year = value.trim();

    if (year.isEmpty) {
      return 'Year of establishment is required';
    }

    if (!RegExp(r'^[0-9]{4}$').hasMatch(year)) {
      return 'Enter a valid 4-digit year';
    }

    final yearNumber = int.parse(year);

    if (yearNumber < 1800 || yearNumber > DateTime.now().year) {
      return 'Enter a valid establishment year';
    }

    return null;
  }

  // ============================================================
  // LANDLINE NUMBER VALIDATION
  // ============================================================

  static String? landline(String value) {
    final number = value.trim();

    if (number.isEmpty) {
      return 'Landline number is required';
    }

    if (!RegExp(r'^[0-9]{2,5}[- ]?[0-9]{6,8}$')
        .hasMatch(number)) {
      return 'Enter a valid landline number';
    }

    return null;
  }

  // ============================================================
  // DROPDOWN VALIDATION
  // ============================================================

  static String? selection(
    String? value, {
    String field = 'Selection',
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select $field';
    }

    return null;
  }

  // ============================================================
  // PRODUCT CATEGORY VALIDATION
  // ============================================================

  static String? productCategories(List<String> values) {
    if (values.isEmpty) {
      return 'Select at least one product category';
    }

    return null;
  }
}

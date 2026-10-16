
import 'package:shared_preferences/shared_preferences.dart';
class LocalStorageConstants {
// ============================================================
// AUTH TOKEN STORAGE
// ============================================================
static const String _accessTokenKey ='access_token';

static const String _refreshTokenKey ='refresh_token';

static const String _mobileNumberKey ='mobile_number';

// ============================================================
// SAVE ACCESS TOKEN
// ============================================================

static Future<void> saveAccessToken(
  String token,
) async {
  final prefs =await SharedPreferences.getInstance();

  await prefs.setString(
    _accessTokenKey,
    token,
  );
}

// ============================================================
// GET ACCESS TOKEN
// ============================================================

static Future<String?> getAccessToken() async {
  final prefs =
      await SharedPreferences.getInstance();

  return prefs.getString(
    _accessTokenKey,
  );
}

// ============================================================
// SAVE REFRESH TOKEN
// ============================================================

static Future<void> saveRefreshToken(
  String token,
) async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setString(
    _refreshTokenKey,
    token,
  );
}

// ============================================================
// GET REFRESH TOKEN
// ============================================================

static Future<String?> getRefreshToken() async {
  final prefs =
      await SharedPreferences.getInstance();

  return prefs.getString(
    _refreshTokenKey,
  );
}

// ============================================================
// SAVE MOBILE NUMBER
// ============================================================

static Future<void> saveMobileNumber(
  String mobileNumber,
) async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setString(
    _mobileNumberKey,
    mobileNumber,
  );
}

// ============================================================
// GET MOBILE NUMBER
// ============================================================

static Future<String?> getMobileNumber() async {
  final prefs =
      await SharedPreferences.getInstance();

  return prefs.getString(
    _mobileNumberKey,
  );
}

// ============================================================
// CLEAR AUTH DATA
// ============================================================

static Future<void> clearAuthData() async {
  final prefs =
      await SharedPreferences.getInstance();

  await prefs.remove(_accessTokenKey);
  await prefs.remove(_refreshTokenKey);
  await prefs.remove(_mobileNumberKey);
}

}

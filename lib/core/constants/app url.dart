// ignore_for_file: file_names
class AppUrl {
  // Local backend server
  static const String baseUrl = 'http://192.168.0.105:8000/user/';

  // OTP APIs
  static const String sendOtp = '${baseUrl}send-otp/';
  static const String verifyOtp = '${baseUrl}login/';
  static const String resendOtp = '${baseUrl}resend-otp/';

  // Registration APIs
  static const String registerDriver = '${baseUrl}driver/register/';
  static const String registerCompany = '${baseUrl}company/register/';

  // Admin: Driver registration APIs
  static const String adminDrivers = '${baseUrl}admin/drivers/';

  // Driver profile API
  static const String driverProfile = '${baseUrl}driver/profile/';
  // ADD company details Apis
  static const String companyList='${baseUrl}company/list/';
  static String companyDetails(int companyId) => '${baseUrl}company/$companyId/';
//Admin approve or reject
  static const String Approve= '${baseUrl}admin/registrations/review/';
   static const String Reject= '${baseUrl}admin/registrations/reject/';
}

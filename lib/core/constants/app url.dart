
// ignore_for_file: constant_identifier_names, file_names

class AppUrl {
  // // Local backend server
    static const String baseUrl = 'http://192.168.0.102:8000/user/';
  //  static const String baseUrl = 'https://46.224.27.248:8010/user/';

  // OTP APIs
  static const String sendOtp = '${baseUrl}send-otp/'; 
  static const String verifyOtp = '${baseUrl}login/';
  static const String resendOtp = '${baseUrl}resend-otp/';

  // Registration APIs
  static const String registerDriver = '${baseUrl}driver/register/';
  static const String registerCompany = '${baseUrl}company/register/';
  static const String registerManufacturer = '${baseUrl}manufacturer/register/';
  static const String registerVendor = '${baseUrl}vendor/register/';
  static const String registerTruckOwner = '${baseUrl}truck-owner/register/';

  // Admin: All registrations APIs
  // static const String adminAllRegistrations =
  //     '${baseUrl}admin/all-registrations/';

  static const String adminDriverRegistrations =
      '${baseUrl}admin/all-registrations/?type=driver';
  static const String adminTruckOwnerRegistrations =
      '${baseUrl}admin/all-registrations/?type=truck_owner';
  static const String adminManufacturerRegistrations =
      '${baseUrl}admin/all-registrations/?type=manufacturer';
  static const String adminVendorRegistrations =
      '${baseUrl}admin/all-registrations/?type=vendor';

  // Company APIs
  static const String companyList = '${baseUrl}company/list/';

  // Admin: Approve or reject registrations
  static const String Approve = '${baseUrl}admin/approve/';
  static const String Reject = '${baseUrl}admin/reject/';

  // User profile APIs - used to check registration status
  static const String driverProfile = '${baseUrl}driver/profile/';
  static const String truckOwnerProfile = '${baseUrl}truck-owner/profile/';
  static const String vendorProfile = '${baseUrl}vendor/profile/';
  static const String manufacturerProfile = '${baseUrl}manufacturer/profile/';

  // Admin details APIs by ID
   static String admintruckOwnerDetails(int ownerId) =>
    '${baseUrl}admin/truck-owner/registrations/$ownerId/';

  static String adminManufacturerDetails(int manufacturerId) =>
      '${baseUrl}admin/manufacturers/$manufacturerId/';

  static String adminVendorDetails(int vendorId) =>
      '${baseUrl}admin/vendors/$vendorId/';

  static String companyDetails(int companyId) =>
      '${baseUrl}company/$companyId/';

  // Admin company details by ID
  static String adminCompanyDetails(int companyId) => '${baseUrl}admin/company/$companyId/';

  // Admin driver details by ID
  static String adminDriverDetails(int driverId) => '${baseUrl}admin/driver/profile/$driverId/';
}

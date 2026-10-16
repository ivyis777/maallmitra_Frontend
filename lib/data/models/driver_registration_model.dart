class DriverRegistrationModel {
  final bool success;
  final String message;
  final int registrationId;
  final String mobileNumber;
  final String company;
  final String status;

  DriverRegistrationModel({
    required this.success,
    required this.message,
    required this.registrationId,
    required this.mobileNumber,
    required this.company,
    required this.status,
  });

  factory DriverRegistrationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverRegistrationModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      registrationId:
          json['registration_id'] ?? 0,
      mobileNumber:
          json['mobile_number'] ?? '',
      company:
          json['company'] ?? '',
      status:
          json['status'] ?? '',
    );
  }
}
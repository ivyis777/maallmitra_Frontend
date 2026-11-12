
class ManufacturerRegistrationResponse {
  final bool success;
  final String message;
  final String registrationStatus;
  final ManufacturerData? data;
  const ManufacturerRegistrationResponse({
    required this.success,
    required this.message,
    required this.registrationStatus,
    this.data,
  });
  factory ManufacturerRegistrationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return ManufacturerRegistrationResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      registrationStatus:
          json['registration_status']?.toString() ?? 'pending',
      data: json['data'] is Map<String, dynamic>
          ? ManufacturerData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ManufacturerData {
  final int? manufacturerId;
  final String companyName;
  final String gstNumber;
  final String companyRegistrationNumber;
  final int? yearOfEstablishment;
  final String companyLandlineNumber;
  final String contactPersonName;
  final String emailAddress;
  final String mobileNumber;
  final String factoryAddress;
  final String city;
  final String state;
  final String pinCode;
  final String country;
  final List<String> productCategories;
  final String? companyRegistrationCertificate;
  final String? gstCertificate;
  final String? businessAddressProof;
  final String status;
  final String? rejectionReason;

  const ManufacturerData({
    this.manufacturerId,
    required this.companyName,
    required this.gstNumber,
    required this.companyRegistrationNumber,
    this.yearOfEstablishment,
    required this.companyLandlineNumber,
    required this.contactPersonName,
    required this.emailAddress,
    required this.mobileNumber,
    required this.factoryAddress,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.country,
    required this.productCategories,
    this.companyRegistrationCertificate,
    this.gstCertificate,
    this.businessAddressProof,
    required this.status,
    this.rejectionReason,
  });

  factory ManufacturerData.fromJson(Map<String, dynamic> json) {
    return ManufacturerData(
      manufacturerId: json['manufacturer_id'] is num
          ? (json['manufacturer_id'] as num).toInt()
          : null,
      companyName: json['company_name']?.toString() ?? '',
      gstNumber: json['gst_number']?.toString() ?? '',
      companyRegistrationNumber:
          json['company_registration_number']?.toString() ?? '',
      yearOfEstablishment: json['year_of_establishment'] is num
          ? (json['year_of_establishment'] as num).toInt()
          : int.tryParse(
              json['year_of_establishment']?.toString() ?? '',
            ),
      companyLandlineNumber:
          json['company_landline_number']?.toString() ?? '',
      contactPersonName:
          json['contact_person_name']?.toString() ?? '',
      emailAddress: json['email_address']?.toString() ?? '',
      mobileNumber: json['mobile_number']?.toString() ?? '',
      factoryAddress: json['factory_address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pinCode: json['pin_code']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      productCategories:
          (json['product_categories'] as List<dynamic>? ?? [])
              .map((item) => item.toString())
              .toList(),
      companyRegistrationCertificate:
          json['company_registration_certificate']?.toString(),
      gstCertificate: json['gst_certificate']?.toString(),
      businessAddressProof:
          json['business_address_proof']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      rejectionReason: json['rejection_reason']?.toString(),
    );
  }
}


class AdminManufacturerModel {
  final int manufacturerId;
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
  final String companyRegistrationCertificate;
  final String gstCertificate;
  final String businessAddressProof;
  final String status;
  final String rejectionReason;
  final String createdAt;

  AdminManufacturerModel({
    required this.manufacturerId,
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
    required this.companyRegistrationCertificate,
    required this.gstCertificate,
    required this.businessAddressProof,
    required this.status,
    required this.rejectionReason,
    required this.createdAt,
  });

  factory AdminManufacturerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final categories = json['product_categories'];

    return AdminManufacturerModel(
      manufacturerId: int.tryParse(
            '${json['manufacturer_id'] ?? json['id'] ?? 0}',
          ) ??
          0,
      companyName: '${json['company_name'] ?? ''}',
      gstNumber: '${json['gst_number'] ?? ''}',
      companyRegistrationNumber:
          '${json['company_registration_number'] ?? ''}',
      yearOfEstablishment: int.tryParse(
        '${json['year_of_establishment'] ?? ''}',
      ),
      companyLandlineNumber:
          '${json['company_landline_number'] ?? ''}',
      contactPersonName:
          '${json['contact_person_name'] ?? ''}',
      emailAddress: '${json['email_address'] ?? ''}',
      mobileNumber: '${json['mobile_number'] ?? ''}',
      factoryAddress: '${json['factory_address'] ?? ''}',
      city: '${json['city'] ?? ''}',
      state: '${json['state'] ?? ''}',
      pinCode: '${json['pin_code'] ?? ''}',
      country: '${json['country'] ?? ''}',
      productCategories: categories is List
          ? categories.map((e) => e.toString()).toList()
          : <String>[],
      companyRegistrationCertificate:
          '${json['company_registration_certificate'] ?? ''}',
      gstCertificate: '${json['gst_certificate'] ?? ''}',
      businessAddressProof:
          '${json['business_address_proof'] ?? ''}',
      status: '${json['status'] ?? json['registration_status'] ?? 'pending'}'
          .toLowerCase(),
      rejectionReason: '${json['rejection_reason'] ?? ''}',
      createdAt: '${json['created_at'] ?? ''}',
    );
  }
}

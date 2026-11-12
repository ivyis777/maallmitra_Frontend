
class AdminVendorModel {
  final int vendorId;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String alternateMobileNumber;
  final String profilePhoto;
  final String businessName;
  final String businessType;
  final String businessCategory;
  final String gstNumber;
  final String businessRegistrationNumber;
  final int? yearsInBusiness;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String district;
  final String state;
  final String pincode;
  final String gstCertificate;
  final String addressProof;
  final String transportPermitDocument;
  final String businessLicense;
  final String status;
  final String rejectionReason;
  final String reviewedAt;
  final String createdAt;

  const AdminVendorModel({
    required this.vendorId,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.alternateMobileNumber,
    required this.profilePhoto,
    required this.businessName,
    required this.businessType,
    required this.businessCategory,
    required this.gstNumber,
    required this.businessRegistrationNumber,
    required this.yearsInBusiness,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    required this.gstCertificate,
    required this.addressProof,
    required this.transportPermitDocument,
    required this.businessLicense,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAt,
    required this.createdAt,
  });

  factory AdminVendorModel.fromJson(Map<String, dynamic> json) {
    String str(String key) => json[key]?.toString() ?? '';

    return AdminVendorModel(
      vendorId: int.tryParse(str('vendor_id')) ?? 0,
      fullName: str('full_name'),
      email: str('email'),
      mobileNumber: str('mobile_number'),
      alternateMobileNumber: str('alternate_mobile_number'),
      profilePhoto: str('profile_photo'),
      businessName: str('business_name'),
      businessType: str('business_type'),
      businessCategory: str('business_category'),
      gstNumber: str('gst_number'),
      businessRegistrationNumber:
          str('business_registration_number'),
      yearsInBusiness: int.tryParse(str('years_in_business')),
      addressLine1: str('address_line_1'),
      addressLine2: str('address_line_2'),
      city: str('city'),
      district: str('district'),
      state: str('state'),
      pincode: str('pincode'),
      gstCertificate: str('gst_certificate'),
      addressProof: str('address_proof'),
      transportPermitDocument: str('transport_permit_document'),
      businessLicense: str('business_license'),
      status: str('status'),
      rejectionReason: str('rejection_reason'),
      reviewedAt: str('reviewed_at'),
      createdAt: str('created_at'),
    );
  }
}

class AdminVendorSummary {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  const AdminVendorSummary({
    this.total = 0,
    this.pending = 0,
    this.approved = 0,
    this.rejected = 0,
  });

  factory AdminVendorSummary.fromJson(Map<String, dynamic> json) {
    int number(String key) =>
        int.tryParse(json[key]?.toString() ?? '') ?? 0;

    return AdminVendorSummary(
      total: number('total'),
      pending: number('pending'),
      approved: number('approved'),
      rejected: number('rejected'),
    );
  }
}

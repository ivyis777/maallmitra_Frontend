
class VendorRegistrationModel {
  final bool success;
  final String message;
  final String registrationStatus;
  final VendorDetails? data;

  const VendorRegistrationModel({
    required this.success,
    required this.message,
    required this.registrationStatus,
    this.data,
  });

  factory VendorRegistrationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VendorRegistrationModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      registrationStatus:
          (json['registration_status'] ??
                  json['status'] ??
                  '')
              .toString(),
      data: json['data'] is Map
          ? VendorDetails.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'registration_status': registrationStatus,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class VendorDetails {
  final int? vendorId;
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
  final DateTime? reviewedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const VendorDetails({
    this.vendorId,
    this.fullName = '',
    this.email = '',
    this.mobileNumber = '',
    this.alternateMobileNumber = '',
    this.profilePhoto = '',
    this.businessName = '',
    this.businessType = '',
    this.businessCategory = '',
    this.gstNumber = '',
    this.businessRegistrationNumber = '',
    this.yearsInBusiness,
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.district = '',
    this.state = '',
    this.pincode = '',
    this.gstCertificate = '',
    this.addressProof = '',
    this.transportPermitDocument = '',
    this.businessLicense = '',
    this.status = '',
    this.rejectionReason = '',
    this.reviewedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory VendorDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return VendorDetails(
      vendorId: _toInt(json['vendor_id']),
      fullName: _toString(json['full_name']),
      email: _toString(json['email']),
      mobileNumber: _toString(json['mobile_number']),
      alternateMobileNumber:
          _toString(json['alternate_mobile_number']),
      profilePhoto: _toString(json['profile_photo']),

      businessName: _toString(json['business_name']),
      businessType: _toString(json['business_type']),
      businessCategory: _toString(json['business_category']),
      gstNumber: _toString(json['gst_number']),
      businessRegistrationNumber:
          _toString(json['business_registration_number']),
      yearsInBusiness: _toInt(json['years_in_business']),

      addressLine1: _toString(json['address_line_1']),
      addressLine2: _toString(json['address_line_2']),
      city: _toString(json['city']),
      district: _toString(json['district']),
      state: _toString(json['state']),
      pincode: _toString(json['pincode']),

      gstCertificate: _toString(json['gst_certificate']),
      addressProof: _toString(json['address_proof']),
      transportPermitDocument:
          _toString(json['transport_permit_document']),
      businessLicense: _toString(json['business_license']),

      status: _toString(json['status']),
      rejectionReason: _toString(json['rejection_reason']),
      reviewedAt: _toDateTime(json['reviewed_at']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor_id': vendorId,
      'full_name': fullName,
      'email': email,
      'mobile_number': mobileNumber,
      'alternate_mobile_number': alternateMobileNumber,
      'profile_photo': profilePhoto,
      'business_name': businessName,
      'business_type': businessType,
      'business_category': businessCategory,
      'gst_number': gstNumber,
      'business_registration_number': businessRegistrationNumber,
      'years_in_business': yearsInBusiness,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
      'gst_certificate': gstCertificate,
      'address_proof': addressProof,
      'transport_permit_document': transportPermitDocument,
      'business_license': businessLicense,
      'status': status,
      'rejection_reason': rejectionReason,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

String _toString(dynamic value) {
  return value?.toString() ?? '';
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

DateTime? _toDateTime(dynamic value) {
  if (value == null || value.toString().isEmpty) {
    return null;
  }
  return DateTime.tryParse(value.toString());
}

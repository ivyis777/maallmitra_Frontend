// // class TruckOwnerRegistrationModel {
// //   final bool success;
// //   final String message;
// //   final TruckOwnerRegistrationData? data;

// //   TruckOwnerRegistrationModel({
// //     required this.success,
// //     required this.message,
// //     this.data,
// //   });

// //   factory TruckOwnerRegistrationModel.fromJson(
// //     Map<String, dynamic> json,
// //   ) {
// //     final rawData = json['data'];

// //     return TruckOwnerRegistrationModel(
// //       success: json['success'] == true,
// //       message: json['message']?.toString() ?? '',
// //       data: rawData is Map
// //           ? TruckOwnerRegistrationData.fromJson(
// //               Map<String, dynamic>.from(rawData),
// //             )
// //           : null,
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'success': success,
// //       'message': message,
// //       'data': data?.toJson(),
// //     };
// //   }
// // }

// // class TruckOwnerRegistrationData {
// //   final int? ownerId;
// //   final String name;
// //   final String mobileNumber;
// //   final bool isSelfDriver;
// //   final String status;
// //   final TruckOwnerSelfDriverData? selfDriver;

// //   TruckOwnerRegistrationData({
// //     this.ownerId,
// //     required this.name,
// //     required this.mobileNumber,
// //     required this.isSelfDriver,
// //     required this.status,
// //     this.selfDriver,
// //   });

// //   factory TruckOwnerRegistrationData.fromJson(
// //     Map<String, dynamic> json,
// //   ) {
// //     final rawSelfDriver = json['self_driver'];

// //     return TruckOwnerRegistrationData(
// //       ownerId: _parseInt(json['owner_id']),
// //       name: json['name']?.toString() ?? '',
// //       mobileNumber: json['mobile_number']?.toString() ?? '',
// //       isSelfDriver: json['is_self_driver'] == true,
// //       status: json['status']?.toString() ?? '',
// //       selfDriver: rawSelfDriver is Map
// //           ? TruckOwnerSelfDriverData.fromJson(
// //               Map<String, dynamic>.from(rawSelfDriver),
// //             )
// //           : null,
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'owner_id': ownerId,
// //       'name': name,
// //       'mobile_number': mobileNumber,
// //       'is_self_driver': isSelfDriver,
// //       'status': status,
// //       'self_driver': selfDriver?.toJson(),
// //     };
// //   }

// //   static int? _parseInt(dynamic value) {
// //     if (value is int) return value;
// //     return int.tryParse(value?.toString() ?? '');
// //   }
// // }

// // class TruckOwnerSelfDriverData {
// //   final int? selfDriverId;
// //   final int? companyId;
// //   final String companyName;
// //   final String drivingLicenceNumber;

// //   TruckOwnerSelfDriverData({
// //     this.selfDriverId,
// //     this.companyId,
// //     required this.companyName,
// //     required this.drivingLicenceNumber,
// //   });

// //   factory TruckOwnerSelfDriverData.fromJson(
// //     Map<String, dynamic> json,
// //   ) {
// //     return TruckOwnerSelfDriverData(
// //       selfDriverId: _parseInt(json['self_driver_id']),
// //       companyId: _parseInt(json['company_id']),
// //       companyName: json['company_name']?.toString() ?? '',
// //       drivingLicenceNumber:
// //           json['driving_licence_number']?.toString() ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'self_driver_id': selfDriverId,
// //       'company_id': companyId,
// //       'company_name': companyName,
// //       'driving_licence_number': drivingLicenceNumber,
// //     };
// //   }

// //   static int? _parseInt(dynamic value) {
// //     if (value is int) return value;
// //     return int.tryParse(value?.toString() ?? '');
// //   }
// // }

// class TruckOwnerRegistrationModel {
//   final bool success;
//   final String message;
//   final TruckOwnerRegistrationData? data;

//   TruckOwnerRegistrationModel({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory TruckOwnerRegistrationModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final rawData = json['data'];

//     return TruckOwnerRegistrationModel(
//       success: json['success'] == true,
//       message: json['message']?.toString() ?? '',
//       data: rawData is Map
//           ? TruckOwnerRegistrationData.fromJson(
//               Map<String, dynamic>.from(rawData),
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }

// class TruckOwnerRegistrationData {
//   final int? ownerId;
//   final String name;
//   final String mobileNumber;
//   final String dateOfBirth;
//   final String gender;
//   final String permanentAddress;
//   final String currentAddress;
//   final String aadhaarCardDocument;
//   final String panCardDocument;
//   final bool isSelfDriver;
//   final String status;
//   final String rejectionReason;
//   final String reviewedAt;
//   final String createdAt;
//   final String updatedAt;
//   final TruckOwnerSelfDriverData? selfDriver;

//   TruckOwnerRegistrationData({
//     this.ownerId,
//     required this.name,
//     required this.mobileNumber,
//     this.dateOfBirth = '',
//     this.gender = '',
//     this.permanentAddress = '',
//     this.currentAddress = '',
//     this.aadhaarCardDocument = '',
//     this.panCardDocument = '',
//     required this.isSelfDriver,
//     required this.status,
//     this.rejectionReason = '',
//     this.reviewedAt = '',
//     this.createdAt = '',
//     this.updatedAt = '',
//     this.selfDriver,
//   });

//   factory TruckOwnerRegistrationData.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final rawSelfDriver = json['self_driver'];

//     return TruckOwnerRegistrationData(
//       ownerId: _parseInt(json['owner_id']),
//       name: json['name']?.toString() ?? '',
//       mobileNumber: json['mobile_number']?.toString() ?? '',
//       dateOfBirth: json['date_of_birth']?.toString() ?? '',
//       gender: json['gender']?.toString() ?? '',
//       permanentAddress:
//           json['permanent_address']?.toString() ?? '',
//       currentAddress:
//           json['current_address']?.toString() ?? '',
//       aadhaarCardDocument:
//           json['aadhaar_card_document']?.toString() ?? '',
//       panCardDocument:
//           json['pan_card_document']?.toString() ?? '',
//       isSelfDriver: json['is_self_driver'] == true,
//       status: json['status']?.toString() ?? '',
//       rejectionReason:
//           json['rejection_reason']?.toString() ?? '',
//       reviewedAt: json['reviewed_at']?.toString() ?? '',
//       createdAt: json['created_at']?.toString() ?? '',
//       updatedAt: json['updated_at']?.toString() ?? '',
//       selfDriver: rawSelfDriver is Map
//           ? TruckOwnerSelfDriverData.fromJson(
//               Map<String, dynamic>.from(rawSelfDriver),
//             )
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'owner_id': ownerId,
//       'name': name,
//       'mobile_number': mobileNumber,
//       'date_of_birth': dateOfBirth,
//       'gender': gender,
//       'permanent_address': permanentAddress,
//       'current_address': currentAddress,
//       'aadhaar_card_document': aadhaarCardDocument,
//       'pan_card_document': panCardDocument,
//       'is_self_driver': isSelfDriver,
//       'status': status,
//       'rejection_reason': rejectionReason,
//       'reviewed_at': reviewedAt,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//       'self_driver': selfDriver?.toJson(),
//     };
//   }

//   static int? _parseInt(dynamic value) {
//     if (value is int) return value;
//     return int.tryParse(value?.toString() ?? '');
//   }
// }

// class TruckOwnerSelfDriverData {
//   final int? selfDriverId;
//   final int? companyId;
//   final String companyName;
//   final String drivingLicenceNumber;
//   final String dlType;
//   final String dlIssuedDate;
//   final String dlExpiredDate;
//   final String aadhaarCardDocument;
//   final String medicalCertificate;
//   final String policeVerificationCertificate;
//   final String photo;
//   final String aadhaarFront;
//   final String aadhaarBack;
//   final String dlFront;
//   final String dlBack;
//   final String companyBondDocument;
//   final String status;
//   final String rejectionReason;
//   final String reviewedAt;
//   final Map<String, dynamic>? company;

//   TruckOwnerSelfDriverData({
//     this.selfDriverId,
//     this.companyId,
//     required this.companyName,
//     required this.drivingLicenceNumber,
//     this.dlType = '',
//     this.dlIssuedDate = '',
//     this.dlExpiredDate = '',
//     this.aadhaarCardDocument = '',
//     this.medicalCertificate = '',
//     this.policeVerificationCertificate = '',
//     this.photo = '',
//     this.aadhaarFront = '',
//     this.aadhaarBack = '',
//     this.dlFront = '',
//     this.dlBack = '',
//     this.companyBondDocument = '',
//     this.status = '',
//     this.rejectionReason = '',
//     this.reviewedAt = '',
//     this.company,
//   });

//   factory TruckOwnerSelfDriverData.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final rawCompany = json['company'];

//     return TruckOwnerSelfDriverData(
//       selfDriverId: _parseInt(json['self_driver_id']),
//       companyId: _parseInt(json['company_id']),
//       companyName: json['company_name']?.toString() ?? '',
//       drivingLicenceNumber:
//           json['driving_licence_number']?.toString() ?? '',
//       dlType: json['dl_type']?.toString() ?? '',
//       dlIssuedDate: json['dl_issued_date']?.toString() ?? '',
//       dlExpiredDate: json['dl_expired_date']?.toString() ?? '',
//       aadhaarCardDocument:
//           json['aadhaar_card_document']?.toString() ?? '',
//       medicalCertificate:
//           json['medical_certificate']?.toString() ?? '',
//       policeVerificationCertificate:
//           json['police_verification_certificate']?.toString() ?? '',
//       photo: json['photo']?.toString() ?? '',
//       aadhaarFront: json['aadhaar_front']?.toString() ?? '',
//       aadhaarBack: json['aadhaar_back']?.toString() ?? '',
//       dlFront: json['dl_front']?.toString() ?? '',
//       dlBack: json['dl_back']?.toString() ?? '',
//       companyBondDocument:
//           json['company_bond_document']?.toString() ?? '',
//       status: json['status']?.toString() ?? '',
//       rejectionReason:
//           json['rejection_reason']?.toString() ?? '',
//       reviewedAt: json['reviewed_at']?.toString() ?? '',
//       company: rawCompany is Map
//           ? Map<String, dynamic>.from(rawCompany)
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'self_driver_id': selfDriverId,
//       'company_id': companyId,
//       'company_name': companyName,
//       'driving_licence_number': drivingLicenceNumber,
//       'dl_type': dlType,
//       'dl_issued_date': dlIssuedDate,
//       'dl_expired_date': dlExpiredDate,
//       'aadhaar_card_document': aadhaarCardDocument,
//       'medical_certificate': medicalCertificate,
//       'police_verification_certificate':
//           policeVerificationCertificate,
//       'photo': photo,
//       'aadhaar_front': aadhaarFront,
//       'aadhaar_back': aadhaarBack,
//       'dl_front': dlFront,
//       'dl_back': dlBack,
//       'company_bond_document': companyBondDocument,
//       'status': status,
//       'rejection_reason': rejectionReason,
//       'reviewed_at': reviewedAt,
//       'company': company,
//     };
//   }

//   static int? _parseInt(dynamic value) {
//     if (value is int) return value;
//     return int.tryParse(value?.toString() ?? '');
//   }
// }




class TruckOwnerRegistrationModel {
  final bool success;
  final String message;
  final TruckOwnerRegistrationData? data;

  TruckOwnerRegistrationModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory TruckOwnerRegistrationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return TruckOwnerRegistrationModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is Map
          ? TruckOwnerRegistrationData.fromJson(
              Map<String, dynamic>.from(rawData),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class TruckOwnerRegistrationData {
  final int? ownerId;
  final String name;
  final String mobileNumber;
  final String dateOfBirth;
  final String gender;
  final String permanentAddress;
  final String currentAddress;
  final String aadhaarCardDocument;
  final String panCardDocument;
  final bool isSelfDriver;
  final String status;
  final String rejectionReason;
  final String reviewedAt;
  final String createdAt;
  final String updatedAt;
  final TruckOwnerSelfDriverData? selfDriver;

  TruckOwnerRegistrationData({
    this.ownerId,
    required this.name,
    required this.mobileNumber,
    this.dateOfBirth = '',
    this.gender = '',
    this.permanentAddress = '',
    this.currentAddress = '',
    this.aadhaarCardDocument = '',
    this.panCardDocument = '',
    required this.isSelfDriver,
    required this.status,
    this.rejectionReason = '',
    this.reviewedAt = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.selfDriver,
  });

  factory TruckOwnerRegistrationData.fromJson(
    Map<String, dynamic> json,
  ) {
    // Backend sends the nested Self Driver record as `driver_registration`.
    // Keep `self_driver` as a fallback for older API responses.
    final rawSelfDriver =
        json['driver_registration'] ?? json['self_driver'];

    return TruckOwnerRegistrationData(
      ownerId: _parseInt(json['owner_id']),
      name: json['name']?.toString() ?? '',
      mobileNumber: json['mobile_number']?.toString() ?? '',
      dateOfBirth: json['date_of_birth']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      permanentAddress:
          json['permanent_address']?.toString() ?? '',
      currentAddress:
          json['current_address']?.toString() ?? '',
      aadhaarCardDocument:
          json['aadhaar_card_document']?.toString() ?? '',
      panCardDocument:
          json['pan_card_document']?.toString() ?? '',
      isSelfDriver: json['is_self_driver'] == true,
      status: json['status']?.toString() ?? '',
      rejectionReason:
          json['rejection_reason']?.toString() ?? '',
      reviewedAt: json['reviewed_at']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      selfDriver: rawSelfDriver is Map
          ? TruckOwnerSelfDriverData.fromJson(
              Map<String, dynamic>.from(rawSelfDriver),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'name': name,
      'mobile_number': mobileNumber,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'permanent_address': permanentAddress,
      'current_address': currentAddress,
      'aadhaar_card_document': aadhaarCardDocument,
      'pan_card_document': panCardDocument,
      'is_self_driver': isSelfDriver,
      'status': status,
      'rejection_reason': rejectionReason,
      'reviewed_at': reviewedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'self_driver': selfDriver?.toJson(),
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

class TruckOwnerSelfDriverData {
  final int? selfDriverId;
  final int? companyId;
  final String companyName;
  final String drivingLicenceNumber;
  final String dlType;
  final String dlIssuedDate;
  final String dlExpiredDate;
  final String aadhaarCardDocument;
  final String medicalCertificate;
  final String policeVerificationCertificate;
  final String photo;
  final String aadhaarFront;
  final String aadhaarBack;
  final String dlFront;
  final String dlBack;
  final String companyBondDocument;
  final String status;
  final String rejectionReason;
  final String reviewedAt;
  final Map<String, dynamic>? company;

  TruckOwnerSelfDriverData({
    this.selfDriverId,
    this.companyId,
    required this.companyName,
    required this.drivingLicenceNumber,
    this.dlType = '',
    this.dlIssuedDate = '',
    this.dlExpiredDate = '',
    this.aadhaarCardDocument = '',
    this.medicalCertificate = '',
    this.policeVerificationCertificate = '',
    this.photo = '',
    this.aadhaarFront = '',
    this.aadhaarBack = '',
    this.dlFront = '',
    this.dlBack = '',
    this.companyBondDocument = '',
    this.status = '',
    this.rejectionReason = '',
    this.reviewedAt = '',
    this.company,
  });

  factory TruckOwnerSelfDriverData.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawCompany = json['company'];

    return TruckOwnerSelfDriverData(
      // The nested record is a Driver registration, so its identifier is
      // returned as `driver_id` by the backend.
      selfDriverId: _parseInt(
        json['driver_id'] ?? json['self_driver_id'],
      ),
      companyId: _parseInt(
        json['company_id'] ??
            (rawCompany is Map ? rawCompany['company_id'] : null),
      ),
      companyName: (
        json['company_name'] ??
        (rawCompany is Map ? rawCompany['company_name'] : null) ??
        ''
      ).toString(),
      drivingLicenceNumber:
          json['driving_licence_number']?.toString() ?? '',
      dlType: json['dl_type']?.toString() ?? '',
      dlIssuedDate: json['dl_issued_date']?.toString() ?? '',
      dlExpiredDate: json['dl_expired_date']?.toString() ?? '',
      aadhaarCardDocument:
          json['aadhaar_card_document']?.toString() ?? '',
      medicalCertificate:
          json['medical_certificate']?.toString() ?? '',
      policeVerificationCertificate:
          json['police_verification_certificate']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      aadhaarFront: json['aadhaar_front']?.toString() ?? '',
      aadhaarBack: json['aadhaar_back']?.toString() ?? '',
      dlFront: json['dl_front']?.toString() ?? '',
      dlBack: json['dl_back']?.toString() ?? '',
      companyBondDocument:
          json['company_bond_document']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      rejectionReason:
          json['rejection_reason']?.toString() ?? '',
      reviewedAt: json['reviewed_at']?.toString() ?? '',
      company: rawCompany is Map
          ? Map<String, dynamic>.from(rawCompany)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self_driver_id': selfDriverId,
      'company_id': companyId,
      'company_name': companyName,
      'driving_licence_number': drivingLicenceNumber,
      'dl_type': dlType,
      'dl_issued_date': dlIssuedDate,
      'dl_expired_date': dlExpiredDate,
      'aadhaar_card_document': aadhaarCardDocument,
      'medical_certificate': medicalCertificate,
      'police_verification_certificate':
          policeVerificationCertificate,
      'photo': photo,
      'aadhaar_front': aadhaarFront,
      'aadhaar_back': aadhaarBack,
      'dl_front': dlFront,
      'dl_back': dlBack,
      'company_bond_document': companyBondDocument,
      'status': status,
      'rejection_reason': rejectionReason,
      'reviewed_at': reviewedAt,
      'company': company,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}

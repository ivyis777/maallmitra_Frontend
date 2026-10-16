
// class DriverDetailsModel {
//   final bool success;
//   final String message;
//   final DriverDetails data;

//   DriverDetailsModel({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory DriverDetailsModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     final rawData = json['data'];

//     return DriverDetailsModel(
//       success: json['success'] == true,
//       message: json['message']?.toString() ?? '',
//       data: DriverDetails.fromJson(
//         rawData is Map
//             ? Map<String, dynamic>.from(rawData)
//             : <String, dynamic>{},
//       ),
//     );
//   }
// }

// class DriverDetails {
//   final int id;

//   // Company information
//   final String companyType;
//   final String companyName;
//   final String companyId;
//   final String companyUniqueId;
//   final String gstNumber;
//   final String companyEmail;
//   final String companyPhoneNumber;
//   final String companyPersonNumber;
//   final String companyAddress;
//   final String companyCity;
//   final String companyState;
//   final String companyPincode;
//   final String companyCountry;
//   final String companyDocumentType;
//   final String companyDocument;
//   final String companyOtherDocument;
//   final String companyBondDocument;

//   // Driver information
//   final String name;
//   final int age;
//   final String gender;
//   final String mobileNumber;
//   final String aadhaarNumber;
//   final String drivingLicenceNumber;
//   final String dlType;
//   final String dlIssuedDate;
//   final String dlExpiredDate;
//   final String permanentAddress;
//   final String currentAddress;

//   // Driver documents
//   final String medicalCertificate;
//   final String policeVerificationCertificate;
//   final String photo;
//   final String aadhaarFront;
//   final String aadhaarBack;
//   final String dlFront;
//   final String dlBack;

//   // Registration status
//   final String status;
//   final String? rejectionReason;
//   final String? reviewedAt;
//   final String createdAt;
//   final String updatedAt;

//   DriverDetails({
//     required this.id,
//     required this.companyType,
//     required this.companyName,
//     required this.companyId,
//     required this.companyUniqueId,
//     required this.gstNumber,
//     required this.companyEmail,
//     required this.companyPhoneNumber,
//     required this.companyPersonNumber,
//     required this.companyAddress,
//     required this.companyCity,
//     required this.companyState,
//     required this.companyPincode,
//     required this.companyCountry,
//     required this.companyDocumentType,
//     required this.companyDocument,
//     required this.companyOtherDocument,
//     required this.companyBondDocument,
//     required this.name,
//     required this.age,
//     required this.gender,
//     required this.mobileNumber,
//     required this.aadhaarNumber,
//     required this.drivingLicenceNumber,
//     required this.dlType,
//     required this.dlIssuedDate,
//     required this.dlExpiredDate,
//     required this.permanentAddress,
//     required this.currentAddress,
//     required this.medicalCertificate,
//     required this.policeVerificationCertificate,
//     required this.photo,
//     required this.aadhaarFront,
//     required this.aadhaarBack,
//     required this.dlFront,
//     required this.dlBack,
//     required this.status,
//     required this.rejectionReason,
//     required this.reviewedAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory DriverDetails.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     // Some APIs return company information nested under "company".
//     // Others return the fields directly in "data".
//     final rawCompany = json['company'];
//     final company = rawCompany is Map
//         ? Map<String, dynamic>.from(rawCompany)
//         : <String, dynamic>{};

//     String companyValue(String key, [String? fallbackKey]) {
//       final value = company[key] ?? json[key];

//       if (value != null && value.toString().isNotEmpty) {
//         return value.toString();
//       }

//       if (fallbackKey != null) {
//         return _str(json[fallbackKey]);
//       }

//       return '';
//     }

//     return DriverDetails(
//       id: _toInt(json['id'] ?? json['registration_id']),

//       companyType: _str(json['company_type']),
//       companyName: companyValue('company_name'),
//       companyId: companyValue('company_id'),
//       companyUniqueId: companyValue('company_uniqueid'),
//       gstNumber: companyValue('gst_number'),
//       companyEmail: companyValue('company_email', 'email'),
//       companyPhoneNumber:
//           companyValue('company_phone_number', 'phone_number'),
//       companyPersonNumber: companyValue('company_person_number'),
//       companyAddress: companyValue('company_address', 'address'),
//       companyCity: companyValue('company_city', 'city'),
//       companyState: companyValue('company_state', 'state'),
//       companyPincode: companyValue('company_pincode', 'pincode'),
//       companyCountry: companyValue('company_country', 'country'),
//       companyDocumentType: companyValue('company_document_type'),
//       companyDocument: companyValue('company_document'),
//       companyOtherDocument: companyValue('company_other_document'),
//       companyBondDocument: companyValue('company_bond_document'),

//       name: _str(json['name']),
//       age: _toInt(json['age']),
//       gender: _str(json['gender']),
//       mobileNumber: _str(json['mobile_number']),
//       aadhaarNumber: _str(json['aadhaar_number']),
//       drivingLicenceNumber:
//           _str(json['driving_licence_number']),
//       dlType: _str(json['dl_type']),
//       dlIssuedDate: _str(json['dl_issued_date']),
//       dlExpiredDate: _str(json['dl_expired_date']),
//       permanentAddress: _str(json['permanent_address']),
//       currentAddress: _str(json['current_address']),

//       medicalCertificate: _str(json['medical_certificate']),
//       policeVerificationCertificate:
//           _str(json['police_verification_certificate']),
//       photo: _str(json['photo']),
//       aadhaarFront: _str(json['aadhaar_front']),
//       aadhaarBack: _str(json['aadhaar_back']),
//       dlFront: _str(json['dl_front']),
//       dlBack: _str(json['dl_back']),

//       status: _str(json['status']),
//       rejectionReason: _nullableStr(json['rejection_reason']),
//       reviewedAt: _nullableStr(json['reviewed_at']),
//       createdAt: _str(json['created_at']),
//       updatedAt: _str(json['updated_at']),
//     );
//   }

//   static String _str(dynamic value) =>
//       value?.toString() ?? '';

//   static String? _nullableStr(dynamic value) =>
//       value == null ? null : value.toString();

//   static int _toInt(dynamic value) {
//     if (value is num) return value.toInt();
//     return int.tryParse(value?.toString() ?? '') ?? 0;
//   }
// }


class DriverDetailsModel {
  final bool success;
  final String message;
  final DriverDetails data;

  DriverDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DriverDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return DriverDetailsModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: DriverDetails.fromJson(
        rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{},
      ),
    );
  }
}

class DriverDetails {
  final int id;

  // Company information
  final String companyType;
  final String companyName;
  final String companyId;
  final String companyUniqueId;
  final String gstNumber;
  final String companyEmail;
  final String companyPhoneNumber;
  final String companyPersonNumber;
  final String companyAddress;
  final String companyCity;
  final String companyState;
  final String companyPincode;
  final String companyCountry;
  final String companyDocumentType;
  final String companyDocument;
  final String companyOtherDocument;
  final String companyBondDocument;

  // Driver information
  final String name;
  final int age;
  final String gender;
  final String mobileNumber;
  final String aadhaarNumber;
  final String drivingLicenceNumber;
  final String dlType;
  final String dlIssuedDate;
  final String dlExpiredDate;
  final String permanentAddress;
  final String currentAddress;

  // Driver documents
  final String medicalCertificate;
  final String policeVerificationCertificate;
  final String photo;
  final String aadhaarFront;
  final String aadhaarBack;
  final String dlFront;
  final String dlBack;

  // Registration status
  final String status;
  final String? rejectionReason;
  final String? reviewedAt;
  final String createdAt;
  final String updatedAt;

  DriverDetails({
    required this.id,
    required this.companyType,
    required this.companyName,
    required this.companyId,
    required this.companyUniqueId,
    required this.gstNumber,
    required this.companyEmail,
    required this.companyPhoneNumber,
    required this.companyPersonNumber,
    required this.companyAddress,
    required this.companyCity,
    required this.companyState,
    required this.companyPincode,
    required this.companyCountry,
    required this.companyDocumentType,
    required this.companyDocument,
    required this.companyOtherDocument,
    required this.companyBondDocument,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.aadhaarNumber,
    required this.drivingLicenceNumber,
    required this.dlType,
    required this.dlIssuedDate,
    required this.dlExpiredDate,
    required this.permanentAddress,
    required this.currentAddress,
    required this.medicalCertificate,
    required this.policeVerificationCertificate,
    required this.photo,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.dlFront,
    required this.dlBack,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // factory DriverDetails.fromJson(
  //   Map<String, dynamic> json,
  // ) {
  //   // Some APIs return company information nested under "company".
  //   // Others return the fields directly in "data".
  //   final rawCompany = json['company'];
  //   final company = rawCompany is Map
  //       ? Map<String, dynamic>.from(rawCompany)
  //       : <String, dynamic>{};

  //   String companyValue(String key, [String? fallbackKey]) {
  //     final value = company[key] ?? json[key];

  //     if (value != null && value.toString().isNotEmpty) {
  //       return value.toString();
  //     }

  //     if (fallbackKey != null) {
  //       return _str(json[fallbackKey]);
  //     }

  //     return '';
  //   }

  //   return DriverDetails(
  //     id: _toInt(json['id'] ?? json['registration_id']),

  //     companyType: _str(json['company_type']),
  //     companyName: companyValue('company_name'),
  //     companyId: companyValue('company_id'),
  //     companyUniqueId: companyValue('company_uniqueid'),
  //     gstNumber: companyValue('gst_number'),
  //     companyEmail: companyValue('company_email', 'email'),
  //     companyPhoneNumber:
  //         companyValue('company_phone_number', 'phone_number'),
  //     companyPersonNumber: companyValue('company_person_number'),
  //     companyAddress: companyValue('company_address', 'address'),
  //     companyCity: companyValue('company_city', 'city'),
  //     companyState: companyValue('company_state', 'state'),
  //     companyPincode: companyValue('company_pincode', 'pincode'),
  //     companyCountry: companyValue('company_country', 'country'),
  //     companyDocumentType: companyValue('company_document_type'),
  //     companyDocument: companyValue('company_document'),
  //     companyOtherDocument: companyValue('company_other_document'),
  //     companyBondDocument: companyValue('company_bond_document'),

  //     name: _str(json['name']),
  //     age: _toInt(json['age']),
  //     gender: _str(json['gender']),
  //     mobileNumber: _str(json['mobile_number']),
  //     aadhaarNumber: _str(json['aadhaar_number']),
  //     drivingLicenceNumber:
  //         _str(json['driving_licence_number']),
  //     dlType: _str(json['dl_type']),
  //     dlIssuedDate: _str(json['dl_issued_date']),
  //     dlExpiredDate: _str(json['dl_expired_date']),
  //     permanentAddress: _str(json['permanent_address']),
  //     currentAddress: _str(json['current_address']),

  //     medicalCertificate: _str(json['medical_certificate']),
  //     policeVerificationCertificate:
  //         _str(json['police_verification_certificate']),
  //     photo: _str(json['photo']),
  //     aadhaarFront: _str(json['aadhaar_front']),
  //     aadhaarBack: _str(json['aadhaar_back']),
  //     dlFront: _str(json['dl_front']),
  //     dlBack: _str(json['dl_back']),

  //     status: _str(json['status']),
  //     rejectionReason: _nullableStr(json['rejection_reason']),
  //     reviewedAt: _nullableStr(json['reviewed_at']),
  //     createdAt: _str(json['created_at']),
  //     updatedAt: _str(json['updated_at']),
  //   );
  // }

factory DriverDetails.fromJson(
  Map<String, dynamic> json,
) {
  // Your API returns company data under "company_details".
  // Support "company" too, for compatibility.
  final rawCompany =
      json['company_details'] ?? json['company'];

  final company = rawCompany is Map
      ? Map<String, dynamic>.from(rawCompany)
      : <String, dynamic>{};

  String companyValue(
    String key, [
    String? fallbackKey,
  ]) {
    final value = company[key] ?? json[key];

    if (value != null && value.toString().isNotEmpty) {
      return value.toString();
    }

    if (fallbackKey != null) {
      final fallback = json[fallbackKey];

      if (fallback != null && fallback.toString().isNotEmpty) {
        return fallback.toString();
      }
    }

    return '';
  }

  return DriverDetails(
    id: _toInt(json['id'] ?? json['registration_id']),

    companyType: _str(json['company_type']),
    companyName: companyValue('company_name'),
    companyId: companyValue('company_id'),
    companyUniqueId: companyValue('company_uniqueid'),
    gstNumber: companyValue('gst_number'),
    companyEmail: companyValue('email', 'company_email'),
    companyPhoneNumber:
        companyValue('phone_number', 'company_phone_number'),
    companyPersonNumber:
        companyValue('company_person_number'),
    companyAddress: companyValue('address', 'company_address'),
    companyCity: companyValue('city', 'company_city'),
    companyState: companyValue('state', 'company_state'),
    companyPincode: companyValue('pincode', 'company_pincode'),
    companyCountry: companyValue('country', 'company_country'),
    companyDocumentType:
        companyValue('document_type', 'company_document_type'),
    companyDocument: companyValue('document', 'company_document'),
    companyOtherDocument:
        companyValue('other_document', 'company_other_document'),
    companyBondDocument: _str(json['company_bond_document']),

    name: _str(json['name']),
    age: _toInt(json['age']),
    gender: _str(json['gender']),
    mobileNumber: _str(json['mobile_number']),
    aadhaarNumber: _str(json['aadhaar_number']),
    drivingLicenceNumber: _str(json['driving_licence_number']),
    dlType: _str(json['dl_type']),
    dlIssuedDate: _str(json['dl_issued_date']),
    dlExpiredDate: _str(json['dl_expired_date']),
    permanentAddress: _str(json['permanent_address']),
    currentAddress: _str(json['current_address']),

    medicalCertificate: _str(json['medical_certificate']),
    policeVerificationCertificate:
        _str(json['police_verification_certificate']),
    photo: _str(json['photo']),
    aadhaarFront: _str(json['aadhaar_front']),
    aadhaarBack: _str(json['aadhaar_back']),
    dlFront: _str(json['dl_front']),
    dlBack: _str(json['dl_back']),

    status: _str(json['status']),
    rejectionReason: _nullableStr(json['rejection_reason']),
    reviewedAt: _nullableStr(json['reviewed_at']),
    createdAt: _str(json['created_at']),
    updatedAt: _str(json['updated_at']),
  );
}


  static String _str(dynamic value) =>
      value?.toString() ?? '';

  static String? _nullableStr(dynamic value) =>
      value == null ? null : value.toString();

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}


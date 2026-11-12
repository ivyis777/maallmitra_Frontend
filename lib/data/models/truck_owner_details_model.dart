
class TruckOwnerDetailsModel {
  final bool success;
  final String message;
  final TruckOwnerDetails data;

  TruckOwnerDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });
  factory TruckOwnerDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return TruckOwnerDetailsModel(
      success: json['success'] == true,
      message: _str(json['message']),
      data: TruckOwnerDetails.fromJson(
        rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{},
      ),
    );
  }
}

class TruckOwnerDetails {
  final int ownerId;
  final String name;
  final String mobileNumber;
  final String dateOfBirth;
  final String gender;
  final String permanentAddress;
  final String currentAddress;
  final String panCardDocument;
  final bool isSelfDriver;
  final String status;
  final String? rejectionReason;
  final String? reviewedAt;
  final String createdAt;
  final String updatedAt;
  final TruckOwnerSelfDriver? selfDriver;

  TruckOwnerDetails({
    required this.ownerId,
    required this.name,
    required this.mobileNumber,
    required this.dateOfBirth,
    required this.gender,
    required this.permanentAddress,
    required this.currentAddress,
    required this.panCardDocument,
    required this.isSelfDriver,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.selfDriver,
  });

  factory TruckOwnerDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawDriver = json['self_driver'];

    return TruckOwnerDetails(
      ownerId: _int(json['owner_id']),
      name: _str(json['name']),
      mobileNumber: _str(json['mobile_number']),
      dateOfBirth: _str(json['date_of_birth']),
      gender: _str(json['gender']),
      permanentAddress: _str(json['permanent_address']),
      currentAddress: _str(json['current_address']),
      panCardDocument: _str(json['pan_card_document']),
      isSelfDriver: json['is_self_driver'] == true,
      status: _str(json['status']),
      rejectionReason: _nullableStr(json['rejection_reason']),
      reviewedAt: _nullableStr(json['reviewed_at']),
      createdAt: _str(json['created_at']),
      updatedAt: _str(json['updated_at']),
      selfDriver: rawDriver is Map
          ? TruckOwnerSelfDriver.fromJson(
              Map<String, dynamic>.from(rawDriver),
            )
          : null,
    );
  }
}

class TruckOwnerSelfDriver {
  final int selfDriverId;
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
  final String? rejectionReason;
  final String? reviewedAt;
  final TruckOwnerCompany? company;

  TruckOwnerSelfDriver({
    required this.selfDriverId,
    required this.drivingLicenceNumber,
    required this.dlType,
    required this.dlIssuedDate,
    required this.dlExpiredDate,
    required this.aadhaarCardDocument,
    required this.medicalCertificate,
    required this.policeVerificationCertificate,
    required this.photo,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.dlFront,
    required this.dlBack,
    required this.companyBondDocument,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAt,
    required this.company,
  });

  factory TruckOwnerSelfDriver.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawCompany = json['company'];

    return TruckOwnerSelfDriver(
      selfDriverId: _int(json['self_driver_id']),
      drivingLicenceNumber:
          _str(json['driving_licence_number']),
      dlType: _str(json['dl_type']),
      dlIssuedDate: _str(json['dl_issued_date']),
      dlExpiredDate: _str(json['dl_expired_date']),
      aadhaarCardDocument:
          _str(json['aadhaar_card_document']),
      medicalCertificate: _str(json['medical_certificate']),
      policeVerificationCertificate:
          _str(json['police_verification_certificate']),
      photo: _str(json['photo']),
      aadhaarFront: _str(json['aadhaar_front']),
      aadhaarBack: _str(json['aadhaar_back']),
      dlFront: _str(json['dl_front']),
      dlBack: _str(json['dl_back']),
      companyBondDocument:
          _str(json['company_bond_document']),
      status: _str(json['status']),
      rejectionReason: _nullableStr(json['rejection_reason']),
      reviewedAt: _nullableStr(json['reviewed_at']),
      company: rawCompany is Map
          ? TruckOwnerCompany.fromJson(
              Map<String, dynamic>.from(rawCompany),
            )
          : null,
    );
  }
}

class TruckOwnerCompany {
  final int companyId;
  final String companyName;
  final String status;

  TruckOwnerCompany({
    required this.companyId,
    required this.companyName,
    required this.status,
  });

  factory TruckOwnerCompany.fromJson(
    Map<String, dynamic> json,
  ) {
    return TruckOwnerCompany(
      companyId: _int(json['company_id']),
      companyName: _str(json['company_name']),
      status: _str(json['status']),
    );
  }
}

String _str(dynamic value) => value?.toString() ?? '';

String? _nullableStr(dynamic value) =>
    value == null ? null : value.toString();

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

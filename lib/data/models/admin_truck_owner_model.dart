
class AdminTruckOwnerModel {
  final bool success;
  final String message;
  final TruckOwnerSummary summary;
  final List<AdminTruckOwner> pending;
  final List<AdminTruckOwner> approved;
  final List<AdminTruckOwner> rejected;

  AdminTruckOwnerModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory AdminTruckOwnerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final owners = _asMap(json['truck_owners']);

    return AdminTruckOwnerModel(
      success: json['success'] == true,
      message: _str(json['message']),
      summary: TruckOwnerSummary.fromJson(
        _asMap(owners['summary']),
      ),
      pending: _parseList(owners['pending']),
      approved: _parseList(owners['approved']),
      rejected: _parseList(owners['rejected']),
    );
  }

  static List<AdminTruckOwner> _parseList(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => AdminTruckOwner.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }
}

class TruckOwnerSummary {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  TruckOwnerSummary({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory TruckOwnerSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return TruckOwnerSummary(
      total: _int(json['total']),
      pending: _int(json['pending']),
      approved: _int(json['approved']),
      rejected: _int(json['rejected']),
    );
  }
}

class AdminTruckOwner {
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
  final SelfDriverSummary? selfDriver;

  AdminTruckOwner({
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

  factory AdminTruckOwner.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawDriver = json['self_driver'];

    return AdminTruckOwner(
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
          ? SelfDriverSummary.fromJson(
              Map<String, dynamic>.from(rawDriver),
            )
          : null,
    );
  }
}

class SelfDriverSummary {
  final int selfDriverId;
  final String drivingLicenceNumber;
  final String dlType;
  final String status;
  final String companyName;

  SelfDriverSummary({
    required this.selfDriverId,
    required this.drivingLicenceNumber,
    required this.dlType,
    required this.status,
    required this.companyName,
  });

  factory SelfDriverSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    final company = _asMap(json['company']);

    return SelfDriverSummary(
      selfDriverId: _int(json['self_driver_id']),
      drivingLicenceNumber:
          _str(json['driving_licence_number']),
      dlType: _str(json['dl_type']),
      status: _str(json['status']),
      companyName: _str(company['company_name']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return <String, dynamic>{};
}

String _str(dynamic value) => value?.toString() ?? '';

String? _nullableStr(dynamic value) =>
    value == null ? null : value.toString();

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

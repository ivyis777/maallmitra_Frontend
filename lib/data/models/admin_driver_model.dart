
class AdminDriverModel {
  final bool success;
  final String message;
  final DriverSummary summary;
  final List<AdminDriver> pending;
  final List<AdminDriver> approved;
  final List<AdminDriver> rejected;

  AdminDriverModel({
    required this.success,
    required this.message,
    required this.summary,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory AdminDriverModel.fromJson(Map<String, dynamic> json) {
    return AdminDriverModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      summary: DriverSummary.fromJson(
        _asMap(json['summary']),
      ),
      pending: _parseDrivers(json['pending']),
      approved: _parseDrivers(json['approved']),
      rejected: _parseDrivers(json['rejected']),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  static List<AdminDriver> _parseDrivers(dynamic value) {
    if (value is! List) return <AdminDriver>[];

    return value
        .whereType<Map>()
        .map(
          (item) => AdminDriver.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

class DriverSummary {
  final int total;
  final int pending;
  final int approved;
  final int rejected;

  DriverSummary({
    required this.total,
    required this.pending,
    required this.approved,
    required this.rejected,
  });

  factory DriverSummary.fromJson(Map<String, dynamic> json) {
    return DriverSummary(
      total: _toInt(json['total']),
      pending: _toInt(json['pending']),
      approved: _toInt(json['approved']),
      rejected: _toInt(json['rejected']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class AdminDriver {
  final int id;
  final String name;
  final int age;
  final String gender;
  final String mobileNumber;
  final String companyType;
  final String companyName;
  final String drivingLicenceNumber;
  final String dlType;
  final String status;
  final String createdAt;

  AdminDriver({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.companyType,
    required this.companyName,
    required this.drivingLicenceNumber,
    required this.dlType,
    required this.status,
    required this.createdAt,
  });

  factory AdminDriver.fromJson(Map<String, dynamic> json) {
    return AdminDriver(
      id: _toInt(json['id']),
      name: _toString(json['name']),
      age: _toInt(json['age']),
      gender: _toString(json['gender']),
      mobileNumber: _toString(json['mobile_number']),
      companyType: _toString(json['company_type']),
      companyName: _toString(json['company_name']),
      drivingLicenceNumber:
          _toString(json['driving_licence_number']),
      dlType: _toString(json['dl_type']),
      status: _toString(json['status']),
      createdAt: _toString(json['created_at']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _toString(dynamic value) {
    return value?.toString() ?? '';
  }
}

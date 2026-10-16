
// class CompanyModel {
//   final bool success;
//   final String message;
//   final int companyId;
//   final String company_Id;
//   final String company_uniqueid;
//   final String companyName;
//   final String gstNumber;
//   final String email;
//   final String phoneNumber;
//   final String companyPersonNumber;
//   final String address;
//   final String city;
//   final String state;
//   final String pincode;
//   final String country;
//   final String documentType;
//   final String document;
//   final String createdAt;
//   final String updatedAt;

//   CompanyModel({
//     this.success = true,
//     this.message = '',
//     required this.companyId,
//     required this.company_Id,
//     required this.company_uniqueid,
//     required this.companyName,
//     required this.gstNumber,
//     required this.email,
//     required this.phoneNumber,
//     required this.companyPersonNumber,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.country,
//     required this.documentType,
//     required this.document,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory CompanyModel.fromJson(
//     Map<String, dynamic> json,
//   ) {
//     // Supports both a complete API response and a single
//     // company object from the list's data array.
//     final dynamic nestedData = json['data'];

//     final Map<String, dynamic> data =
//         nestedData is Map<String, dynamic>
//             ? nestedData
//             : json;

//     return CompanyModel(
//       success: json['success'] as bool? ?? true,
//       message: json['message']?.toString() ?? '',
//       companyId: _toInt(data['company_id']),
//       company_Id: data['company_id']?.toString() ?? '',
//       company_uniqueid:
//           data['company_uniqueid']?.toString() ?? '',
//       companyName: data['company_name']?.toString() ?? '',
//       gstNumber: data['gst_number']?.toString() ?? '',
//       email: data['email']?.toString() ?? '',
//       phoneNumber: data['phone_number']?.toString() ?? '',
//       companyPersonNumber:
//           data['company_person_number']?.toString() ?? '',
//       address: data['address']?.toString() ?? '',
//       city: data['city']?.toString() ?? '',
//       state: data['state']?.toString() ?? '',
//       pincode: data['pincode']?.toString() ?? '',
//       country: data['country']?.toString() ?? '',
//       documentType:
//           data['document_type']?.toString() ?? '',
//       document: data['document']?.toString() ?? '',
//       createdAt: data['created_at']?.toString() ?? '',
//       updatedAt: data['updated_at']?.toString() ?? '',
//     );
//   }

//   static int _toInt(dynamic value) {
//     if (value is int) return value;
//     return int.tryParse(value?.toString() ?? '') ?? 0;
//   }
// }



class CompanyModel {
  final bool success;
  final String message;
  final int companyId;
  final String company_Id;
  final String company_uniqueid;
  final String companyName;
  final String gstNumber;
  final String email;
  final String phoneNumber;
  final String companyPersonNumber;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final String documentType;
  final String document;
  final String createdAt;
  final String updatedAt;

  CompanyModel({
    this.success = true,
    this.message = '',
    required this.companyId,
    required this.company_Id,
    required this.company_uniqueid,
    required this.companyName,
    required this.gstNumber,
    required this.email,
    required this.phoneNumber,
    required this.companyPersonNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.documentType,
    required this.document,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    final dynamic nestedData = json['data'];
    final Map<String, dynamic> data = nestedData is Map
        ? Map<String, dynamic>.from(nestedData)
        : json;

    return CompanyModel(
      success: json['success'] as bool? ?? true,
      message: json['message']?.toString() ?? '',
      companyId: _toInt(data['company_id']),
      company_Id: data['company_id']?.toString() ?? '',
      company_uniqueid: data['company_uniqueid']?.toString() ?? '',
      companyName: data['company_name']?.toString() ?? '',
      gstNumber: data['gst_number']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      phoneNumber: data['phone_number']?.toString() ?? '',
      companyPersonNumber: data['company_person_number']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      city: data['city']?.toString() ?? '',
      state: data['state']?.toString() ?? '',
      pincode: data['pincode']?.toString() ?? '',
      country: data['country']?.toString() ?? '',
      documentType: data['document_type']?.toString() ?? '',
      document: data['document']?.toString() ?? '',
      createdAt: data['created_at']?.toString() ?? '',
      updatedAt: data['updated_at']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

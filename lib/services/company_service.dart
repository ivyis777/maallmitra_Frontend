// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../core/constants/app url.dart';
// import '../core/storage/LocalStorageConstants.dart';
// import '../data/models/company_model.dart';

// /// Company APIs used by Truck Owner Registration.
// /// Uses the saved access token for endpoints that require authentication.
// class CompanyService {
//   String get _userApiBase {
//     final rawBase = AppUrl.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
//     return rawBase.endsWith('/user') ? rawBase : '$rawBase/user';
//   }

//   String get _companyListUrl => '$_userApiBase/company/list/';

//   String _companyDetailsUrl(int companyId) =>
//       '$_userApiBase/company/$companyId/';

//   String get _registerCompanyUrl => '$_userApiBase/company/register/';

//   Future<Map<String, String>> _headers({bool json = true}) async {
//     final token = await LocalStorageConstants.getAccessToken();
//     final headers = <String, String>{'Accept': 'application/json'};
//     if (json) headers['Content-Type'] = 'application/json';
//     if (token != null && token.toString().trim().isNotEmpty) {
//       headers['Authorization'] = 'Bearer ${token.toString().trim()}';
//     }
//     return headers;
//   }

//   Map<String, dynamic> _decodeObject(String body, String operation) {
//     final dynamic decoded;
//     try {
//       decoded = jsonDecode(body);
//     } catch (_) {
//       throw Exception('$operation returned invalid JSON.');
//     }
//     if (decoded is! Map) {
//       throw Exception('$operation returned an unexpected response.');
//     }
//     return Map<String, dynamic>.from(decoded);
//   }

//   Future<List<CompanyModel>> fetchCompanies() async {
//     final url = _companyListUrl;
//     final response = await http
//         .get(Uri.parse(url), headers: await _headers())
//         .timeout(const Duration(seconds: 20));

//     final decoded = _decodeObject(response.body, 'Company list API');
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw Exception(
//         decoded['message']?.toString() ??
//             'Company list failed (HTTP ${response.statusCode}).',
//       );
//     }
//     if (decoded['success'] != true || decoded['data'] is! List) {
//       throw Exception(
//         decoded['message']?.toString() ?? 'Invalid company list response.',
//       );
//     }

//     return (decoded['data'] as List)
//         .whereType<Map>()
//         .map((item) => CompanyModel.fromJson(Map<String, dynamic>.from(item)))
//         .toList();
//   }

//   Future<CompanyModel> fetchCompanyDetails(int companyId) async {
//     if (companyId <= 0) {
//       throw Exception('Invalid company ID: $companyId');
//     }

//     final url = _companyDetailsUrl(companyId);
//     final response = await http
//         .get(Uri.parse(url), headers: await _headers())
//         .timeout(const Duration(seconds: 20));

//     final decoded = _decodeObject(response.body, 'Company details API');
//     if (response.statusCode < 200 || response.statusCode >= 300) {
//       throw Exception(
//         decoded['message']?.toString() ??
//             'Company details failed (HTTP ${response.statusCode}).',
//       );
//     }
//     if (decoded['success'] != true || decoded['data'] is! Map) {
//       throw Exception(
//         decoded['message']?.toString() ?? 'Invalid company details response.',
//       );
//     }

//     return CompanyModel.fromJson(decoded);
//   }

//   Future<CompanyModel> addCompany({
//     required String company_id,
//     required String company_uniqueid,
//     required String companyName,
//     required String gstNumber,
//     required String email,
//     required String phoneNumber,
//     required String companyPersonNumber,
//     required String address,
//     required String city,
//     required String state,
//     required String pincode,
//     required String country,
//     required String documentType,
//     required String documentPath,
//   }) async {
//     final request = http.MultipartRequest(
//       'POST',
//       Uri.parse(_registerCompanyUrl),
//     );

//     final headers = await _headers(json: false);
//     request.headers.addAll(headers);
//     request.fields.addAll({
//       'company_id': company_id.trim(),
//       'company_uniqueid': company_uniqueid.trim(),
//       'company_name': companyName.trim(),
//       'gst_number': gstNumber.trim(),
//       'email': email.trim(),
//       'phone_number': phoneNumber.trim(),
//       'company_person_number': companyPersonNumber.trim(),
//       'address': address.trim(),
//       'city': city.trim(),
//       'state': state.trim(),
//       'pincode': pincode.trim(),
//       'country': country.trim(),
//       'document_type': documentType.trim(),
//     });
//     request.files.add(
//       await http.MultipartFile.fromPath('document', documentPath),
//     );

//     final streamed = await request.send().timeout(
//       const Duration(seconds: 30),
//     );
//     final body = await streamed.stream.bytesToString();
//     final decoded = _decodeObject(body, 'Company registration API');

//     if (streamed.statusCode < 200 || streamed.statusCode >= 300 ||
//         decoded['success'] != true) {
//       throw Exception(
//         decoded['message']?.toString() ??
//             'Company registration failed (HTTP ${streamed.statusCode}).',
//       );
//     }

//     return CompanyModel.fromJson(decoded);
//   }
// }



import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/company_model.dart';

/// Company APIs used by Truck Owner Registration.
/// Uses the saved access token for endpoints that require authentication.
class CompanyService {
  String get _userApiBase {
    final rawBase = AppUrl.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    return rawBase.endsWith('/user') ? rawBase : '$rawBase/user';
  }

  String get _companyListUrl => '$_userApiBase/company/list/';

  String _companyDetailsUrl(int companyId) =>
      '$_userApiBase/company/$companyId/';

  String get _registerCompanyUrl => '$_userApiBase/company/register/';

  Future<Map<String, String>> _headers({bool json = true}) async {
    final token = await LocalStorageConstants.getAccessToken();
    final headers = <String, String>{'Accept': 'application/json'};
    if (json) headers['Content-Type'] = 'application/json';
    if (token != null && token.toString().trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.toString().trim()}';
    }
    return headers;
  }

  Map<String, dynamic> _decodeObject(String body, String operation) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      throw Exception('$operation returned invalid JSON.');
    }
    if (decoded is! Map) {
      throw Exception('$operation returned an unexpected response.');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Future<List<CompanyModel>> fetchCompanies() async {
    final url = _companyListUrl;
    final response = await http
        .get(Uri.parse(url), headers: await _headers())
        .timeout(const Duration(seconds: 20));

    final decoded = _decodeObject(response.body, 'Company list API');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'Company list failed (HTTP ${response.statusCode}).',
      );
    }
    if (decoded['success'] != true || decoded['data'] is! List) {
      throw Exception(
        decoded['message']?.toString() ?? 'Invalid company list response.',
      );
    }

    return (decoded['data'] as List)
        .whereType<Map>()
        .map((item) => CompanyModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<CompanyModel> fetchCompanyDetails(int companyId) async {
    if (companyId <= 0) {
      throw Exception('Invalid company ID: $companyId');
    }

    final url = _companyDetailsUrl(companyId);
    final response = await http
        .get(Uri.parse(url), headers: await _headers())
        .timeout(const Duration(seconds: 20));
         debugPrint('COMPANY DETAILS URL: $url');
debugPrint('COMPANY DETAILS STATUS: ${response.statusCode}');
debugPrint(
  'COMPANY DETAILS CONTENT TYPE: ${response.headers['content-type']}',
);
debugPrint('COMPANY DETAILS BODY: ${response.body}');
    final decoded = _decodeObject(response.body, 'Company details API');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'Company details failed (HTTP ${response.statusCode}).',
      );
    }
    if (decoded['success'] != true || decoded['data'] is! Map) {
      throw Exception(
        decoded['message']?.toString() ?? 'Invalid company details response.',
      );
    }

    return CompanyModel.fromJson(decoded);
  }

  /// Raw company data for screens that need the complete backend fields.
  /// Kept in the service so registration screens never make HTTP requests.
  Future<List<Map<String, dynamic>>> fetchCompaniesForRegistration() async {
    final response = await http
        .get(Uri.parse(_companyListUrl), headers: await _headers())
        .timeout(const Duration(seconds: 20));

    final decoded = _decodeObject(response.body, 'Company list API');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'Company list failed (HTTP ${response.statusCode}).',
      );
    }
    if (decoded['success'] != true || decoded['data'] is! List) {
      throw Exception(
        decoded['message']?.toString() ?? 'Invalid company list response.',
      );
    }

    return (decoded['data'] as List)
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Returns the complete company detail map without dropping backend fields.
  // Future<Map<String, dynamic>> fetchCompanyDetailsForRegistration(
  //   int companyId,
  // ) async {
  //   if (companyId <= 0) {
  //     throw Exception('Invalid company ID: $companyId');
  //   }

  //   final response = await http
  //       .get(
  //         Uri.parse(_companyDetailsUrl(companyId)),
  //         headers: await _headers(),
  //       )
  //       .timeout(const Duration(seconds: 20));

  //   final decoded = _decodeObject(response.body, 'Company details API');
  //   if (response.statusCode < 200 || response.statusCode >= 300) {
  //     throw Exception(
  //       decoded['message']?.toString() ??
  //           'Company details failed (HTTP ${response.statusCode}).',
  //     );
  //   }
  //   if (decoded['success'] != true || decoded['data'] is! Map) {
  //     throw Exception(
  //       decoded['message']?.toString() ?? 'Invalid company details response.',
  //     );
  //   }

  //   return Map<String, dynamic>.from(decoded['data'] as Map);
  // }
Future<Map<String, dynamic>> fetchCompanyDetailsForRegistration(
  int companyId,
) async {
  if (companyId <= 0) {
    throw Exception('Invalid company ID: $companyId');
  }

  final url = _companyDetailsUrl(companyId);

  final response = await http
      .get(
        Uri.parse(url),
        headers: await _headers(),
      )
      .timeout(const Duration(seconds: 20));

  // Debug logs for the actual API request
  debugPrint('REGISTRATION COMPANY ID: $companyId');
  debugPrint('REGISTRATION COMPANY URL: $url');
  debugPrint('REGISTRATION COMPANY STATUS: ${response.statusCode}');
  debugPrint(
    'REGISTRATION COMPANY CONTENT TYPE: '
    '${response.headers['content-type']}',
  );
  debugPrint('REGISTRATION COMPANY BODY: ${response.body}');

  final decoded = _decodeObject(
    response.body,
    'Company details API',
  );

  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw Exception(
      decoded['message']?.toString() ??
          'Company details failed (HTTP ${response.statusCode}).',
    );
  }

  if (decoded['success'] != true || decoded['data'] is! Map) {
    throw Exception(
      decoded['message']?.toString() ??
          'Invalid company details response.',
    );
  }

  return Map<String, dynamic>.from(decoded['data'] as Map);
}
  Future<CompanyModel> addCompany({
    required String company_id,
    required String company_uniqueid,
    required String companyName,
    required String gstNumber,
    required String email,
    required String phoneNumber,
    required String companyPersonNumber,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String country,
    required String documentType,
    required String documentPath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(_registerCompanyUrl),
    );

    final headers = await _headers(json: false);
    request.headers.addAll(headers);
    request.fields.addAll({
      'company_id': company_id.trim(),
      'company_uniqueid': company_uniqueid.trim(),
      'company_name': companyName.trim(),
      'gst_number': gstNumber.trim(),
      'email': email.trim(),
      'phone_number': phoneNumber.trim(),
      'company_person_number': companyPersonNumber.trim(),
      'address': address.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),
      'country': country.trim(),
      'document_type': documentType.trim(),
    });
    request.files.add(
      await http.MultipartFile.fromPath('document', documentPath),
    );

    final streamed = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final body = await streamed.stream.bytesToString();
    final decoded = _decodeObject(body, 'Company registration API');

    if (streamed.statusCode < 200 || streamed.statusCode >= 300 ||
        decoded['success'] != true) {
      throw Exception(
        decoded['message']?.toString() ??
            'Company registration failed (HTTP ${streamed.statusCode}).',
      );
    }

    return CompanyModel.fromJson(decoded);
  }
}

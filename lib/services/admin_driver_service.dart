// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// import '../core/constants/app url.dart';
// import '../core/storage/LocalStorageConstants.dart';
// import '../data/models/admin_driver_model.dart';
// import '../data/models/driver_details_model.dart';

// class AdminDriverService {
//   final http.Client _client;

//   AdminDriverService({http.Client? client})
//       : _client = client ?? http.Client();

//   // ============================================================
//   // GET ADMIN ACCESS TOKEN
//   // ============================================================

//   Future<String> _getAccessToken() async {
//     final token =
//         await LocalStorageConstants.getAccessToken();

//     if (token == null || token.isEmpty) {
//       throw Exception(
//         'Access token not found. Please log in again.',
//       );
//     }

//     return token;
//   }

//   // ============================================================
//   // REQUEST HEADERS
//   // ============================================================

//   Future<Map<String, String>> _headers() async {
//     final token = await _getAccessToken();

//     return {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   // ============================================================
//   // API URL
//   // ============================================================

//   Uri _uri(String endpoint) => Uri.parse(endpoint);

//   // ============================================================
//   // HANDLE API RESPONSE
//   // ============================================================

//   Map<String, dynamic> _decodeResponse(
//     http.Response response,
//   ) {
//     dynamic decoded;

//     try {
//       decoded = jsonDecode(response.body);
//     } catch (_) {
//       throw Exception(
//         'Invalid server response (${response.statusCode}).',
//       );
//     }

//     if (decoded is! Map) {
//       throw Exception(
//         'Unexpected server response format.',
//       );
//     }

//     final data = Map<String, dynamic>.from(decoded);

//     if (response.statusCode < 200 ||
//         response.statusCode >= 300 ||
//         data['success'] == false) {
//       throw Exception(
//         data['message']?.toString() ??
//             'Request failed (${response.statusCode}).',
//       );
//     }

//     return data;
//   }

//   // ============================================================
//   // GET: ALL DRIVER REGISTRATIONS
//   // ============================================================

//   Future<AdminDriverModel> fetchDrivers() async {
//     final url = AppUrl.adminDrivers;

//     debugPrint('Fetch drivers URL: $url');

//     final response = await _client.get(
//       _uri(url),
//       headers: await _headers(),
//     );

//     debugPrint(
//       'Fetch drivers status: ${response.statusCode}',
//     );

//     debugPrint(
//       'Fetch drivers response: ${response.body}',
//     );

//     return AdminDriverModel.fromJson(
//       _decodeResponse(response),
//     );
//   }

//   // ============================================================
//   // GET: INDIVIDUAL DRIVER DETAILS
//   // ============================================================

//   Future<DriverDetailsModel> fetchDriverDetails(
//     int registrationId,
//   ) async {
//     final url =
//         '${AppUrl.adminDrivers}$registrationId/';

//     debugPrint('Driver details URL: $url');

//     final response = await _client.get(
//       _uri(url),
//       headers: await _headers(),
//     );

//     debugPrint(
//       'Driver details status: ${response.statusCode}',
//     );

//     debugPrint(
//       'Driver details response: ${response.body}',
//     );

//     return DriverDetailsModel.fromJson(
//       _decodeResponse(response),
//     );
//   }

//   // ============================================================
//   // POST: APPROVE DRIVER
//   // Endpoint configured in AppUrl.Approve
//   // ============================================================

//   Future<Map<String, dynamic>> approveDriver(
//     int registrationId,
//   ) async {
//     final url = AppUrl.Approve;

//     final body = {
//       'registration_type': 'driver',
//       'registration_id': registrationId,
//       'action': 'approve',
//     };

//     debugPrint('========== APPROVE DRIVER ==========');
//     debugPrint('Approve URL: $url');
//     debugPrint('Registration ID: $registrationId');
//     debugPrint('Request body: ${jsonEncode(body)}');

//     final response = await _client.post(
//       _uri(url),
//       headers: await _headers(),
//       body: jsonEncode(body),
//     );

//     debugPrint(
//       'Approve HTTP status: ${response.statusCode}',
//     );

//     debugPrint(
//       'Approve response body: ${response.body}',
//     );

//     debugPrint('====================================');

//     return _decodeResponse(response);
//   }

//   // ============================================================
//   // POST: REJECT DRIVER
//   // Endpoint configured in AppUrl.Reject
//   // ============================================================

//   Future<Map<String, dynamic>> rejectDriver({
//     required int registrationId,
//     required String rejectionReason,
//   }) async {
//     final url = AppUrl.Reject;

//     final body = {
//       'registration_type': 'driver',
//       'registration_id': registrationId,
//       'rejection_reason': rejectionReason,
//     };

//     debugPrint('========== REJECT DRIVER ==========');
//     debugPrint('Reject URL: $url');
//     debugPrint('Registration ID: $registrationId');
//     debugPrint('Request body: ${jsonEncode(body)}');

//     final response = await _client.post(
//       _uri(url),
//       headers: await _headers(),
//       body: jsonEncode(body),
//     );

//     debugPrint(
//       'Reject HTTP status: ${response.statusCode}',
//     );

//     debugPrint(
//       'Reject response body: ${response.body}',
//     );

//     debugPrint('===================================');

//     return _decodeResponse(response);
//   }

//   // ============================================================
//   // DISPOSE HTTP CLIENT
//   // ============================================================

//   void dispose() {
//     _client.close();
//   }
// }



import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/admin_driver_model.dart';
import '../data/models/company_model.dart';
import '../data/models/driver_details_model.dart';

class AdminDriverService {
  final http.Client _client;

  AdminDriverService({http.Client? client})
      : _client = client ?? http.Client();

  // GET ADMIN ACCESS TOKEN
  Future<String> _getAccessToken() async {
    final token = await LocalStorageConstants.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Access token not found. Please log in again.');
    }

    return token;
  }

  // REQUEST HEADERS
  Future<Map<String, String>> _headers() async {
    final token = await _getAccessToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // API URL
  Uri _uri(String endpoint) => Uri.parse(endpoint);

  // HANDLE API RESPONSE
  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Invalid server response (${response.statusCode}).');
    }

    if (decoded is! Map) {
      throw Exception('Unexpected server response format.');
    }

    final data = Map<String, dynamic>.from(decoded);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      throw Exception(
        data['message']?.toString() ??
            'Request failed (${response.statusCode}).',
      );
    }

    return data;
  }

  // GET: ALL DRIVER REGISTRATIONS
  Future<AdminDriverModel> fetchDrivers() async {
    final url = AppUrl.adminDrivers;
    debugPrint('Fetch drivers URL: $url');

    final response = await _client.get(
      _uri(url),
      headers: await _headers(),
    );

    debugPrint('Fetch drivers status: ${response.statusCode}');
    debugPrint('Fetch drivers response: ${response.body}');

    return AdminDriverModel.fromJson(_decodeResponse(response));
  }

  // GET: INDIVIDUAL DRIVER DETAILS
  Future<DriverDetailsModel> fetchDriverDetails(int registrationId) async {
    final url = '${AppUrl.adminDrivers}$registrationId/';
    debugPrint('Driver details URL: $url');

    final response = await _client.get(
      _uri(url),
      headers: await _headers(),
    );

    debugPrint('Driver details status: ${response.statusCode}');
    debugPrint('Driver details response: ${response.body}');

    return DriverDetailsModel.fromJson(_decodeResponse(response));
  }

  // GET: COMPANY DETAILS BY COMPANY ID
  Future<CompanyModel> fetchCompanyDetails(int companyId) async {
    final url = AppUrl.companyDetails(companyId);
    debugPrint('Company details URL: $url');

    final response = await _client.get(
      _uri(url),
      headers: await _headers(),
    );

    debugPrint('Company details status: ${response.statusCode}');
    debugPrint('Company details response: ${response.body}');

    return CompanyModel.fromJson(_decodeResponse(response));
  }

  // POST: APPROVE DRIVER
  Future<Map<String, dynamic>> approveDriver(int registrationId) async {
    final url = AppUrl.Approve;
    final body = {
      'registration_type': 'driver',
      'registration_id': registrationId,
      'action': 'approve',
    };

    debugPrint('========== APPROVE DRIVER ==========');
    debugPrint('Approve URL: $url');
    debugPrint('Registration ID: $registrationId');
    debugPrint('Request body: ${jsonEncode(body)}');

    final response = await _client.post(
      _uri(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('Approve HTTP status: ${response.statusCode}');
    debugPrint('Approve response body: ${response.body}');
    debugPrint('====================================');
    return _decodeResponse(response);
  }
  // POST: REJECT DRIVER
  Future<Map<String, dynamic>> rejectDriver({
    required int registrationId,
    required String rejectionReason,
  }) async {
    final url = AppUrl.Reject;
    final body = {
      'registration_type': 'driver',
      'registration_id': registrationId,
      'rejection_reason': rejectionReason,
    };
    debugPrint('========== REJECT DRIVER ==========');
    debugPrint('Reject URL: $url');
    debugPrint('Registration ID: $registrationId');
    debugPrint('Request body: ${jsonEncode(body)}');
    final response = await _client.post(
      _uri(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    debugPrint('Reject HTTP status: ${response.statusCode}');
    debugPrint('Reject response body: ${response.body}');
    debugPrint('===================================');

    return _decodeResponse(response);
  }
  void dispose() {
    _client.close();
  }
}

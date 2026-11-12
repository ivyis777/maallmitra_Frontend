
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/admin_driver_model.dart';
import '../data/models/driver_details_model.dart';
import '../data/models/company_model.dart';

class AdminDriverService {
  final http.Client _client = http.Client();

  // Get authorization headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await LocalStorageConstants.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Decode API response
  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decodedBody;

    try {
      decodedBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};
    } catch (_) {
      throw Exception(
        'Invalid server response. Status code: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body = decodedBody is Map
        ? Map<String, dynamic>.from(decodedBody)
        : <String, dynamic>{};

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      if (body['success'] == false) {
        throw Exception(
          body['message']?.toString() ?? 'Something went wrong',
        );
      }

      return body;
    }

    throw Exception(
      body['message']?.toString() ??
          body['errors']?.toString() ??
          'Request failed. Status code: ${response.statusCode}',
    );
  }

  // Get all driver registrations
  Future<AdminDriverModel> fetchDrivers() async {
    final response = await _client.get(
      Uri.parse(AppUrl.adminDriverRegistrations),
      headers: await _getHeaders(),
    );

    final data = _decodeResponse(response);

    return AdminDriverModel.fromJson(data);
  }

  // Get individual driver details
  Future<DriverDetailsModel> fetchDriverDetails(
    int driverId,
  ) async {
    final response = await _client.get(
      Uri.parse(AppUrl.adminDriverDetails(driverId)),
      headers: await _getHeaders(),
    );

    final data = _decodeResponse(response);

    return DriverDetailsModel.fromJson(data);
  }

  // Get admin company details
  Future<CompanyModel> fetchCompanyDetails(
    int companyId,
  ) async {
    final response = await _client.get(
      Uri.parse(AppUrl.adminCompanyDetails(companyId)),
      headers: await _getHeaders(),
    );

    final data = _decodeResponse(response);

    return CompanyModel.fromJson(data);
  }

  // Approve driver registration
  Future<Map<String, dynamic>> approveDriver(
    int driverId,
  ) async {
    final response = await _client.post(
      Uri.parse(AppUrl.Approve),
      headers: await _getHeaders(),
      body: jsonEncode({
        'registration_type': 'driver',
        'registration_id': driverId,
        'action': 'approve',
      }),
    );

    return _decodeResponse(response);
  }

  // Reject driver registration
  Future<Map<String, dynamic>> rejectDriver({
    required int registrationId,
    required String rejectionReason,
  }) async {
    final response = await _client.post(
      Uri.parse(AppUrl.Reject),
      headers: await _getHeaders(),
      body: jsonEncode({
        'registration_type': 'driver',
        'registration_id': registrationId,
        'rejection_reason': rejectionReason,
      }),
    );

    return _decodeResponse(response);
  }

  // Close HTTP client
  void dispose() {
    _client.close();
  }
}

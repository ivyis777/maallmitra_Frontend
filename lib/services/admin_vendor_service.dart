

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/admin_vendor_model.dart';

class AdminVendorService {
  final http.Client _client;

  AdminVendorService({http.Client? client})
      : _client = client ?? http.Client();

  Future<String> _getAccessToken() async {
    final token = await LocalStorageConstants.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Access token not found. Please log in again.');
    }

    return token;
  }

  Future<Map<String, String>> _headers() async {
    final token = await _getAccessToken();

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String endpoint) => Uri.parse(endpoint);

  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid server response (${response.statusCode}).',
      );
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

  // GET: ALL VENDOR REGISTRATIONS
  Future<Map<String, dynamic>> fetchVendors() async {
    final url = AppUrl.adminVendorRegistrations;

    debugPrint('Fetch vendors URL: $url');

    final response = await _client.get(
      _uri(url),
      headers: await _headers(),
    );

    debugPrint('Fetch vendors status: ${response.statusCode}');
    debugPrint('Fetch vendors response: ${response.body}');

    return _decodeResponse(response);
  }

  // GET: INDIVIDUAL VENDOR DETAILS
  Future<AdminVendorModel> fetchVendorDetails(int vendorId) async {
    final url = AppUrl.adminVendorDetails(vendorId);

    debugPrint('Vendor details URL: $url');

    final response = await _client.get(
      _uri(url),
      headers: await _headers(),
    );

    debugPrint('Vendor details status: ${response.statusCode}');
    debugPrint('Vendor details response: ${response.body}');

    final data = _decodeResponse(response);

    final vendorJson = data['data'] ??
        data['vendor'] ??
        data['vendor_details'];

    if (vendorJson is! Map) {
      throw Exception('Vendor details not found in server response.');
    }

    return AdminVendorModel.fromJson(
      Map<String, dynamic>.from(vendorJson),
    );
  }

  // POST: APPROVE VENDOR
  Future<Map<String, dynamic>> approveVendor(int vendorId) async {
    final url = AppUrl.Approve;

    final body = {
      'registration_type': 'vendor',
      'registration_id': vendorId,
      'action': 'approve',
    };

    debugPrint('Approve vendor URL: $url');
    debugPrint('Approve vendor body: ${jsonEncode(body)}');

    final response = await _client.post(
      _uri(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('Approve vendor status: ${response.statusCode}');
    debugPrint('Approve vendor response: ${response.body}');

    return _decodeResponse(response);
  }

  // POST: REJECT VENDOR
  Future<Map<String, dynamic>> rejectVendor({
    required int vendorId,
    required String rejectionReason,
  }) async {
    final url = AppUrl.Reject;

    final body = {
      'registration_type': 'vendor',
      'registration_id': vendorId,
      'rejection_reason': rejectionReason,
    };

    debugPrint('Reject vendor URL: $url');
    debugPrint('Reject vendor body: ${jsonEncode(body)}');

    final response = await _client.post(
      _uri(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('Reject vendor status: ${response.statusCode}');
    debugPrint('Reject vendor response: ${response.body}');

    return _decodeResponse(response);
  }

  void dispose() {
    _client.close();
  }
}


import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app url.dart';
import '../data/models/admin_manufacturer_model.dart';

class AdminManufacturerService {
  // Authentication headers
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null || token.isEmpty) {
      throw Exception(
        'Access token missing. Please log in again.',
      );
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // Decode and validate API response
  dynamic _decode(http.Response response) {
    debugPrint('API URL: ${response.request?.url}');
    debugPrint('API Status: ${response.statusCode}');
    debugPrint('API Response: ${response.body}');

    dynamic body;

    try {
      body = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Invalid server response (${response.statusCode}).',
      );
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      if (body is Map) {
        throw Exception(
          body['detail'] ??
              body['message'] ??
              body['errors'] ??
              'Request failed (${response.statusCode}).',
        );
      }

      throw Exception(
        'Request failed (${response.statusCode}).',
      );
    }

    if (body is Map && body['success'] == false) {
      throw Exception(
        body['message'] ?? 'Request failed.',
      );
    }

    return body;
  }

  // GET: All manufacturer registrations
  Future<List<AdminManufacturerModel>>
      fetchManufacturers() async {
    final url = AppUrl.adminManufacturerRegistrations;

    debugPrint('Fetch manufacturers URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    final body = _decode(response);

    if (body is! Map) {
      throw Exception(
        'Invalid manufacturer list response.',
      );
    }

    final dynamic manufacturersData = body['manufacturers'];

    if (manufacturersData is! Map) {
      throw Exception(
        'Manufacturer data not found in the API response.',
      );
    }

    final List<AdminManufacturerModel> result = [];

    for (final status in [
      'pending',
      'approved',
      'rejected',
    ]) {
      final dynamic registrations =
          manufacturersData[status];

      if (registrations is List) {
        for (final item in registrations) {
          if (item is Map) {
            final json = Map<String, dynamic>.from(item);

            // Use the category as the status if missing.
            json['status'] ??= status;

            result.add(
              AdminManufacturerModel.fromJson(json),
            );
          }
        }
      }
    }

    debugPrint(
      'Manufacturer registrations loaded: ${result.length}',
    );

    return result;
  }

  // GET: Individual manufacturer details
  Future<AdminManufacturerModel> fetchManufacturerDetails(
    int manufacturerId,
  ) async {
    final url =
        AppUrl.adminManufacturerDetails(manufacturerId);

    debugPrint('Manufacturer details URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    final body = _decode(response);

    if (body is! Map) {
      throw Exception(
        'Invalid manufacturer details response.',
      );
    }

    final dynamic data = body['data'] ?? body;

    if (data is! Map) {
      throw Exception(
        'Manufacturer details were not found.',
      );
    }

    return AdminManufacturerModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  // POST: Approve manufacturer
  Future<Map<String, dynamic>> approveManufacturer(
    int manufacturerId,
  ) async {
    final url = AppUrl.Approve;

    final payload = {
      'registration_type': 'manufacturer',
      'registration_id': manufacturerId,
      'action': 'approve',
    };

    debugPrint('========== APPROVE MANUFACTURER ==========');
    debugPrint('Approve URL: $url');
    debugPrint('Request payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(payload),
    );

    debugPrint('Approve HTTP status: ${response.statusCode}');
    debugPrint('Approve response: ${response.body}');

    return _decodeToMap(response);
  }

  // POST: Reject manufacturer
  Future<Map<String, dynamic>> rejectManufacturer({
    required int manufacturerId,
    required String rejectionReason,
  }) async {
    if (rejectionReason.trim().isEmpty) {
      throw Exception(
        'Please provide a rejection reason.',
      );
    }

    final url = AppUrl.Reject;

    final payload = {
      'registration_type': 'manufacturer',
      'registration_id': manufacturerId,
      'rejection_reason': rejectionReason.trim(),
    };

    debugPrint('========== REJECT MANUFACTURER ==========');
    debugPrint('Reject URL: $url');
    debugPrint('Request payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(payload),
    );

    debugPrint('Reject HTTP status: ${response.statusCode}');
    debugPrint('Reject response: ${response.body}');

    return _decodeToMap(response);
  }

  // POST: Review manufacturer using the existing controller API
  Future<Map<String, dynamic>> reviewManufacturer({
    required int manufacturerId,
    required bool approve,
    String rejectionReason = '',
  }) async {
    if (approve) {
      return approveManufacturer(manufacturerId);
    }

    return rejectManufacturer(
      manufacturerId: manufacturerId,
      rejectionReason: rejectionReason,
    );
  }

  // Decode response as a JSON map
  Map<String, dynamic> _decodeToMap(
    http.Response response,
  ) {
    final dynamic body = _decode(response);

    if (body is Map<String, dynamic>) {
      return body;
    }

    if (body is Map) {
      return Map<String, dynamic>.from(body);
    }

    throw Exception(
      'Unexpected review response format.',
    );
  }
}

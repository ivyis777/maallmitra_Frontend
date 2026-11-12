
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app url.dart';
import '../../core/storage/LocalStorageConstants.dart';
import '../data/models/admin_truck_owner_model.dart';
import '../data/models/truck_owner_details_model.dart';


class AdminTruckOwnerService {
  final http.Client _client;

  AdminTruckOwnerService({http.Client? client})
      : _client = client ?? http.Client();

  Future<Map<String, String>> _headers() async {
    final token = await LocalStorageConstants.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('Access token not found. Please log in again.');
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
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

  // GET: all truck-owner registrations
  Future<AdminTruckOwnerModel> fetchTruckOwners() async {
    final url = AppUrl.adminTruckOwnerRegistrations;

    debugPrint('Truck owner list URL: $url');

    final response = await _client.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    debugPrint('Truck owner list status: ${response.statusCode}');
    debugPrint('Truck owner list response: ${response.body}');

    return AdminTruckOwnerModel.fromJson(
      _decodeResponse(response),
    );
  }

  // GET: individual truck-owner details
  Future<TruckOwnerDetailsModel> fetchTruckOwnerDetails(
    int ownerId,
  ) async {
    final url = AppUrl.admintruckOwnerDetails(ownerId);

    debugPrint('Truck owner details URL: $url');

    final response = await _client.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    debugPrint('Truck owner details status: ${response.statusCode}');
    debugPrint('Truck owner details response: ${response.body}');

    return TruckOwnerDetailsModel.fromJson(
      _decodeResponse(response),
    );
  }

  // POST: approve truck owner
  Future<Map<String, dynamic>> approveTruckOwner(
    int ownerId,
  ) async {
    final body = {
      'registration_type': 'truck_owner',
      'registration_id': ownerId,
      'action': 'approve',
    };

    final response = await _client.post(
      Uri.parse(AppUrl.Approve),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('Approve truck owner status: ${response.statusCode}');
    debugPrint('Approve truck owner response: ${response.body}');

    return _decodeResponse(response);
  }

  // POST: reject truck owner
  Future<Map<String, dynamic>> rejectTruckOwner({
    required int ownerId,
    required String rejectionReason,
  }) async {
    final body = {
      'registration_type': 'truck_owner',
      'registration_id': ownerId,
      'rejection_reason': rejectionReason,
    };

    final response = await _client.post(
      Uri.parse(AppUrl.Reject),
      headers: await _headers(),
      body: jsonEncode(body),
    );

    debugPrint('Reject truck owner status: ${response.statusCode}');
    debugPrint('Reject truck owner response: ${response.body}');

    return _decodeResponse(response);
  }

  void dispose() {
    _client.close();
  }
}

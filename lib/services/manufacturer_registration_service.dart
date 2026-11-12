import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app url.dart';
class ManufacturerRegistrationService {
  Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token not found. Please log in again.');
    }

    return accessToken;
  }
  Future<Map<String, dynamic>> registerManufacturer({
    required Map<String, String> fields,
    required List<String> productCategories,
    required PlatformFile companyCertificate,
    required PlatformFile gstCertificate,
    required PlatformFile addressProof,
  }) async {
    try {
      final accessToken = await _getAccessToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.registerManufacturer),
      );

      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);
      request.fields['product_categories'] =
          jsonEncode(productCategories);

      await _addDocument(
        request,
        'company_registration_certificate',
        companyCertificate,
      );

      await _addDocument(
        request,
        'gst_certificate',
        gstCertificate,
      );

      await _addDocument(
        request,
        'business_address_proof',
        addressProof,
      );

      debugPrint('Manufacturer registration URL: ${request.url}');
      debugPrint('Manufacturer registration fields: ${request.fields}');
      debugPrint(
        'Manufacturer registration files: '
        '${request.files.map((file) => file.field).toList()}',
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(
        'Manufacturer registration status: ${response.statusCode}',
      );
      debugPrint(
        'Manufacturer registration response: ${response.body}',
      );
      final decoded = _decodeResponse(response);
      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          decoded['success'] == true) {
        return decoded;
      }
      final detail = decoded['detail'] ??
          decoded['message'] ??
          decoded['errors'] ??
          decoded;
      throw Exception('HTTP ${response.statusCode}: $detail');
    } catch (e) {
      debugPrint('Manufacturer registration error: $e');
      rethrow;
    }
  }
  /// Fetches the current manufacturer's registration status.
  Future<Map<String, dynamic>> checkManufacturerStatus() async {
    final accessToken = await _getAccessToken();

    final uri = Uri.parse(AppUrl.manufacturerProfile);

    debugPrint('Manufacturer status URL: $uri'); 
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    debugPrint(
      'Manufacturer status HTTP status: ${response.statusCode}',
    );
    debugPrint(
      'Manufacturer status response: ${response.body}',
    );

    final decoded = _decodeResponse(response);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['success'] == true) {
      return decoded;
    }

    final detail = decoded['detail'] ??
        decoded['message'] ??
        decoded['errors'] ??
        decoded;

    throw Exception(
      'HTTP ${response.statusCode}: $detail',
    );
  }
  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'Server returned an invalid response. '
        'HTTP ${response.statusCode}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected server response.');
    }

    return decoded;
  }
  Future<void> _addDocument(
    http.MultipartRequest request,
    String fieldName,
    PlatformFile file,
  ) async {
    final path = file.path;
    if (path == null || path.isEmpty) {
      throw Exception(
        'File path is unavailable for $fieldName. '
        'Please select the document again.',
      );
    }
    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        path,
        filename: file.name,
      ),
    );
  }
}

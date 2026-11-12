
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/constants/app url.dart';
import '../../core/storage/LocalStorageConstants.dart';
import '../data/models/vendor_registration_model.dart';
class VendorRegistrationService {
  Future<String?> _getAccessToken() async {
    return await LocalStorageConstants.getAccessToken();
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await _getAccessToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'Authentication token not found. Please log in again.',
      );
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, dynamic>> _decodeResponse(
    http.Response response,
  ) async {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'Server returned an invalid response '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (decoded is! Map) {
      throw Exception('Unexpected server response format.');
    }

    final data = Map<String, dynamic>.from(decoded);

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        data['success'] == false) {
      final message =
          data['message'] ?? data['detail'] ?? data['error'];

      throw Exception(
        message?.toString() ??
            'Request failed (HTTP ${response.statusCode}).',
      );
    }

    return data;
  }

  /// Register a vendor using multipart/form-data.
  ///
  /// Field names must match the backend serializer.
  Future<VendorRegistrationModel> registerVendor({
    required String fullName,
    required String email,
    required String mobileNumber,
    String? alternateMobileNumber,
    required String businessName,
    required String businessType,
    required String businessCategory,
    required String gstNumber,
    String? businessRegistrationNumber,
    required String yearsInBusiness,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String district,
    required String state,
    required String pincode,
    String? profilePhotoPath,
    String? gstCertificatePath,
    String? addressProofPath,
    String? transportPermitDocumentPath,
    String? businessLicensePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.registerVendor),
    );

    request.headers.addAll(await _authHeaders());

    request.fields.addAll({
      'full_name': fullName.trim(),
      'email': email.trim(),
      'mobile_number': mobileNumber.trim(),
      'business_name': businessName.trim(),
      'business_type': businessType.trim(),
      'business_category': businessCategory.trim(),
      'gst_number': gstNumber.trim().toUpperCase(),
      'years_in_business': yearsInBusiness.trim(),
      'address_line_1': addressLine1.trim(),
      'city': city.trim(),
      'district': district.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),
    });

    void addOptionalField(String key, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        request.fields[key] = value.trim();
      }
    }

    addOptionalField(
      'alternate_mobile_number',
      alternateMobileNumber,
    );
    addOptionalField(
      'business_registration_number',
      businessRegistrationNumber,
    );
    addOptionalField('address_line_2', addressLine2);

    Future<void> addFile(
      String fieldName,
      String? path,
    ) async {
      if (path == null || path.trim().isEmpty) return;

      final file = File(path);

      if (!await file.exists()) {
        throw Exception(
          'Selected file for $fieldName does not exist.',
        );
      }

      request.files.add(
        await http.MultipartFile.fromPath(fieldName, path),
      );
    }

    await addFile('profile_photo', profilePhotoPath);
    await addFile('gst_certificate', gstCertificatePath);
    await addFile('address_proof', addressProofPath);
    await addFile(
      'transport_permit_document',
      transportPermitDocumentPath,
    );
    await addFile('business_license', businessLicensePath);

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );

      // final response = await http.Response.fromStream(
      //   streamedResponse,
      // );

      // final json = await _decodeResponse(response);
     final response = await http.Response.fromStream(
  streamedResponse,
);

debugPrint('========== VENDOR REGISTRATION ==========');
debugPrint('URL: ${request.url}');
debugPrint('Status Code: ${response.statusCode}');
debugPrint('Response Body: ${response.body}');
debugPrint('=========================================');

final json = await _decodeResponse(response);


      return VendorRegistrationModel.fromJson(json);
    } catch (e) {
      if (e is SocketException) {
        throw Exception(
          'Cannot connect to the server. Check your network '
          'and backend server.',
        );
      }

      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }

      rethrow;
    }
  }

  /// Fetch the logged-in vendor's profile and registration status.
  Future<VendorRegistrationModel> fetchVendorProfile() async {
    try {
      final response = await http
          .get(
            Uri.parse(AppUrl.vendorProfile),
            headers: await _authHeaders(),
          )
          .timeout(const Duration(seconds: 30));

      final json = await _decodeResponse(response);

      return VendorRegistrationModel.fromJson(json);
    } catch (e) {
      if (e is SocketException) {
        throw Exception('Unable to connect to the server.');
      }

      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      }

      rethrow;
    }
  }
}

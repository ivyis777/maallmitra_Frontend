import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/truck_owner_registration_model.dart';
class TruckOwnerRegistrationService {
  // Register truck owner
  Future<TruckOwnerRegistrationModel> registerTruckOwner({
    required String name,
    required String mobileNumber,
    required String dateOfBirth,
    required String gender,
    required String permanentAddress,
    required String currentAddress,
    required String panCardDocumentPath,
    required String aadhaarCardDocumentPath,
    required bool isSelfDriver,
    String? aadhaarNumber,
    String? drivingLicenceNumber,
    String? dlType,
    String? dlIssuedDate,
    String? dlExpiredDate,
    String? medicalCertificatePath,
    String? policeVerificationCertificatePath,
    String? photoPath,
    String? aadhaarFrontPath,
    String? aadhaarBackPath,
    String? dlFrontPath,
    String? dlBackPath,
    String? companyType,
    String? companyId,
    String? companyBondDocumentPath,
    String? companyName,
    String? companyEmail,
    String? companyPhoneNumber,
    String? companyPersonNumber,
    String? companyAddress,
    String? companyCity,
    String? companyState,
    String? companyPincode,
    String? companyCountry,
    String? companyDocumentType,
    String? companyDocumentPath,
  }) async {
    try {
      final uri = Uri.parse(AppUrl.registerTruckOwner);
      final token = await LocalStorageConstants.getAccessToken();

      final request = http.MultipartRequest('POST', uri);

      request.headers['Accept'] = 'application/json';

      if (token != null && token.trim().isNotEmpty) {
        request.headers['Authorization'] =
            'Bearer ${token.trim()}';
      }

      request.fields.addAll({
        'name': name,
        'mobile_number': mobileNumber,
        'date_of_birth': dateOfBirth,
        'gender': gender.trim().toLowerCase(),
        'permanent_address': permanentAddress,
        'current_address': currentAddress,
        'is_self_driver': isSelfDriver ? 'true' : 'false',
      });

      // Self-driver details
      if (isSelfDriver) {
        _addField(request, 'aadhaar_number', aadhaarNumber);
        _addField(request, 'driving_licence_number',
            drivingLicenceNumber);
        _addField(request, 'dl_type', dlType);
        _addField(request, 'dl_issued_date', dlIssuedDate);
        _addField(request, 'dl_expired_date', dlExpiredDate);
        _addField(request, 'company_type', companyType);
        _addField(request, 'company', companyId);
        _addField(request, 'company_name', companyName);
        _addField(request, 'company_email', companyEmail);
        _addField(request, 'company_phone_number',
            companyPhoneNumber);
        _addField(request, 'company_person_number',
            companyPersonNumber);
        _addField(request, 'company_address', companyAddress);
        _addField(request, 'company_city', companyCity);
        _addField(request, 'company_state', companyState);
        _addField(request, 'company_pincode', companyPincode);
        _addField(request, 'company_country', companyCountry);
        _addField(request, 'company_document_type',
            companyDocumentType);
      }

      // Documents
      await _addFile(
        request,
        'aadhaar_card_document',
        aadhaarCardDocumentPath,
      );
      await _addFile(
  request,
  'pan_card_document',
  panCardDocumentPath,
);

      await _addOptionalFile(
        request, 'medical_certificate',
        medicalCertificatePath,
      );
      await _addOptionalFile(
        request, 'police_verification_certificate',
        policeVerificationCertificatePath,
      );
      await _addOptionalFile(request, 'photo', photoPath);
      await _addOptionalFile(
        request, 'aadhaar_front', aadhaarFrontPath,
      );
      await _addOptionalFile(
        request, 'aadhaar_back', aadhaarBackPath,
      );
      await _addOptionalFile(
        request, 'dl_front', dlFrontPath,
      );
      await _addOptionalFile(
        request, 'dl_back', dlBackPath,
      );

      if (isSelfDriver) {
        await _addOptionalFile(
          request,
          'company_bond_document',
          companyBondDocumentPath,
        );
        await _addOptionalFile(
          request,
          'company_document',
          companyDocumentPath,
        );
      }

      debugPrint('Truck owner registration URL: $uri');
       debugPrint('TRUCK OWNER REQUEST FIELDS: ${request.fields}');
debugPrint(
  'TRUCK OWNER REQUEST FILES: '
  '${request.files.map((file) => file.field).toList()}',
); 
      final streamedResponse = await request.send();
      final response =
          await http.Response.fromStream(streamedResponse);

      debugPrint(
        'Truck owner registration HTTP: ${response.statusCode}',
      );
      debugPrint(
        'Truck owner registration response: ${response.body}',
      );

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'The server returned an invalid registration response.',
        );
      }

      final json = Map<String, dynamic>.from(decoded);

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          json['success'] == true) {
        return TruckOwnerRegistrationModel.fromJson(json);
      }

      throw Exception(
        _extractErrorMessage(json) ??
            'Truck owner registration failed '
                '(${response.statusCode}).',
      );
    } on SocketException {
      throw Exception(
        'Unable to connect to the server. Check your internet '
        'connection and server address.',
      );
    } on http.ClientException {
      throw Exception('Network error. Please try again.');
    } on FormatException {
      throw Exception('The server returned an invalid response.');
    }
  }

  // Check truck owner registration status using the profile API.
  Future<Map<String, dynamic>> checkTruckOwnerStatus() async {
    final uri = Uri.parse(AppUrl.truckOwnerProfile);
    final token = await LocalStorageConstants.getAccessToken();

    if (token == null || token.trim().isEmpty) {
      throw Exception(
        'Authentication token is missing. Please log in again.',
      );
    }

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.trim()}',
        },
      );

      debugPrint('Truck owner profile URL: $uri');
      debugPrint('Truck owner profile HTTP: ${response.statusCode}');
      debugPrint('Truck owner profile response: ${response.body}');

      if (response.statusCode == 401 ||
          response.statusCode == 403) {
        throw Exception(
          'You are not authorized to check this status. '
          'Please log in again.',
        );
      }

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw Exception(
          'Unable to fetch truck owner status '
          '(${response.statusCode}).',
        );
      }

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map) {
        throw Exception(
          'Server returned an invalid profile response.',
        );
      }

      final json = Map<String, dynamic>.from(decoded);

      if (json['success'] != true) {
        throw Exception(
          json['message']?.toString() ??
              'Unable to fetch truck owner status.',
        );
      }

      final dynamic rawData = json['data'];

      if (rawData is! Map) {
        throw Exception(
          'Server returned an invalid profile response.',
        );
      }

      final data = Map<String, dynamic>.from(rawData);

      final status = (
        json['registration_status'] ??
        data['status'] ??
        ''
      ).toString().toLowerCase().trim();

      if (status.isEmpty) {
        throw Exception(
          'Registration status was not provided by the server.',
        );
      }

      return {
        ...data,
        'status': status,
        'rejection_reason':
            data['rejection_reason'] ?? '',
      };
    } on SocketException {
      throw Exception('Unable to connect to the server.');
    } on http.ClientException {
      throw Exception('Network error. Please try again.');
    } on FormatException {
      throw Exception('The server returned an invalid response.');
    }
  }

  void _addField(
    http.MultipartRequest request,
    String key,
    String? value,
  ) {
    if (value != null && value.trim().isNotEmpty) {
      request.fields[key] = value.trim();
    }
  }

  Future<void> _addFile(
    http.MultipartRequest request,
    String key,
    String path,
  ) async {
    if (path.trim().isEmpty) {
      throw Exception('Required document is missing: $key');
    }

    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Selected document not found: $key');
    }

    request.files.add(
      await http.MultipartFile.fromPath(key, path),
    );
  }

  Future<void> _addOptionalFile(
    http.MultipartRequest request,
    String key,
    String? path,
  ) async {
    if (path == null || path.trim().isEmpty) return;

    final file = File(path);

    if (!await file.exists()) {
      throw Exception('Selected document not found: $key');
    }

    request.files.add(
      await http.MultipartFile.fromPath(key, path),
    );
  }

  String? _extractErrorMessage(Map<String, dynamic> json) {
    final message = json['message'] ?? json['detail'];

    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString();
    }

    final errors = json['errors'];

    if (errors is Map) {
      for (final entry in errors.entries) {
        final value = entry.value;

        if (value is List && value.isNotEmpty) {
          return '${entry.key}: ${value.first}';
        }

        if (value != null) {
          return '${entry.key}: $value';
        }
      }
    }

    return null;
  }
}

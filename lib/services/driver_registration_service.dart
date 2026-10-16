import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../core/constants/app url.dart';
import '../core/storage/LocalStorageConstants.dart';
import '../data/models/driver_registration_model.dart';

class DriverRegistrationService {
  Future<DriverRegistrationModel> registerDriver({
    required String companyType,
    required String name,
    required String age,
    required String gender,
    required String mobileNumber,
    required String aadhaarNumber,
    required String drivingLicenceNumber,
    required String dlType,
    required String dlIssuedDate,
    required String dlExpiredDate,
    required String permanentAddress,
    required String currentAddress,
    required String medicalCertificate,
    required String policeVerificationCertificate,
    required String photo,
    required String aadhaarFront,
    required String aadhaarBack,
    required String dlFront,
    required String dlBack,
    String? companyId,
    String? companyRegistrationId,
    String? companyUniqueId,
    String? companyName,
    String? gstNumber,
    String? companyEmail,
    String? companyPhoneNumber,
    String? companyPersonNumber,
    String? companyAddress,
    String? companyCity,
    String? companyState,
    String? companyPincode,
    String? companyCountry,
    String? companyDocumentPath,
    String? companyBondDocumentPath,
  }) async {
    final uri = Uri.parse('${AppUrl.baseUrl}driver/register/');

    final parsedAge = int.tryParse(age.trim());

    if (parsedAge == null || parsedAge <= 0 || parsedAge >= 80) {
      throw Exception('Please enter a valid age.');
    }

    final normalizedCompanyType = companyType.trim().toLowerCase();
    final isIvyis = normalizedCompanyType == 'ivyis';
    final hasExistingCompany =
        companyId != null && companyId.trim().isNotEmpty;

    // Prevent company-specific data from being submitted for Ivyis.
    if (isIvyis && hasExistingCompany) {
      throw Exception(
        'Ivyis registration must not include an existing company ID.',
      );
    }

    if (isIvyis && companyDocumentPath != null &&
        companyDocumentPath.trim().isNotEmpty) {
      throw Exception(
        'Ivyis registration must not include a new company document.',
      );
    }

    if (isIvyis && companyBondDocumentPath != null &&
        companyBondDocumentPath.trim().isNotEmpty) {
      throw Exception(
        'Ivyis registration must not include a company bond document.',
      );
    }

    final request = http.MultipartRequest('POST', uri);

    // Driver text fields.
    request.fields.addAll({
      'company_type': normalizedCompanyType,
      'name': name.trim(),
      'age': parsedAge.toString(),
      'gender': gender.trim().toLowerCase(),
      'mobile_number': mobileNumber.trim(),
      'aadhaar_number': aadhaarNumber.trim(),
      'driving_licence_number': drivingLicenceNumber.trim(),
      'dl_type': dlType.trim(),
      'dl_issued_date': dlIssuedDate,
      'dl_expired_date': dlExpiredDate,
      'permanent_address': permanentAddress.trim(),
      'current_address': currentAddress.trim(),
    });

    // Company-specific fields:
    // Ivyis: no company ID or new-company details.
    // Existing company: only its database ID.
    // Add Company: new-company details.
    if (!isIvyis) {
      if (hasExistingCompany) {
        request.fields['company'] = companyId!.trim();
      } else {
        final companyDetails = <String, String?>{
          'company_name': companyName,
          'gst_number': gstNumber,
          'company_email': companyEmail,
          'company_phone_number': companyPhoneNumber,
          'company_person_number': companyPersonNumber,
          'company_address': companyAddress,
          'company_city': companyCity,
          'company_state': companyState,
          'company_pincode': companyPincode,
          'company_country': companyCountry,
          'company_document_type': 'GST',
        };

        for (final entry in companyDetails.entries) {
          final value = entry.value?.trim();

          if (value != null && value.isNotEmpty) {
            request.fields[entry.key] = value;
          }
        }
      }
    }

    // Driver files.
    final files = <String, String>{
      'medical_certificate': medicalCertificate,
      'police_verification_certificate':
          policeVerificationCertificate,
      'photo': photo,
      'aadhaar_front': aadhaarFront,
      'aadhaar_back': aadhaarBack,
      'dl_front': dlFront,
      'dl_back': dlBack,
    };

    for (final entry in files.entries) {
      final filePath = entry.value;
      final isPdf = entry.key == 'medical_certificate' ||
          entry.key == 'police_verification_certificate';

      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('Selected file does not exist: ${entry.key}');
      }

      final filename = filePath.split(RegExp(r'[/\\]')).last;

      if (isPdf) {
        if (!filename.toLowerCase().endsWith('.pdf')) {
          throw Exception('${entry.key} must be a PDF file.');
        }

        final handle = await file.open();
        final bytes = await handle.read(5);
        await handle.close();

        if (bytes.length != 5 ||
            String.fromCharCodes(bytes) != '%PDF-') {
          throw Exception(
            '${entry.key} is not a valid PDF document.',
          );
        }
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          entry.key,
          filePath,
          filename: filename,
          contentType:
              isPdf ? MediaType('application', 'pdf') : null,
        ),
      );
    }

    // Existing registered company: proof of association.
    if (!isIvyis &&
        hasExistingCompany &&
        companyBondDocumentPath != null &&
        companyBondDocumentPath.trim().isNotEmpty) {
      final file = File(companyBondDocumentPath);

      if (!await file.exists()) {
        throw Exception('Selected company proof does not exist.');
      }

      final filename =
          companyBondDocumentPath.split(RegExp(r'[/\\]')).last;

      request.files.add(
        await http.MultipartFile.fromPath(
          'company_bond_document',
          companyBondDocumentPath,
          filename: filename,
        ),
      );
    }

    // Add Company: upload the new company's document.
    if (!isIvyis &&
        !hasExistingCompany &&
        companyDocumentPath != null &&
        companyDocumentPath.trim().isNotEmpty) {
      final file = File(companyDocumentPath);

      if (!await file.exists()) {
        throw Exception('Selected company document does not exist.');
      }

      final filename =
          companyDocumentPath.split(RegExp(r'[/\\]')).last;

      request.files.add(
        await http.MultipartFile.fromPath(
          'company_document',
          companyDocumentPath,
          filename: filename,
        ),
      );
    }

    debugPrint('Registration URL: $uri');
    debugPrint('Registration fields: ${request.fields}');
    debugPrint(
      'Registration file fields: '
      '${request.files.map((file) => file.field).toList()}',
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('Registration HTTP status: ${response.statusCode}');
    debugPrint('Registration response: ${response.body}');

    final dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'Server returned an invalid response '
        '(HTTP ${response.statusCode}).',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected registration response.');
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['success'] == true) {
      return DriverRegistrationModel.fromJson(decoded);
    }

    final errors = decoded['errors'];

    if (errors is Map) {
      final messages = <String>[];

      errors.forEach((key, value) {
        final message =
            value is List ? value.join(', ') : value.toString();
        messages.add('$key: $message');
      });

      if (messages.isNotEmpty) {
        throw Exception(messages.join('\n'));
      }
    }

    throw Exception(
      decoded['message']?.toString() ??
          'Driver registration failed '
              '(HTTP ${response.statusCode}).',
    );
  }

  Future<Map<String, dynamic>> fetchDriverProfile() async {
    final token = await LocalStorageConstants.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Please log in to check your registration status.',
      );
    }

    final uri = Uri.parse('${AppUrl.baseUrl}driver/profile/');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Status API: ${response.statusCode}');
    debugPrint('Status API response: ${response.body}');

    final dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Server returned an invalid profile response.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected driver profile response.');
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['success'] == true &&
        decoded['data'] is Map) {
      return Map<String, dynamic>.from(decoded['data'] as Map);
    }

    throw Exception(
      decoded['message']?.toString() ??
          'Unable to check registration status.',
    );
  }
}

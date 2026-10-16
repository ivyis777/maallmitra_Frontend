
//ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app url.dart';
import '../data/models/company_model.dart';

class CompanyService {
  // Existing company registration endpoint
  static const String _registerCompany =
      '${AppUrl.baseUrl}company/register/';

  // GET: Fetch all companies
  static const String _companyList =
      '${AppUrl.baseUrl}company/list/';

  // GET: Fetch one company by ID
  String _companyDetails(int companyId) =>
      '${AppUrl.baseUrl}company/$companyId/';

  // ============================================================
  // GET ALL COMPANIES
  // ============================================================

  Future<List<CompanyModel>> fetchCompanies() async {
    final response = await http
        .get(
          Uri.parse(_companyList),
          headers: {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid company list response');
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['success'] == true) {
      final dynamic data = decoded['data'];

      if (data is! List) {
        throw Exception('Invalid company list data');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => CompanyModel.fromJson(item))
          .toList();
    }

    throw Exception(
      decoded['message']?.toString() ??
          'Failed to fetch companies',
    );
  }

  // ============================================================
  // GET COMPANY DETAILS BY ID
  // ============================================================

  Future<CompanyModel> fetchCompanyDetails(
    int companyId,
  ) async {
    final response = await http
        .get(
          Uri.parse(_companyDetails(companyId)),
          headers: {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid company details response');
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        decoded['success'] == true &&
        decoded['data'] is Map<String, dynamic>) {
      return CompanyModel.fromJson(
        decoded['data'] as Map<String, dynamic>,
      );
    }

    throw Exception(
      decoded['message']?.toString() ??
          'Failed to fetch company details',
    );
  }

  // ============================================================
  // EXISTING ADD COMPANY API
  // ============================================================

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
      Uri.parse(_registerCompany),
    );

    request.fields['company_id'] = company_id;
    request.fields['company_uniqueid'] = company_uniqueid;
    request.fields['company_name'] = companyName;
    request.fields['gst_number'] = gstNumber;
    request.fields['email'] = email;
    request.fields['phone_number'] = phoneNumber;
    request.fields['company_person_number'] =
        companyPersonNumber;
    request.fields['address'] = address;
    request.fields['city'] = city;
    request.fields['state'] = state;
    request.fields['pincode'] = pincode;
    request.fields['country'] = country;
    request.fields['document_type'] = documentType;

    request.files.add(
      await http.MultipartFile.fromPath(
        'document',
        documentPath,
      ),
    );

    final streamedResponse = await request
        .send()
        .timeout(const Duration(seconds: 20));

    final responseBody =
        await streamedResponse.stream.bytesToString();

    final dynamic decoded = jsonDecode(responseBody);

    if (decoded is Map<String, dynamic> &&
        streamedResponse.statusCode >= 200 &&
        streamedResponse.statusCode < 300 &&
        decoded['success'] == true) {
      // Preserve the original response handling.
      return CompanyModel.fromJson(decoded);
    }

    throw Exception(
      decoded is Map<String, dynamic>
          ? decoded['message']?.toString() ??
              'Failed to add company'
          : 'Invalid add company response',
    );
  }
}
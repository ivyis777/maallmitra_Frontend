import 'package:get/get.dart';

import '../../services/company_service.dart';
import '../models/company_model.dart';

class CompanyController extends GetxController {
  final CompanyService _service = CompanyService();
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isFetchingCompanies = false.obs;

  // Existing single-company data
  final Rxn<CompanyModel> company = Rxn<CompanyModel>();
  // All companies fetched from the API
  final RxList<CompanyModel> companies = <CompanyModel>[].obs;
  // Selected company
  final Rxn<CompanyModel> selectedCompany = Rxn<CompanyModel>();
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompanies();
  }

  // Fetch all companies
  Future<void> fetchCompanies() async {
    try {
      isFetchingCompanies.value = true;
      errorMessage.value = '';

      final result = await _service.fetchCompanies();

      companies.assignAll(result);

      // Keep Ivyis Technologies selected by default
      if (selectedCompany.value == null && companies.isNotEmpty) {
        final ivyis = companies.firstWhereOrNull(
          (item) =>
              item.companyName.trim().toLowerCase() ==
              'ivyis technologies',
        );

        selectedCompany.value = ivyis ?? companies.first;
      } else if (selectedCompany.value != null) {
        final selectedId = selectedCompany.value!.companyId;

        selectedCompany.value = companies.firstWhereOrNull(
          (item) => item.companyId == selectedId,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      isFetchingCompanies.value = false;
    }
  }

  // Select a company from the list
  void selectCompany(CompanyModel selected) {
    selectedCompany.value = selected;
  }

  // Existing add-company functionality
  Future<bool> addCompany({
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
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.addCompany(
        company_id: company_id,
        company_uniqueid: company_uniqueid,
        companyName: companyName,
        gstNumber: gstNumber,
        email: email,
        phoneNumber: phoneNumber,
        companyPersonNumber: companyPersonNumber,
        address: address,
        city: city,
        state: state,
        pincode: pincode,
        country: country,
        documentType: documentType,
        documentPath: documentPath,
      );

      company.value = result;

      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst(
            'Exception: ',
            '',
          );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int? get companyId => selectedCompany.value?.companyId;
}

import '../widgets/driver_registration_status_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/app url.dart';
import '../LoginPage/loginPage.dart';
import '../RolePage/role_selection_screen.dart';
import '../HomePages/driver_home_page.dart';
import '../../../core/storage/LocalStorageConstants.dart';
import '../../../core/storage/colors.dart';

import '../../../data/controllers/driver_registration_controller.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState
    extends State<DriverRegistrationScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController ageController =
      TextEditingController();

  final TextEditingController mobileController =
      TextEditingController();

  final TextEditingController aadharController =
      TextEditingController();

  final TextEditingController licenceController =
      TextEditingController();

  final TextEditingController permanentAddressController =
      TextEditingController();

  final TextEditingController currentAddressController =
      TextEditingController();

  // ============================================================
  // COMPANY CONTROLLERS
  // ============================================================
  final TextEditingController companyIdController =
      TextEditingController();

  final TextEditingController companyUniqueIdController =
      TextEditingController();

  final TextEditingController companyNameController =
      TextEditingController();

  final TextEditingController gstNumberController =
      TextEditingController();

  final TextEditingController companyEmailController =
      TextEditingController();

  final TextEditingController companyPhoneController =
      TextEditingController();

  final TextEditingController companyPersonNumberController =
      TextEditingController();

  final TextEditingController companyAddressController =
      TextEditingController();

  final TextEditingController companyCityController =
      TextEditingController();

  final TextEditingController companyStateController =
      TextEditingController();

  final TextEditingController companyPincodeController =
      TextEditingController();

  final TextEditingController companyCountryController =
      TextEditingController(text: 'India');

  // ============================================================
  // API CONTROLLERS
  // ============================================================

  final DriverRegistrationController driverController =
      Get.put(DriverRegistrationController());

  // ============================================================
  // DROPDOWN VALUES
  // ============================================================

  String? selectedGender;
  String? selectedDlType;

  // ============================================================
  // DATE VALUES
  // ============================================================

  DateTime? dlIssuedDate;
  DateTime? dlExpiredDate;

  // ============================================================
  // DRIVER FILE PATHS
  // ============================================================

  String? medicalCertificate;
  String? policeCertificate;
  String? profilePhoto;
  String? aadharFront;
  String? aadharBack;
  String? dlFront;
  String? dlBack;

  // ============================================================
  // COMPANY FILE
  // ============================================================

  String? companyDocumentPath;

  // ============================================================
  // COMPANY UI
  // ============================================================

  String? selectedCompany;
  int? selectedCompanyId;
  Map<String, dynamic>? selectedCompanyDetails;

  final List<Map<String, dynamic>> companyList = [];
  bool isLoadingCompanies = false;
  bool isLoadingCompanyDetails = false;
  String companyApiError = '';
  String? otherCompanyAction; // 'registered' or 'add'

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  // AppUrl.baseUrl may be either:
  // http://192.168.x.x:8000/
  // or http://192.168.x.x:8000/user/
  // These helpers always build the required /user/company/... URLs.
  String get _userApiBase {
    final rawBase = AppUrl.baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final normalizedBase = rawBase.endsWith('/user')
        ? rawBase
        : '$rawBase/user';
    return normalizedBase;
  }

  String get _companyListUrl => '$_userApiBase/company/list/';

  String _companyDetailsUrl(int companyId) =>
      '$_userApiBase/company/$companyId/';

  Future<void> _fetchCompanies() async {
    if (!mounted) return;
    setState(() {
      isLoadingCompanies = true;
      companyApiError = '';
    });

    try {
      debugPrint('Fetching companies from: $_companyListUrl');
      // final response = await http
      //     .get(Uri.parse(_companyListUrl))
      final accessToken = await LocalStorageConstants.getAccessToken();
// Replace this with your actual method for retrieving the saved token.

 final response = await http.get(
  Uri.parse(_companyListUrl),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
   },
 )
          .timeout(const Duration(seconds: 20));
      final decoded = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          'Company list failed: HTTP ${response.statusCode}; '
          'body: ${response.body}',
        );
        throw Exception(
          decoded is Map<String, dynamic>
              ? (decoded['message'] ?? 'Unable to fetch companies')
              : 'Unable to fetch companies',
        );
      }

      if (decoded is! Map<String, dynamic> ||
          decoded['success'] != true ||
          decoded['data'] is! List) {
        throw Exception('Invalid company list response');
      }

      final fetched = (decoded['data'] as List)
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      if (!mounted) return;
      setState(() {
        companyList
          ..clear()
          ..addAll(fetched);

        // Select Ivyis Technologies by default when it is present.
        final ivyis = fetched.cast<Map<String, dynamic>?>().firstWhere(
          (item) =>
              (item?['company_name'] ?? '')
                  .toString()
                  .toLowerCase()
                  .trim() ==
              'ivyis technologies',
          orElse: () => null,
        );

        // Ivyis is the default choice. If it is not in the API response,
        // leave the user at Other so they can choose a registered company
        // or submit new company details.
        if (ivyis != null) {
          selectedCompanyId = int.tryParse(
            '${ivyis['company_id'] ?? ''}',
          );
          selectedCompany = (ivyis['company_name'] ?? '').toString();
          selectedCompanyDetails = ivyis;
        } else {
          selectedCompanyId = null;
          selectedCompany = 'Other';
          selectedCompanyDetails = null;
        }
      });

      if (selectedCompanyId != null) {
        await _fetchCompanyDetails(selectedCompanyId!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // companyApiError = 'Could not load companies. Please try again.';
      });
      debugPrint('Company list API error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoadingCompanies = false);
      }
    }
  }

  Future<void> _fetchCompanyDetails(int companyId) async {
    if (!mounted) return;
    setState(() => isLoadingCompanyDetails = true);

    try {
      final detailsUrl = _companyDetailsUrl(companyId);
      debugPrint('Fetching company details from: $detailsUrl');
      final response = await http
          .get(Uri.parse(detailsUrl))
          .timeout(const Duration(seconds: 20));
      final decoded = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Unable to fetch company details');
      }

      if (decoded is! Map<String, dynamic> ||
          decoded['success'] != true ||
          decoded['data'] is! Map) {
        throw Exception('Invalid company details response');
      }

      if (!mounted) return;
      setState(() {
        selectedCompanyDetails =
            Map<String, dynamic>.from(decoded['data'] as Map);
      });
    } catch (e) {
      debugPrint('Company details API error: $e');
      if (mounted) {
        // _showMessage('Could not load selected company details');
      }
    } finally {
      if (mounted) {
        setState(() => isLoadingCompanyDetails = false);
      }
    }
  }
  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    aadharController.dispose();
    licenceController.dispose();
    permanentAddressController.dispose();
    currentAddressController.dispose();
    
    companyIdController.dispose();
    companyUniqueIdController.dispose();
    companyNameController.dispose();
    gstNumberController.dispose();
    companyEmailController.dispose();
    companyPhoneController.dispose();
    companyPersonNumberController.dispose();
    companyAddressController.dispose();
    companyCityController.dispose();
    companyStateController.dispose();
    companyPincodeController.dispose();
    companyCountryController.dispose();

    super.dispose();
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colours.primaryColor,
      ),
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate({
    required bool issuedDate,
  }) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (issuedDate) {
        dlIssuedDate = pickedDate;
      } else {
        dlExpiredDate = pickedDate;
      }
    });
  }

  // ============================================================
  // DRIVER FILE PICKER
  // ============================================================

  Future<void> _selectFile(String type) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result == null) return;

    final path = result.first.path;

    if (path == null) return;

    setState(() {
      switch (type) {
        case 'medical':
          medicalCertificate = path;
          break;

        case 'police':
          policeCertificate = path;
          break;

        case 'photo':
          profilePhoto = path;
          break;

        case 'aadharFront':
          aadharFront = path;
          break;

        case 'aadharBack':
          aadharBack = path;
          break;

        case 'dlFront':
          dlFront = path;
          break;

        case 'dlBack':
          dlBack = path;
          break;
      }
    });
  }

  // ============================================================
  // COMPANY DOCUMENT PICKER
  // ============================================================

  Future<void> _selectCompanyDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result.isEmpty) return;

    final path = result.first.path;

    if (path == null) return;

    setState(() {
      companyDocumentPath = path;
    });
  }
 
  // ============================================================
  // FILE NAME
  // ============================================================

  String _fileName(String? path) {
    if (path == null || path.isEmpty) {
      return '';
    }

    return path.split(RegExp(r'[/\\]')).last;
  }

  // ============================================================
  // ADD COMPANY
  // ============================================================

  // ============================================================
  // DRIVER REGISTRATION
  // ============================================================

  Future<void> _registerDriver() async {
    // BASIC VALIDATION
    if (nameController.text.trim().isEmpty) {
      _showMessage('Please enter full name');
      return;
    }

    final parsedAge = int.tryParse(ageController.text.trim());
    if (parsedAge == null || parsedAge <= 0 || parsedAge >= 80) {
      _showMessage('Please enter a valid age');
      return;
    }

    if (selectedGender == null) {
      _showMessage('Please select gender');
      return;
    }
    if (mobileController.text.trim().length != 10) {
      _showMessage('Please enter valid mobile number');
      return;
    }
    if (aadharController.text.trim().length != 12) {
      _showMessage('Please enter valid Aadhar number');
      return;
    }
    if (licenceController.text.trim().isEmpty) {
      _showMessage('Please enter driving licence number');
      return;
    }
    if (selectedDlType == null) {
      _showMessage('Please select DL type');
      return;
    }
    if (dlIssuedDate == null) {
      _showMessage('Please select DL issued date');
      return;
    }
    if (dlExpiredDate == null) {
      _showMessage('Please select DL expired date');
      return;
    }
    if (permanentAddressController.text.trim().isEmpty) {
      _showMessage('Please enter permanent address');
      return;
    }
    if (currentAddressController.text.trim().isEmpty) {
      _showMessage('Please enter current address');
      return;
    }

    final isIvyis =
        (selectedCompany ?? '').trim().toLowerCase() == 'ivyis technologies';
    final isOther = selectedCompany == 'Other';
    final isRegisteredCompany =
        isOther && otherCompanyAction == 'registered';
    final isNewCompany = isOther && otherCompanyAction == 'add';

    if (selectedCompany == null || selectedCompany!.trim().isEmpty) {
      _showMessage('Please select a company');
      return;
    }

    if (isOther && otherCompanyAction == null) {
      _showMessage('Please select Registered Companies or Add Company');
      return;
    }

    if (isRegisteredCompany && selectedCompanyId == null) {
      _showMessage('Please select a registered company');
      return;
    }

    if (isRegisteredCompany && companyDocumentPath == null) {
      _showMessage('Please upload company proof document');
      return;
    }

    if (isNewCompany) {
      final requiredCompanyFields = <String, String>{
        'Company ID': companyIdController.text,
        'Company Unique ID': companyUniqueIdController.text,
        'Company Name': companyNameController.text,
        'GST number': gstNumberController.text,
        'Company email': companyEmailController.text,
        'Company phone number': companyPhoneController.text,
        'Company person number': companyPersonNumberController.text,
        'Company address': companyAddressController.text,
        'Company city': companyCityController.text,
        'Company state': companyStateController.text,
        'Company pincode': companyPincodeController.text,
        'Company country': companyCountryController.text,
      };

      for (final entry in requiredCompanyFields.entries) {
        if (entry.value.trim().isEmpty) {
          _showMessage('Please enter ${entry.key.toLowerCase()}');
          return;
        }
      }

      if (companyEmailController.text.trim().isNotEmpty &&
          !GetUtils.isEmail(companyEmailController.text.trim())) {
        _showMessage('Please enter a valid company email');
        return;
      }

      if (companyDocumentPath == null) {
        _showMessage('Please upload company proof document');
        return;
      }
    }

    // DRIVER DOCUMENT VALIDATION
    if (medicalCertificate == null) {
      _showMessage('Please upload medical certificate');
      return;
    }
    if (policeCertificate == null) {
      _showMessage('Please upload police verification certificate');
      return;
    }
    if (profilePhoto == null) {
      _showMessage('Please upload driver photo');
      return;
    }
    if (aadharFront == null) {
      _showMessage('Please upload Aadhar front');
      return;
    }
    if (aadharBack == null) {
      _showMessage('Please upload Aadhar back');
      return;
    }
    if (dlFront == null) {
      _showMessage('Please upload DL front');
      return;
    }
    if (dlBack == null) {
      _showMessage('Please upload DL back');
      return;
    }
    if (!medicalCertificate!.toLowerCase().endsWith('.pdf')) {
      _showMessage('Medical certificate must be a PDF file');
      return;
    }
    if (!policeCertificate!.toLowerCase().endsWith('.pdf')) {
      _showMessage('Police verification certificate must be a PDF file');
      return;
    }

    final String issuedDate =
        '${dlIssuedDate!.year.toString().padLeft(4, '0')}-'
        '${dlIssuedDate!.month.toString().padLeft(2, '0')}-'
        '${dlIssuedDate!.day.toString().padLeft(2, '0')}';
    final String expiredDate =
        '${dlExpiredDate!.year.toString().padLeft(4, '0')}-'
        '${dlExpiredDate!.month.toString().padLeft(2, '0')}-'
        '${dlExpiredDate!.day.toString().padLeft(2, '0')}';

    // The selected company and optional company registration details are
    // submitted with the same driver-registration request.
    // final String companyType = isIvyis
    //     ? 'ivyis'
    //     : isRegisteredCompany
    //         ? (selectedCompanyDetails?['company_name'] ?? '')
    //             .toString()
    //             .trim()
    //             .toLowerCase()
    //         : isNewCompany
    //             ? 'other'
    //             : (selectedCompany ?? '').trim().toLowerCase();

    final String companyType = isIvyis ? 'ivyis' : 'other';

    final success = await driverController.registerDriver(
      companyType: companyType,
      name: nameController.text.trim(),
      age: parsedAge.toString(),
      gender: selectedGender!.trim().toLowerCase(),
      mobileNumber: mobileController.text.trim(),
      aadhaarNumber: aadharController.text.trim(),
      drivingLicenceNumber: licenceController.text.trim(),
      dlType: selectedDlType!.trim(),
      dlIssuedDate: issuedDate,
      dlExpiredDate: expiredDate,
      permanentAddress: permanentAddressController.text.trim(),
      currentAddress: currentAddressController.text.trim(),
      medicalCertificate: medicalCertificate!,
      policeVerificationCertificate: policeCertificate!,
      photo: profilePhoto!,
      aadhaarFront: aadharFront!,
      aadhaarBack: aadharBack!,
      dlFront: dlFront!,
      dlBack: dlBack!,

      // Registered-company choice sends its selected database ID.
      companyId: isRegisteredCompany ? selectedCompanyId?.toString() : null,

      // New-company fields are sent only for Add Company.
      companyRegistrationId:
          isNewCompany ? companyIdController.text.trim() : null,
      companyUniqueId:
          isNewCompany ? companyUniqueIdController.text.trim() : null,
      companyName: isNewCompany ? companyNameController.text.trim() : null,
      gstNumber: isNewCompany ? gstNumberController.text.trim() : null,
      companyEmail: isNewCompany ? companyEmailController.text.trim() : null,
      companyPhoneNumber:
          isNewCompany ? companyPhoneController.text.trim() : null,
      companyPersonNumber:
          isNewCompany ? companyPersonNumberController.text.trim() : null,
      companyAddress: isNewCompany ? companyAddressController.text.trim() : null,
      companyCity: isNewCompany ? companyCityController.text.trim() : null,
      companyState: isNewCompany ? companyStateController.text.trim() : null,
      companyPincode: isNewCompany ? companyPincodeController.text.trim() : null,
      companyCountry: isNewCompany ? companyCountryController.text.trim() : null,
      // companyDocumentPath:
      //     (isRegisteredCompany || isNewCompany) ? companyDocumentPath : null,
      
companyDocumentPath:
    isNewCompany ? companyDocumentPath : null,

companyBondDocumentPath:
    isRegisteredCompany ? companyDocumentPath : null,

    );

    if (!mounted) return;

    if (success) {
      await DriverRegistrationStatusDialog.show(
        context: context,
        status: 'pending',
        onCheckStatus: driverController.fetchDriverStatus,
        getStatusError: () => driverController.errorMessage.value,
        onLogin: () {
          debugPrint('Approved: opening LoginPage');
          Get.offAll(() => const LoginPage());
        },
        onRegisterAgain: () {
          debugPrint('Rejected: opening DriverRegistrationScreen');
          Get.offAll(() => const DriverRegistrationScreen());
        },
      );
    } else {
      _showMessage(
        driverController.errorMessage.value.isEmpty
            ? 'Driver registration failed'
            : driverController.errorMessage.value,
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: colours.primaryColor,
        foregroundColor: colours.foregroundColor,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Driver Registration',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ==================================================
              // HEADER CARD
              // ==================================================

              _buildHeaderCard(),

              const SizedBox(height: 20),

              // ==================================================
              // SECTION 1
              // PERSONAL DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '1',
                title: 'Personal Details',
              ),

              const SizedBox(height: 14),

              _fieldLabel(
                'Full Name',
                required: true,
              ),

              _buildTextField(
                controller: nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
                textCapitalization:
                    TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z ]'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // =================================================
                  // AGE
                  // =================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(
                          'Age',
                          required: true,
                        ),

                        _buildTextField(
                          controller:
                              ageController,
                          hint: 'Enter age',
                          icon:
                              Icons.calendar_today_outlined,
                          keyboardType:
                              TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  // =================================================
                  // GENDER
                  // =================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _fieldLabel(
                          'Gender',
                          required: true,
                        ),

                        _buildDropdown(
                          value: selectedGender,
                          hint: 'Select gender',
                          icon:
                              Icons.people_outline,
                          items: const [
                            'Male',
                            'Female',
                            'Other',
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedGender =
                                  value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 2
              // CONTACT & IDENTITY
              // ==================================================

              _buildSectionHeader(
                number: '2',
                title: 'Contact & Identity',
              ),

              const SizedBox(height: 14),

              _fieldLabel(
                'Mobile Number',
                required: true,
              ),

              _buildTextField(
                controller: mobileController,
                hint:
                    'Enter 10 digit mobile number',
                icon: Icons.phone_outlined,
                keyboardType:
                    TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              _fieldLabel(
                'Aadhar Number',
                required: true,
              ),

              _buildTextField(
                controller: aadharController,
                hint:
                    'Enter 12 digit Aadhar number',
                icon: Icons.badge_outlined,
                keyboardType:
                    TextInputType.number,
                maxLength: 12,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 3
              // DRIVING LICENCE
              // ==================================================

              _buildSectionHeader(
                number: '3',
                title: 'Driving Licence Details',
              ),

              const SizedBox(height: 14),

              _fieldLabel(
                'Driving Licence Number',
                required: true,
              ),

              _buildTextField(
                controller: licenceController,
                hint:
                    'Enter licence number',
                icon:
                    Icons.credit_card_outlined,
                textCapitalization:
                    TextCapitalization.characters,
              ),

              const SizedBox(height: 16),

              _fieldLabel(
                'DL Type',
                required: true,
              ),

              _buildDropdown(
                value: selectedDlType,
                hint: 'Select licence type',
                icon:
                    Icons.directions_car_outlined,
                items: const [
                  'LMV',
                  'HMV',
                  'Transport',
                  'Commercial',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedDlType = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              _fieldLabel(
                'DL Issued Date',
                required: true,
              ),

              _buildDateField(
                date: dlIssuedDate,
                hint: 'Select issued date',
                onTap: () {
                  _selectDate(
                    issuedDate: true,
                  );
                },
              ),

              const SizedBox(height: 16),

              _fieldLabel(
                'DL Expired Date',
                required: true,
              ),

              _buildDateField(
                date: dlExpiredDate,
                hint: 'Select expired date',
                onTap: () {
                  _selectDate(
                    issuedDate: false,
                  );
                },
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 4
              // ADDRESS DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '4',
                title: 'Address Details',
              ),

              const SizedBox(height: 14),

              _fieldLabel(
                'Permanent Address',
                required: true,
              ),

              _buildTextField(
                controller:
                    permanentAddressController,
                hint:
                    'Enter your permanent address',
                icon:
                    Icons.location_on_outlined,
                maxLength: 250,
                maxLines: 4,
                textCapitalization:
                    TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              _fieldLabel(
                'Current Address',
                required: true,
              ),

              _buildTextField(
                controller:
                    currentAddressController,
                hint:
                    'Enter your current address',
                icon:
                    Icons.location_on_outlined,
                maxLength: 250,
                maxLines: 4,
                textCapitalization:
                    TextCapitalization.sentences,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 5
              // REQUIRED DOCUMENTS
              // ==================================================

              _buildSectionHeader(
                number: '5',
                title: 'Required Documents',
              ),

              const SizedBox(height: 14),

              // ==================================================
              // MEDICAL
              // ==================================================

              _buildUploadBox(
                title: 'Medical Certificate',
                subtitle:
                    'PDF, JPG, PNG (Max 5 MB)',
                fileName:
                    medicalCertificate,
                icon:
                    Icons.medical_information_outlined,
                onTap: () {
                  _selectFile('medical');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // POLICE
              // ==================================================

              _buildUploadBox(
                title:
                    'Police Verification Certificate',
                subtitle:
                    'PDF, JPG, PNG (Max 5 MB)',
                fileName:
                    policeCertificate,
                icon:
                    Icons.verified_user_outlined,
                onTap: () {
                  _selectFile('police');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PHOTO
              // ==================================================

              _buildUploadBox(
                title: 'Upload Photo',
                subtitle:
                    'JPG, PNG (Max 2 MB) • Passport size photo',
                fileName:
                    profilePhoto,
                icon:
                    Icons.person_outline,
                onTap: () {
                  _selectFile('photo');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // AADHAR FRONT
              // ==================================================

              _buildUploadBox(
                title: 'Aadhar Card (Front)',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName:
                    aadharFront,
                icon:
                    Icons.badge_outlined,
                onTap: () {
                  _selectFile('aadharFront');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // AADHAR BACK
              // ==================================================

              _buildUploadBox(
                title: 'Aadhar Card (Back)',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName:
                    aadharBack,
                icon:
                    Icons.badge_outlined,
                onTap: () {
                  _selectFile('aadharBack');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DL FRONT
              // ==================================================

              _buildUploadBox(
                title:
                    'Driving Licence (Front)',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName:
                    dlFront,
                icon:
                    Icons.credit_card_outlined,
                onTap: () {
                  _selectFile('dlFront');
                },
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DL BACK
              // ==================================================

              _buildUploadBox(
                title:
                    'Driving Licence (Back)',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName:
                    dlBack,
                icon:
                    Icons.credit_card_outlined,
                onTap: () {
                  _selectFile('dlBack');
                },
              ),

              const SizedBox(height: 28),

              // ==================================================
              // COMPANY SELECTION
              // ==================================================

              _buildCompanySelection(),

              const SizedBox(height: 20),

              // ==================================================
              // REGISTER BUTTON
              // ==================================================

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        driverController
                                .isLoading.value
                            ? null
                            : _registerDriver,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          colours.primaryColor,
                      foregroundColor:
                          colours.buttonTextColor,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                    child:
                        driverController
                                .isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Text(
                                    'Register',
                                    style:
                                        TextStyle(
                                      fontSize:
                                          colours
                                              .buttonFontSize,
                                      fontWeight:
                                          colours
                                              .buttonFontWeight,
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10),
                                  Icon(
                                    Icons
                                        .arrow_forward_rounded,
                                    size: 22,
                                  ),
                                ],
                              ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Please make sure all information and documents '
                  'are correct before registering.',
                  textAlign:
                      TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF3D9),
            Color(0xFFFFE4B8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFFCC80),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF2E3),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/driver.png',
                width: 68,
                height: 68,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join as a Driver',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Create your driver account and '
                  'start your journey with us',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color:
                        Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String number,
    required String title,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                const BoxDecoration(
              color: colours.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF202020),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _fieldLabel(
    String title, {
    bool required = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 7,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF263238),
            ),
          ),

          if (required)
            const Text(
              ' *',
              style: TextStyle(
                color:
                    colours.primaryColor,
                fontSize: 15,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController
        controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>?
        inputFormatters,
    int? maxLength,
    int maxLines = 1,
    TextCapitalization
        textCapitalization =
        TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization:
          textCapitalization,
      style: const TextStyle(
        fontSize: 14,
        color:
            Color(0xFF263238),
      ),
      decoration:
          InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color:
              Colors.grey.shade500,
        ),
        prefixIcon: Icon(
          icon,
          color:
              Colors.blueGrey.shade500,
          size: 22,
        ),
        filled: true,
        fillColor: Colors.white,
        counterText: '',
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color:
                Colors.grey.shade300,
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          borderSide: BorderSide(
            color:
                Colors.grey.shade300,
          ),
        ),
        focusedBorder:
            const OutlineInputBorder(
          borderRadius:
              BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide:
              BorderSide(
            color:
                colours.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?>
        onChanged,
  }) {
    return Container(
      height: 53,
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              Colors.grey.shade300,
        ),
      ),
      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon:
              const Padding(
            padding:
                EdgeInsets.only(
              right: 10,
            ),
            child: Icon(
              Icons
                  .keyboard_arrow_down_rounded,
            ),
          ),
          hint: Row(
            children: [
              const SizedBox(
                  width: 12),
              Icon(
                icon,
                color:
                    Colors.blueGrey
                        .shade500,
                size: 22,
              ),
              const SizedBox(
                  width: 12),
              Text(
                hint,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Colors.grey
                          .shade500,
                ),
              ),
            ],
          ),
          items: items.map(
            (item) {
              return DropdownMenuItem<
                  String>(
                value: item,
                child: Row(
                  children: [
                    const SizedBox(
                        width: 12),
                    Icon(
                      icon,
                      color:
                          Colors.blueGrey
                              .shade500,
                      size: 21,
                    ),
                    const SizedBox(
                        width: 12),
                    Text(
                      item,
                      style:
                          const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ============================================================
  // DATE FIELD
  // ============================================================

  Widget _buildDateField({
    required DateTime? date,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 53,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(12),
          border: Border.all(
            color:
                Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color:
                  Colors.blueGrey.shade500,
              size: 22,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                date == null
                    ? hint
                    : '${date.day.toString().padLeft(2, '0')}/'
                        '${date.month.toString().padLeft(2, '0')}/'
                        '${date.year}',
                style: TextStyle(
                  fontSize: 14,
                  color: date == null
                      ? Colors.grey.shade500
                      : const Color(
                          0xFF263238,
                        ),
                ),
              ),
            ),

            Icon(
              Icons.calendar_today_outlined,
              color:
                  Colors.blueGrey.shade600,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // UPLOAD BOX
  // ============================================================

  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required String? fileName,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool hasFile =
        fileName != null &&
        fileName.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.all(12),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: hasFile
                ? colours.primaryColor
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            // ==================================================
            // ICON
            // ==================================================

            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFFF2E3),
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Icon(
                icon,
                color:
                    colours.primaryColor,
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            // ==================================================
            // TEXT
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    hasFile
                        ? _fileName(fileName)
                        : title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w700,
                      color:
                          Color(0xFF202020),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hasFile
                        ? 'File selected'
                        : subtitle,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // CHOOSE FILE
            // ==================================================

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 10,
              ),
              decoration:
                  BoxDecoration(
                color:
                    const Color(0xFFFFF7ED),
                borderRadius:
                    BorderRadius.circular(9),
                border: Border.all(
                  color:
                      colours.primaryColor,
                ),
              ),
              child: const Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_rounded,
                    color:
                        colours.primaryColor,
                    size: 17,
                  ),

                  SizedBox(width: 5),

                  Text(
                    'Choose File',
                    style:
                        TextStyle(
                      color:
                          colours.primaryColor,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMPANY SECTION
  // ============================================================

  // ============================================================
  // COMPANY SELECTION
  // ============================================================
Widget _buildCompanySelection() {
  final ivyisCompany = companyList.where((company) {
    return (company['company_name'] ?? '')
            .toString()
            .trim()
            .toLowerCase() ==
        'ivyis technologies';
  }).toList();

  final registeredCompanies = companyList.where((company) {
    final name = (company['company_name'] ?? '').toString().trim();
    return name.isNotEmpty &&
        name.toLowerCase() != 'ivyis technologies';
  }).toList();

  final isOther = selectedCompany == 'Other';
  final isAddingCompany = isOther && otherCompanyAction == 'add';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel('Company', required: true),

      if (isLoadingCompanies)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (companyList.isEmpty)
        const Text('No companies are available.')
      else
        _buildDropdown(
          value: selectedCompany,
          hint: 'Select company',
          icon: Icons.business_outlined,
          items: [
            if (ivyisCompany.isNotEmpty)
              (ivyisCompany.first['company_name'] ??
                      'Ivyis Technologies')
                  .toString(),
            'Other',
          ].toSet().toList(),
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedCompany = value;
              otherCompanyAction = null;
              selectedCompanyId = null;
              selectedCompanyDetails = null;
              companyDocumentPath = null;

              if (value != 'Other') {
                final match = companyList.firstWhere(
                  (company) =>
                      (company['company_name'] ?? '').toString() ==
                      value,
                );

                selectedCompanyId =
                    int.tryParse('${match['company_id'] ?? ''}');
                selectedCompanyDetails = match;
              }
            });

            if (value != 'Other' && selectedCompanyId != null) {
              _fetchCompanyDetails(selectedCompanyId!);
            }
          },
        ),

      if (isOther) ...[
        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                otherCompanyAction = 'add';
                selectedCompanyId = null;
                selectedCompanyDetails = null;
                companyDocumentPath = null;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colours.primaryColor,
              foregroundColor: colours.buttonTextColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Company'),
          ),
        ),

        const SizedBox(height: 12),

        // Company names appear directly below Add Company.
        ...registeredCompanies.map((company) {
          final name = (company['company_name'] ?? '').toString();
          final id = int.tryParse('${company['company_id'] ?? ''}');
          final isSelected = selectedCompanyId == id &&
              otherCompanyAction == 'registered';

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (id == null) return;

                setState(() {
                  otherCompanyAction = 'registered';
                  selectedCompanyId = id;
                  selectedCompanyDetails = company;
                  companyDocumentPath = null;
                });

                _fetchCompanyDetails(id);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colours.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: colours.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        if (registeredCompanies.isEmpty)
          const Text('No other registered companies are available.'),

        // Selected registered company details and proof upload.
        if (otherCompanyAction == 'registered' &&
            selectedCompanyId != null) ...[
          const SizedBox(height: 8),
          if (isLoadingCompanyDetails)
            const LinearProgressIndicator()
          else if (selectedCompanyDetails != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCompanyDetails!['company_name']
                            ?.toString() ??
                        '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _companyDetailLine(
                    'Company ID',
                    selectedCompanyDetails!['company_id'],
                  ),
                  _companyDetailLine(
                    'Unique ID',
                    selectedCompanyDetails!['company_uniqueid'],
                  ),
                  _companyDetailLine(
                    'Email',
                    selectedCompanyDetails!['email'],
                  ),
                  _companyDetailLine(
                    'Phone',
                    selectedCompanyDetails!['phone_number'],
                  ),
                  _companyDetailLine(
                    'Address',
                    [
                      selectedCompanyDetails!['address'],
                      selectedCompanyDetails!['city'],
                      selectedCompanyDetails!['state'],
                      selectedCompanyDetails!['pincode'],
                    ]
                        .where((value) =>
                            value != null &&
                            value.toString().trim().isNotEmpty)
                        .join(', '),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          _buildUploadBox(
            title: 'Upload Company Proof Document',
            subtitle: 'PDF, JPG, JPEG or PNG',
            fileName: companyDocumentPath,
            icon: Icons.description_outlined,
            onTap: _selectCompanyDocument,
          ),
        ],

        // Show the new company form only after Add Company is clicked.
        if (isAddingCompany) ...[
          const SizedBox(height: 8),
          _buildCompanySection(),
        ],
      ],
    ],
  );
}

  Widget _companyDetailLine(String label, dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty || text == 'null') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        '$label: $text',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // ======================================================
          // COMPANY HEADER
          // ======================================================

          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFFFFF2E3),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  Icons.business_outlined,
                  color:
                      colours.primaryColor,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Details',
                      style:
                          TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF202020),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Add your company details',
                      style:
                          TextStyle(
                        fontSize: 12,
                        color:
                            Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          

          // ======================================================
          // COMPANY ID,
          // ======================================================
          _fieldLabel(  
            'Company ID',
            required: true,
          ), 
           _buildTextField(
            controller:
                companyIdController,
            hint:
                'Enter company ID',
            icon:
                Icons.business_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // ======================================================
          //  Company Unique ID,
          // ======================================================
             

          _fieldLabel(  
            'Company Unique ID',  
            required: true,  
          ),
           _buildTextField(
            controller:
                companyUniqueIdController,
            hint:
                'Enter company unique ID',
            icon:
                Icons.business_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),
          // ======================================================
          // COMPANY NAME
          
          _fieldLabel(
            'Company Name',
            required: true,
          ),

          _buildTextField(
            controller:
                companyNameController,
            hint:
                'Enter company name',
            icon:
                Icons.business_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // GST
          // ======================================================

          _fieldLabel(
            'GST Number',
            required: true,
          ),

          _buildTextField(
            controller:
                gstNumberController,
            hint:
                'Enter GST number',
            icon:
                Icons.receipt_long_outlined,
            textCapitalization:
                TextCapitalization.characters,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // EMAIL
          // ======================================================

          _fieldLabel(
            'Email',
            required: true,
          ),

          _buildTextField(
            controller:
                companyEmailController,
            hint:
                'Enter company email',
            icon:
                Icons.email_outlined,
            keyboardType:
                TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // PHONE
          // ======================================================

          _fieldLabel(
            'Company Phone Number',
            required: true,
          ),

          _buildTextField(
            controller:
                companyPhoneController,
            hint:
                'Enter company phone number',
            icon:
                Icons.phone_outlined,
            keyboardType:
                TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // COMPANY PERSON NUMBER
          // ======================================================

          _fieldLabel(
            'Company Person Number',
            required: true,
          ),

          _buildTextField(
            controller:
                companyPersonNumberController,
            hint:
                'Enter contact person number',
            icon:
                Icons.contact_phone_outlined,
            keyboardType:
                TextInputType.phone,
            maxLength: 10,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ADDRESS
          // ======================================================

          _fieldLabel(
            'Address',
            required: true,
          ),

          _buildTextField(
            controller:
                companyAddressController,
            hint:
                'Enter company address',
            icon:
                Icons.location_on_outlined,
            maxLength: 250,
            maxLines: 3,
            textCapitalization:
                TextCapitalization.sentences,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // CITY
          // ======================================================

          _fieldLabel(
            'City',
            required: true,
          ),

          _buildTextField(
            controller:
                companyCityController,
            hint:
                'Enter city',
            icon:
                Icons.location_city_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // STATE
          // ======================================================

          _fieldLabel(
            'State',
            required: true,
          ),

          _buildTextField(
            controller:
                companyStateController,
            hint:
                'Enter state',
            icon:
                Icons.map_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // PINCODE
          // ======================================================

          _fieldLabel(
            'Pincode',
            required: true,
          ),

          _buildTextField(
            controller:
                companyPincodeController,
            hint:
                'Enter pincode',
            icon:
                Icons.pin_drop_outlined,
            keyboardType:
                TextInputType.number,
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter
                  .digitsOnly,
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // COUNTRY
          // ======================================================

          _fieldLabel(
            'Country',
            required: true,
          ),

          _buildTextField(
            controller:
                companyCountryController,
            hint:
                'Enter country',
            icon:
                Icons.public_outlined,
            textCapitalization:
                TextCapitalization.words,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // DOCUMENT TYPE
          // ======================================================

          _fieldLabel(
            'Document Type',
            required: true,
          ),

          Container(
            width: double.infinity,
            height: 53,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
              border: Border.all(
                color:
                    Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons
                      .description_outlined,
                  color:
                      Colors.blueGrey.shade500,
                  size: 22,
                ),

                const SizedBox(width: 12),

                const Text(
                  'GST',
                  style:
                      TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF263238),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // COMPANY DOCUMENT
          // ======================================================

          _fieldLabel(
            'Company Document',
            required: true,
          ),

          GestureDetector(
            onTap:
                _selectCompanyDocument,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(12),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                border: Border.all(
                  color:
                      companyDocumentPath !=
                              null
                          ? colours
                              .primaryColor
                          : Colors.grey
                              .shade300,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFFF2E3,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                    child: Icon(
                      Icons
                          .description_outlined,
                      color:
                          colours.primaryColor,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          companyDocumentPath ==
                                  null
                              ? 'Company Document'
                              : _fileName(
                                  companyDocumentPath,
                                ),
                          maxLines: 2,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            fontSize: 14,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                Color(
                              0xFF202020,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 4),

                        Text(
                          companyDocumentPath ==
                                  null
                              ? 'PDF, JPG, PNG'
                              : 'File selected',
                          style:
                              TextStyle(
                            fontSize: 11,
                            color: Colors
                                .grey
                                .shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 11,
                      vertical: 10,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFFFF7ED,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        9,
                      ),
                      border: Border.all(
                        color:
                            colours
                                .primaryColor,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          Icons
                              .upload_rounded,
                          color:
                              colours
                                  .primaryColor,
                          size: 17,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Choose File',
                          style:
                              TextStyle(
                            color:
                                colours
                                    .primaryColor,
                            fontSize: 12,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

















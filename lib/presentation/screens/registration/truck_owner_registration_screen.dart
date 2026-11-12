import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../widgets/truck_owner_registration_status_dialog.dart';
import '../LoginPage/loginPage.dart';
import '../../../services/company_service.dart';
import '../../../data/models/company_model.dart';
import '../../../data/controllers/truck_owner_registration_controller.dart';
import '../../../core/storage/colors.dart';
import '../registration/truck_owner_status_screens.dart';
import '../HomePages/owner_home_page.dart';
class TruckOwnerRegistrationScreen extends StatefulWidget {
  const TruckOwnerRegistrationScreen({
    super.key,
  });

  @override
  State<TruckOwnerRegistrationScreen> createState() =>
      _TruckOwnerRegistrationScreenState();
}

class _TruckOwnerRegistrationScreenState
    extends State<TruckOwnerRegistrationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _firstValidationError;

  String? _captureValidationError(String? error) {
    if (_firstValidationError == null && error != null) {
      _firstValidationError = error;
    }
    return error;
  }


  // ============================================================
  // OWNER CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController mobileNumberController =
      TextEditingController();

  final TextEditingController permanentAddressController =
      TextEditingController();

  final TextEditingController currentAddressController =
      TextEditingController();

  // ============================================================
  // DRIVER CONTROLLERS
  // ============================================================
  final TextEditingController aadhaarNumberController =
    TextEditingController();

  final TextEditingController licenceNumberController =
      TextEditingController();

  final TruckOwnerRegistrationController registrationController =
      Get.put(TruckOwnerRegistrationController());
  final CompanyService companyService = CompanyService();

  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController companyUniqueIdController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyPersonNumberController = TextEditingController();
  final TextEditingController companyAddressController = TextEditingController();
  final TextEditingController companyCityController = TextEditingController();
  final TextEditingController companyStateController = TextEditingController();
  final TextEditingController companyPincodeController = TextEditingController();
  final TextEditingController companyCountryController = TextEditingController(text: 'India');

  List<CompanyModel> companyList = [];
  CompanyModel? selectedCompanyDetails;
  String selectedCompanyType = 'ivyis';
  String companyChoice = 'registered';
  String? companyDocumentPath;
  String companyDocumentType = 'GST';
  bool isLoadingCompanies = false;
  bool isLoadingCompanyDetails = false;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  // ============================================================
  // OWNER VALUES
  // ============================================================

  String? selectedGender;
  DateTime? dateOfBirth;

  // ============================================================
  // SELF DRIVER
  // ============================================================

  bool isSelfDriver = true;


  // ============================================================
  // DRIVER VALUES
  // ============================================================
  String? selectedDlType;
  final Map<String, String> dlTypeOptions = {
  'LMV': 'LMV',
  'HMV': 'HMV',
  'LMV_HMV': 'LMV + HMV',
  'TRANSPORT': 'Transport',
  'COMMERCIAL': 'Commercial',
  'OTHER': 'Other',
};
  DateTime? dlIssuedDate;
  DateTime? dlExpiredDate;

  // ============================================================
  // FILE NAMES - UI ONLY
  // ============================================================

  String? aadhaarCardPath;
  String? panCardPath;

  String? medicalCertificate;
  String? policeCertificate;
  String? driverPhoto;

  String? aadharFront;
  String? aadharBack;

  String? dlFront;
  String? dlBack;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    mobileNumberController.dispose();
    permanentAddressController.dispose();
    currentAddressController.dispose();
    aadhaarNumberController.dispose();
    licenceNumberController.dispose();
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
  // MOBILE NUMBER VALIDATION
  // ============================================================

  bool _isMobileNumberValid() {
    final mobile = mobileNumberController.text.trim();
    return RegExp(r'^[6-9][0-9]{9}$').hasMatch(mobile);
  }

  void _showMobileNumberError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter a valid 10-digit mobile number.'),
      ),
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate({
    required String type,
  }) async {
    DateTime initialDate = DateTime.now();

    if (type == 'dob') {
      initialDate = DateTime(
        DateTime.now().year - 25,
        DateTime.now().month,
        DateTime.now().day,
      );
    }

    if (type == 'issued' && dlIssuedDate != null) {
      initialDate = dlIssuedDate!;
    }

    if (type == 'expired' && dlExpiredDate != null) {
      initialDate = dlExpiredDate!;
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    setState(() {
      if (type == 'dob') {
        dateOfBirth = pickedDate;
      }

      if (type == 'issued') {
        dlIssuedDate = pickedDate;
      }

      if (type == 'expired') {
        dlExpiredDate = pickedDate;
      }
    });
  }

  // ============================================================
  // REAL FILE PICKER
  // ============================================================

  Future<void> _selectFile(String type) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    // if (result == null || result.single.path == null) return;

    // final path = result.single.path!;
    // final fileName = result.single.name;
   if (result == null || result.isEmpty) return;

final path = result.first.path;
if (path == null) return;
    if (!mounted) return;

    setState(() {
      switch (type) {
        case 'aadhaar':
          aadhaarCardPath = path;
          break;
        case 'pan':
          panCardPath = path;
          break;
        case 'medical':
          medicalCertificate = path;
          break;
        case 'police':
          policeCertificate = path;
          break;
        case 'photo':
          driverPhoto = path;
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
        case 'company':
          companyDocumentPath = path;
          break;
      }
    });
  }

  String _apiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _showRegistrationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchCompanies() async {
    if (mounted) setState(() => isLoadingCompanies = true);
    try {
      final companies = await companyService.fetchCompanies();
      if (!mounted) return;
      setState(() {
        companyList = companies;
        final matches = companies.where((c) => c.companyName.trim().toLowerCase() == 'ivyis technologies');
        if (matches.isNotEmpty) selectedCompanyDetails = matches.first;
      });
    } catch (e) {
      if (mounted) _showRegistrationMessage('Unable to load companies: $e');
    } finally {
      if (mounted) setState(() => isLoadingCompanies = false);
    }
  }

  void _fetchSelectedCompany(CompanyModel company) {
    if (!mounted) return;

    setState(() {
      companyChoice = 'registered';
      companyDocumentPath = null;
      selectedCompanyDetails = company;

      companyIdController.text = company.company_Id;
      companyUniqueIdController.text = company.company_uniqueid;
      companyNameController.text = company.companyName;
      gstNumberController.text = company.gstNumber;
      companyEmailController.text = company.email;
      companyPhoneController.text = company.phoneNumber;
      companyPersonNumberController.text =
          company.companyPersonNumber;
      companyAddressController.text = company.address;
      companyCityController.text = company.city;
      companyStateController.text = company.state;
      companyPincodeController.text = company.pincode;
      companyCountryController.text = company.country;
    });
  }

  bool _validateNewCompany() {
    final values = [
      companyIdController.text, companyUniqueIdController.text,
      companyNameController.text, gstNumberController.text,
      companyEmailController.text, companyPhoneController.text,
      companyPersonNumberController.text, companyAddressController.text,
      companyCityController.text, companyStateController.text,
      companyPincodeController.text, companyCountryController.text,
    ];
    if (values.any((value) => value.trim().isEmpty) || companyDocumentPath == null) {
      _showRegistrationMessage('Complete all company details and select the company document.');
      return false;
    }
    return true;
  }

  Widget _buildCompanySection() {
    final registeredCompanies = companyList.where(
      (company) => company.companyName.trim().toLowerCase() != 'ivyis technologies',
    ).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(number: '5', title: 'Company Details'),
        const SizedBox(height: 14),
        _buildDropdown(
          value: selectedCompanyType == 'ivyis' ? 'Ivyis Technologies' : 'Other',
          hint: 'Select company', icon: Icons.business_outlined,
          items: const ['Ivyis Technologies', 'Other'],
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              selectedCompanyType = value == 'Ivyis Technologies' ? 'ivyis' : 'other';
              companyDocumentPath = null;
              companyChoice = 'registered';
              final ivyisCompanies = companyList.where((c) => c.companyName.trim().toLowerCase() == 'ivyis technologies');
              selectedCompanyDetails = selectedCompanyType == 'ivyis' && ivyisCompanies.isNotEmpty
                  ? ivyisCompanies.first
                  : null;
            });
          },
        ),
        if (selectedCompanyType == 'other') ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => setState(() {
                companyChoice = 'add';
                selectedCompanyDetails = null;
                companyDocumentPath = null;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: colours.buttonColor,
                foregroundColor: colours.buttonTextColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Add Company', style: TextStyle(fontSize: colours.buttonFontSize, fontWeight: colours.buttonFontWeight)),
            ),
          ),
          const SizedBox(height: 12),
          if (companyChoice != 'add') ...[
            if (isLoadingCompanies)
              const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()))
            else if (registeredCompanies.isEmpty)
              const Padding(padding: EdgeInsets.all(12), child: Text('No companies available.'))
            else
              ...registeredCompanies.map((company) {
                final isSelected = selectedCompanyDetails?.companyId == company.companyId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      _fetchSelectedCompany(company);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: isSelected ? colours.validBorderColor : colours.defaultBorderColor, width: isSelected ? 1.8 : 1.0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? colours.validTextColor : colours.hintTextColor, size: 24),
                        const SizedBox(width: 14),
                        Expanded(child: Text(company.companyName, style: const TextStyle(fontSize: 16, color: Colors.black87))),
                      ]),
                    ),
                  ),
                );
              }),
            if (isLoadingCompanyDetails)
              const Padding(padding: EdgeInsets.all(12), child: Center(child: CircularProgressIndicator())),
            if (selectedCompanyDetails != null) ...[
              const SizedBox(height: 4),
              _buildUploadBox(title: 'Company Proof Document', subtitle: 'PDF, JPG, PNG',
                fileName: companyDocumentPath?.split(RegExp(r'[/\\]')).last,
                icon: Icons.description_outlined, onTap: () => _selectFile('company')),
            ],
          ],
          if (companyChoice == 'add') ...[
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => setState(() { companyChoice = 'registered'; companyDocumentPath = null; }),
                icon: const Icon(Icons.arrow_back), label: const Text('Back to companies'),
              ),
            ),
            _fieldLabel('Company Registration ID', required: true),
            _buildTextField(controller: companyIdController, hint: 'Enter company registration ID', icon: Icons.badge_outlined),
            const SizedBox(height: 10),
            _fieldLabel('Company Unique ID', required: true),
            _buildTextField(controller: companyUniqueIdController, hint: 'Enter company unique ID', icon: Icons.tag),
            const SizedBox(height: 10),
            _fieldLabel('Company Name', required: true),
            _buildTextField(controller: companyNameController, hint: 'Enter company name', icon: Icons.business_outlined),
            const SizedBox(height: 10),
            _fieldLabel('GST Number', required: true),
            _buildTextField(controller: gstNumberController, hint: 'Enter GST number', icon: Icons.receipt_long_outlined),
            const SizedBox(height: 10),
            _fieldLabel('Email', required: true),
            _buildTextField(controller: companyEmailController, hint: 'Enter company email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            _fieldLabel('Phone Number', required: true),
            _buildTextField(controller: companyPhoneController, hint: 'Enter phone number', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            _fieldLabel('Company Contact Person Number', required: true),
            _buildTextField(controller: companyPersonNumberController, hint: 'Enter contact person number', icon: Icons.contact_phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 10),
            _fieldLabel('Address', required: true),
            _buildTextField(controller: companyAddressController, hint: 'Enter company address', icon: Icons.location_on_outlined, maxLines: 3),
            const SizedBox(height: 10),
            _fieldLabel('City', required: true),
            _buildTextField(controller: companyCityController, hint: 'Enter city', icon: Icons.location_city_outlined),
            const SizedBox(height: 10),
            _fieldLabel('State', required: true),
            _buildTextField(controller: companyStateController, hint: 'Enter state', icon: Icons.map_outlined),
            const SizedBox(height: 10),
            _fieldLabel('Pincode', required: true),
            _buildTextField(controller: companyPincodeController, hint: 'Enter pincode', icon: Icons.pin_drop_outlined, keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _fieldLabel('Country', required: true),
            _buildTextField(controller: companyCountryController, hint: 'Enter country', icon: Icons.public_outlined),
            const SizedBox(height: 10),
            _buildDropdown(value: companyDocumentType, hint: 'Document type', icon: Icons.description_outlined,
              items: const ['GST', 'PAN', 'Other'], onChanged: (value) => setState(() => companyDocumentType = value ?? 'GST')),
            const SizedBox(height: 12),
            _buildUploadBox(title: 'Company Registration Document', subtitle: 'PDF, JPG, PNG',
              fileName: companyDocumentPath?.split(RegExp(r'[/\\]')).last,
              icon: Icons.upload_file_outlined, onTap: () => _selectFile('company')),
          ],
        ],
      ],
    );
  }

Future<void> _registerTruckOwner() async {
  FocusScope.of(context).unfocus();

  _firstValidationError = null;
  final isValid = _formKey.currentState?.validate() ?? false;

  if (!isValid) {
    _showRegistrationMessage(
      _firstValidationError ?? 'Please check the entered details.',
    );
    return;
  }

  if (!_isMobileNumberValid()) {
    _showMobileNumberError();
    return;
  }

  if (dateOfBirth == null || selectedGender == null) {
    _showRegistrationMessage('Please complete all owner details.');
    return;
  }

  if (aadhaarCardPath == null) {
    _showRegistrationMessage('Please select the Aadhaar document.');
    return;
  }

  if (panCardPath == null) {
    _showRegistrationMessage('Please select the PAN card document.');
    return;
  }

  if (isSelfDriver &&
      !RegExp(r'^[0-9]{12}$')
          .hasMatch(aadhaarNumberController.text.trim())) {
    _showRegistrationMessage(
      'Enter a valid 12-digit Aadhaar number.',
    );
    return;
  }

  if (isSelfDriver) {
    if (licenceNumberController.text.trim().isEmpty ||
        selectedDlType == null ||
        dlIssuedDate == null ||
        dlExpiredDate == null) {
      _showRegistrationMessage(
        'Please complete all driving licence details.',
      );
      return;
    }

    if (medicalCertificate == null ||
        policeCertificate == null ||
        driverPhoto == null ||
        aadharFront == null ||
        aadharBack == null ||
        dlFront == null ||
        dlBack == null) {
      _showRegistrationMessage(
        'Please select all required driver documents.',
      );
      return;
    }
  }

  final isOtherCompany =
      isSelfDriver && selectedCompanyType == 'other';

  final isAddingNewCompany =
      isOtherCompany && companyChoice == 'add';

  if (isOtherCompany) {
    if (isAddingNewCompany) {
      if (!_validateNewCompany()) return;
    } else if (selectedCompanyDetails == null ||
        companyDocumentPath == null) {
      _showRegistrationMessage(
        'Select a registered company and upload its proof document.',
      );
      return;
    }
  }

  final String? registrationCompanyId =
      isOtherCompany && !isAddingNewCompany
          ? selectedCompanyDetails?.companyId.toString()
          : null;
debugPrint('===== SELECTED COMPANY DEBUG =====');
debugPrint('isSelfDriver: $isSelfDriver');
debugPrint('selectedCompanyType: $selectedCompanyType');
debugPrint('companyChoice: $companyChoice');
debugPrint('selectedCompanyDetails: ${selectedCompanyDetails?.companyName}');
debugPrint('selectedCompanyDatabaseId: ${selectedCompanyDetails?.companyId}');
debugPrint('registrationCompanyId: $registrationCompanyId');
debugPrint('isAddingNewCompany: $isAddingNewCompany');
debugPrint('==================================');
  final success =
      await registrationController.registerTruckOwner(
    name: nameController.text.trim(),
    mobileNumber: mobileNumberController.text.trim(),
    dateOfBirth: _apiDate(dateOfBirth!),
    gender: selectedGender!,
    permanentAddress: permanentAddressController.text.trim(),
    currentAddress: currentAddressController.text.trim(),
    aadhaarCardDocumentPath: aadhaarCardPath!,
    panCardDocumentPath: panCardPath!,
    isSelfDriver: isSelfDriver,

    aadhaarNumber: isSelfDriver
    ? aadhaarNumberController.text.trim()
    : null,

    drivingLicenceNumber: isSelfDriver
        ? licenceNumberController.text.trim()
        : null,
    dlType: isSelfDriver ? selectedDlType : null,
    dlIssuedDate:
        isSelfDriver ? _apiDate(dlIssuedDate!) : null,
    dlExpiredDate:
        isSelfDriver ? _apiDate(dlExpiredDate!) : null,
    medicalCertificatePath:
        isSelfDriver ? medicalCertificate : null,
    policeVerificationCertificatePath:
        isSelfDriver ? policeCertificate : null,
    photoPath: isSelfDriver ? driverPhoto : null,
    aadhaarFrontPath: isSelfDriver ? aadharFront : null,
    aadhaarBackPath: isSelfDriver ? aadharBack : null,
    dlFrontPath: isSelfDriver ? dlFront : null,
    dlBackPath: isSelfDriver ? dlBack : null,

    companyType: isSelfDriver ? selectedCompanyType : null,
    companyId: registrationCompanyId,

    companyBondDocumentPath:
        isOtherCompany && !isAddingNewCompany
            ? companyDocumentPath
            : null,

    companyDocumentPath:
        isAddingNewCompany ? companyDocumentPath : null,
    companyName: isAddingNewCompany
        ? companyNameController.text.trim()
        : null,
    companyEmail: isAddingNewCompany
        ? companyEmailController.text.trim()
        : null,
    companyPhoneNumber: isAddingNewCompany
        ? companyPhoneController.text.trim()
        : null,
    companyPersonNumber: isAddingNewCompany
        ? companyPersonNumberController.text.trim()
        : null,
    companyAddress: isAddingNewCompany
        ? companyAddressController.text.trim()
        : null,
    companyCity: isAddingNewCompany
        ? companyCityController.text.trim()
        : null,
    companyState: isAddingNewCompany
        ? companyStateController.text.trim()
        : null,
    companyPincode: isAddingNewCompany
        ? companyPincodeController.text.trim()
        : null,
    companyCountry: isAddingNewCompany
        ? companyCountryController.text.trim()
        : null,
    companyDocumentType:
        isAddingNewCompany ? companyDocumentType : null,
  );

  if (!mounted) return;

  if (!success) {
    _showRegistrationMessage(
      registrationController.errorMessage.value.isEmpty
          ? 'Registration failed. Please try again.'
          : registrationController.errorMessage.value,
    );
    return;
  }

  // Get the registration response.
  final owner = registrationController.registration.value?.data;

  if (owner == null) {
    _showRegistrationMessage(
      'Registration details were not returned by the server.',
    );
    return;
  }

  final status = owner.status.toLowerCase().trim();

  if (status.isEmpty) {
    _showRegistrationMessage(
      'Registration status was not returned by the server.',
    );
    return;
  }

  // Convert the complete model into a profile map.
  final profile = <String, dynamic>{
    ...owner.toJson(),
    'registration_status': status,
    'self_driver': owner.selfDriver?.toJson(),
  };

  debugPrint('TRUCK OWNER STATUS: $status');

  // Navigate according to registration status.
  switch (status) {
    case 'pending':
      Get.offAll(
        () => TruckOwnerPendingScreen(profile: profile),
      );
      break;

    case 'rejected':
      Get.offAll(
        () => TruckOwnerRejectedScreen(profile: profile),
      );
      break;

    case 'approved':
      Get.offAll(
        () => const OwnerHomePage(),
      );
      break;

    default:
      _showRegistrationMessage(
        'Unknown registration status: $status',
      );
  }
}

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),

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
          'Truck Owner Registration',
          style: TextStyle(
            fontSize: 20,
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

          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              // ==================================================
              // HEADER
              // ==================================================

              _buildHeaderCard(),

              const SizedBox(height: 20),

              // ==================================================
              // SECTION 1
              // OWNER DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '1',
                title: 'Owner Details',
              ),

              const SizedBox(height: 14),

              // NAME

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
                maxLength: 50,
              ),

              const SizedBox(height: 16),

              // MOBILE NUMBER
              _fieldLabel(
                'Mobile Number',
                required: true,
              ),

              _buildTextField(
                controller: mobileNumberController,
                hint: 'Enter 10-digit mobile number',
                icon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
              ),

              const SizedBox(height: 16),

              // DATE OF BIRTH

              _fieldLabel(
                'Date of Birth',
                required: true,
              ),

              _buildDateField(
                date: dateOfBirth,
                hint: 'Select date of birth',
                onTap: () {
                  _selectDate(type: 'dob');
                },
              ),

              const SizedBox(height: 16),

              // GENDER

              _fieldLabel(
                'Gender',
                required: true,
              ),

              _buildDropdown(
                value: selectedGender,
                hint: 'Select gender',
                icon: Icons.people_outline,
                items: const [
                  'Male',
                  'Female',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 18),

              // PERMANENT ADDRESS

              _fieldLabel(
                'Permanent Address',
                required: true,
              ),

              _buildTextField(
                controller: permanentAddressController,
                hint: 'Enter permanent address',
                icon: Icons.location_on_outlined,
                maxLength: 250,
                maxLines: 4,
                textCapitalization:
                    TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // CURRENT ADDRESS

              _fieldLabel(
                'Current Address',
                required: true,
              ),

              _buildTextField(
                controller: currentAddressController,
                hint: 'Enter current address',
                icon: Icons.location_on_outlined,
                maxLength: 250,
                maxLines: 4,
                textCapitalization:
                    TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // IDENTITY DOCUMENT

              const SizedBox(height: 12),

              _buildUploadBox(
                title: 'Aadhaar Card',
                subtitle: 'PDF, JPG, PNG',
                fileName: aadhaarCardPath?.split(RegExp(r'[/\\]')).last,
                icon: Icons.badge_outlined,
                onTap: () => _selectFile('aadhaar'),
              ),

              const SizedBox(height: 12),

              _buildUploadBox(
                title: 'PAN Card',
                subtitle: 'PDF, JPG, PNG',
                fileName: panCardPath?.split(RegExp(r'[/\\]')).last,
                icon: Icons.badge_outlined,
                onTap: () => _selectFile('pan'),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 2
              // SELF DRIVER
              // ==================================================

              _buildSectionHeader(
                number: '2',
                title: 'Driver Type',
              ),

              const SizedBox(height: 14),

              _buildSelfDriverCard(),

              const SizedBox(height: 22),

              // ==================================================
              // SELF DRIVER DETAILS
              // ==================================================

              if (isSelfDriver) ...[


                _buildSectionHeader(
                  number: '3',
                  title: 'Driving Licence Details',
                ),

                const SizedBox(height: 14),

                // AADHAAR NUMBER

_fieldLabel(
  'Aadhaar Number',
  required: true,
),

_buildTextField(
  controller: aadhaarNumberController,
  hint: 'Enter 12-digit Aadhaar number',
  icon: Icons.badge_outlined,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(12),
  ],
  maxLength: 12,
),

const SizedBox(height: 16),

                // DL NUMBER

                _fieldLabel(
                  'Driving Licence Number',
                  required: true,
                ),

                _buildTextField(
                  controller:
                      licenceNumberController,
                  hint: 'Enter driving licence number',
                  icon: Icons.credit_card_outlined,
                  textCapitalization:
                      TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9]'),
                    ),
                    UpperCaseTextFormatter(),
                  ],
                ),

                const SizedBox(height: 16),

                // DL TYPE

                _fieldLabel(
                  'DL Type',
                  required: true,
                ),

               Container(
  height: 53,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: selectedDlType != null
          ? colours.validBorderColor
          : colours.defaultBorderColor,
    ),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: selectedDlType,
      isExpanded: true,
      hint: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('Select licence type'),
      ),
      items: dlTypeOptions.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(entry.value),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDlType = value;
        });
      },
    ),
  ),
),

                const SizedBox(height: 16),

                // ISSUED DATE

                _fieldLabel(
                  'DL Issued Date',
                  required: true,
                ),

                _buildDateField(
                  date: dlIssuedDate,
                  hint: 'Select issued date',
                  onTap: () {
                    _selectDate(type: 'issued');
                  },
                ),

                const SizedBox(height: 16),

                // EXPIRED DATE

                _fieldLabel(
                  'DL Expired Date',
                  required: true,
                ),

                _buildDateField(
                  date: dlExpiredDate,
                  hint: 'Select expired date',
                  onTap: () {
                    _selectDate(type: 'expired');
                  },
                ),

                const SizedBox(height: 22),

                // ==================================================
                // DRIVER DOCUMENTS
                // ==================================================

                _buildSectionHeader(
                  number: '4',
                  title: 'Driver Documents',
                ),

                const SizedBox(height: 14),

                // MEDICAL

                _buildUploadBox(
                  title: 'Medical Certificate',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: medicalCertificate?.split(RegExp(r'[/\\]')).last,
                  icon:
                      Icons.medical_information_outlined,
                  onTap: () {
                    _selectFile('medical');
                  },
                ),

                const SizedBox(height: 12),

                // POLICE

                _buildUploadBox(
                  title:
                      'Police Verification Certificate',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: policeCertificate?.split(RegExp(r'[/\\]')).last,
                  icon:
                      Icons.verified_user_outlined,
                  onTap: () {
                    _selectFile('police');
                  },
                ),

                const SizedBox(height: 12),

                // PHOTO

                _buildUploadBox(
                  title: 'Driver Photo',
                  subtitle:
                      'JPG, PNG (Max 2 MB) • Passport size',
                  fileName: driverPhoto?.split(RegExp(r'[/\\]')).last,
                  icon: Icons.person_outline,
                  onTap: () {
                    _selectFile('photo');
                  },
                ),

                const SizedBox(height: 12),

                // AADHAAR FRONT

                _buildUploadBox(
                  title: 'Aadhaar Card - Front',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: aadharFront?.split(RegExp(r'[/\\]')).last,
                  icon: Icons.badge_outlined,
                  onTap: () {
                    _selectFile('aadharFront');
                  },
                ),

                const SizedBox(height: 12),

                // AADHAAR BACK

                _buildUploadBox(
                  title: 'Aadhaar Card - Back',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: aadharBack?.split(RegExp(r'[/\\]')).last,
                  icon: Icons.badge_outlined,
                  onTap: () {
                    _selectFile('aadharBack');
                  },
                ),

                const SizedBox(height: 12),

                // DL FRONT

                _buildUploadBox(
                  title: 'Driving Licence - Front',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: dlFront?.split(RegExp(r'[/\\]')).last,
                  icon:
                      Icons.credit_card_outlined,
                  onTap: () {
                    _selectFile('dlFront');
                  },
                ),

                const SizedBox(height: 12),

                // DL BACK

                _buildUploadBox(
                  title: 'Driving Licence - Back',
                  subtitle:
                      'PDF, JPG, PNG (Max 5 MB)',
                  fileName: dlBack?.split(RegExp(r'[/\\]')).last,
                  icon:
                      Icons.credit_card_outlined,
                  onTap: () {
                    _selectFile('dlBack');
                  },
                ),

                const SizedBox(height: 22),
              ],

              if (isSelfDriver) ...[
                _buildCompanySection(),
                const SizedBox(height: 22),
              ],

              // ==================================================
              // REGISTER
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,

                child: Obx(() => ElevatedButton(
                  onPressed: registrationController.isLoading.value
                      ? null
                      : _registerTruckOwner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        colours.primaryColor,
                    foregroundColor: colours.buttonTextColor,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),

                  child: registrationController.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Register Truck Owner',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded, size: 22),
                          ],
                        ),
                )),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Please make sure all information and '
                  'documents are correct before registering.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              ],
            ),
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

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color:  Color(0xFFFFCC80),
        ),
      ),

      child: Row(
        children: [
          Container(
  width: 68,
  height: 68,

  decoration: BoxDecoration(
    color:  Color(0xFFFFF2E3),
    shape: BoxShape.circle,
  ),

  child: ClipOval(
    child: Image.asset(
      'assets/images/truck1.png',
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
                  'Join as a Truck Owner',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Register your truck and start '
                  'accepting transport opportunities',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey.shade700,
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
  // SELF DRIVER CARD
  // ============================================================

  Widget _buildSelfDriverCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: isSelfDriver
              ? const Color(0xFFFF8500)
              : Colors.grey.shade300,
          width: isSelfDriver ? 1.5 : 1,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color:  Color(0xFFFFF2E3),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.person_pin_circle_outlined,
              color: colours.primaryColor,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  'Self Driver',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  isSelfDriver
                      ? 'I will drive my own truck'
                      : 'I will use a separate driver',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: isSelfDriver,
            activeColor: colours.primaryColor,
            onChanged: (value) {
              setState(() {
                isSelfDriver = value;
              });
            },
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

      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(15),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 38,
            height: 38,

            decoration: const BoxDecoration(
              color: Color(0xFFFF8500),
              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF202020),
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
      padding: const EdgeInsets.only(bottom: 7),

      child: Row(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colours.fieldTextColor,
            ),
          ),

          if (required)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold,
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
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    int maxLines = 1,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,

      keyboardType: keyboardType,

      inputFormatters: inputFormatters,

      maxLength: maxLength,

      maxLines: maxLines,

      textCapitalization: textCapitalization,
      onChanged: (_) => setState(() {}),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (controller == mobileNumberController) {
          if (text.isEmpty) {
            return _captureValidationError(
              'Mobile number is required.',
            );
          }
          if (!_isMobileNumberValid()) {
            return _captureValidationError(
              'Enter a valid 10-digit mobile number.',
            );
          }
        }

        if (controller == aadhaarNumberController && isSelfDriver) {
          if (!RegExp(r'^[0-9]{12}$').hasMatch(text)) {
            return _captureValidationError(
              'Enter a valid 12-digit Aadhaar number.',
            );
          }
        }

        if (text.isEmpty) {
          var fieldName = hint.replaceFirst(
            RegExp(r'^(Enter|Select)\s+', caseSensitive: false),
            '',
          );
          fieldName = fieldName.isEmpty
              ? 'This field'
              : '${fieldName[0].toUpperCase()}${fieldName.substring(1)}';
          return _captureValidationError('$fieldName is required.');
        }

        return null;
      },

      style: const TextStyle(
        fontSize: 14,
        color: colours.fieldTextColor,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.blueGrey.shade500,
          size: 22,
        ),

        filled: true,
        fillColor: Colors.white,

        counterText: '',

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: controller.text.trim().isNotEmpty
                ? colours.validBorderColor
                : colours.defaultBorderColor,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: controller.text.trim().isNotEmpty
                ? colours.validBorderColor
                : colours.defaultBorderColor,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: colours.focusBorderColor,
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colours.errorBorderColor),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colours.errorBorderColor,
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
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 53,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: value != null && value.isNotEmpty
              ? colours.validBorderColor
              : colours.defaultBorderColor,
        ),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
  value: value != null && items.contains(value)
      ? value
      : null,
  isExpanded: true,

          icon: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
          ),

          hint: Row(
            children: [

              const SizedBox(width: 12),

              Icon(
                icon,
                color: Colors.blueGrey.shade500,
                size: 22,
              ),

              const SizedBox(width: 12),

              Text(
                hint,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),

          items: items.map(
            (item) {
              return DropdownMenuItem<String>(
                value: item,

                child: Row(
                  children: [

                    const SizedBox(width: 12),

                    Icon(
                      icon,
                      color: Colors.blueGrey.shade500,
                      size: 21,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      item,
                      style: const TextStyle(
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

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: date != null
                ? colours.validBorderColor
                : colours.defaultBorderColor,
          ),
        ),

        child: Row(
          children: [

            Icon(
              Icons.calendar_month_outlined,
              color: date != null
                  ? colours.validTextColor
                  : colours.hintTextColor,
              size: 22,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                date == null
                    ? hint
                    : _formatDate(date),

                style: TextStyle(
                  fontSize: 14,
                  color: date == null
                      ? Colors.grey.shade500
                      :  colours.fieldTextColor,
                ),
              ),
            ),

            Icon(
              Icons.calendar_today_outlined,
              color: Colors.blueGrey.shade600,
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
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: fileName != null
                ? colours.validBorderColor
                : colours.defaultBorderColor,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: Color(0xFFFFF2E3),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: colours.primaryColor,
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    fileName ?? title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF202020),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    fileName == null
                        ? subtitle
                        : 'File selected',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: fileName != null
                          ? colours.validTextColor
                          : colours.hintTextColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 9,
              ),

              decoration: BoxDecoration(
                color:  Color(0xFFFFF7ED),

                borderRadius: BorderRadius.circular(9),

                border: Border.all(
                  color: colours.primaryColor,
                ),
              ),

              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(
                    Icons.upload_rounded,
                    color: colours.primaryColor,
                    size: 17,
                  ),

                  SizedBox(width: 5),

                  Text(
                    'Choose File',
                    style: TextStyle(
                      color: colours.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
}

// ============================================================
// UPPERCASE FORMATTER
// ============================================================

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
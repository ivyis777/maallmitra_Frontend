import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/storage/colors.dart';
import '../../../core/utils/validators.dart';
import '../../../data/controllers/manufacturer_registration_controller.dart';
import 'manufacturer_status_screens.dart';
class ManufacturerRegistrationScreen extends StatefulWidget {
  const ManufacturerRegistrationScreen({super.key});

  @override
  State<ManufacturerRegistrationScreen> createState() =>
      _ManufacturerRegistrationScreenState();
}

class _ManufacturerRegistrationScreenState
    extends State<ManufacturerRegistrationScreen> {
  late final ManufacturerRegistrationController controller;
  String? _firstValidationError;

  String? _captureValidationError(String? error) {
    if (_firstValidationError == null && error != null) {
      _firstValidationError = error;
    }
    return error;
  }
  final List<String> productCategories = [
    'Steel',
    'Steel Parts',
    'Cement',
    'Construction Materials',
    'Agriculture',
    'Food Products',
    'Machinery',
    'Electrical Products',
    'Textiles',
    'Chemicals',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    controller = Get.put(ManufacturerRegistrationController());
  }
  Future<void> _pickDocument(String documentType) async {
  try {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result.isEmpty) return;

    final file = result.first;
    final path = file.path;

    if (path == null) {
      _showMessage('Unable to access the selected file.');
      return;
    }
final selectedFile = File(path);
final fileSize = await selectedFile.length();

if (fileSize > 5 * 1024 * 1024) {
  _showMessage('File size must not exceed 5 MB.');
  return;
}
    controller.setDocument(documentType, file);
  } catch (e) {
    _showMessage('Failed to select document: $e');
  }
}

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _registerManufacturer() async {
    FocusScope.of(context).unfocus();

    // Clear the previous message before validating the form.
    _firstValidationError = null;
    final isValid = controller.formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showMessage(
        _firstValidationError ?? 'Please check the entered details.',
      );
      return;
    }

    final categoryError = Validators.productCategories(
      controller.selectedCategories.toList(),
    );
    if (categoryError != null) {
      _showMessage(categoryError);
      return;
    }

    // All three documents are required before registration can continue.
    if (controller.companyCertificate.value == null) {
      _showMessage('Please upload Company Registration Certificate.');
      return;
    }

    if (controller.gstCertificate.value == null) {
      _showMessage('Please upload GST Certificate.');
      return;
    }

    if (controller.addressProof.value == null) {
      _showMessage('Please upload Business Address Proof.');
      return;
    }

    final success = await controller.registerManufacturer();
    if (!mounted) return;

    if (!success) {
      if (controller.errorMessage.value.isNotEmpty) {
        _showMessage(controller.errorMessage.value);
      }
      return;
    }

  //   final response = controller.registrationResponse.value;
  //   if (response == null) {
  //     _showMessage('Registration submitted, but response data is missing.');
  //     return;
  //   }

  //   await ManufacturerRegistrationStatusDialog.show(
  //     context: context,
  //     status: response.registrationStatus.trim().isEmpty
  //         ? 'pending'
  //         : response.registrationStatus.trim().toLowerCase(),
  //     onCheckStatus: controller.fetchManufacturerStatus,
  //     getStatusError: () => controller.errorMessage.value,
  //     onLogin: () {
  //       Get.offAll(() => LoginPage());
  //     },
  //     onRegisterAgain: () {
  //       controller.clearForm();
  //       Get.offAll(() => const ManufacturerRegistrationScreen());
  //     },
  //   );
  // }

  final response = controller.registrationResponse.value;

if (response == null || response.data == null) {
  _showMessage(
    'Registration submitted, but manufacturer details are missing.',
  );
  return;
}

final manufacturer = response.data!;

final status = (
  manufacturer.status.trim().isNotEmpty
      ? manufacturer.status
      : response.registrationStatus
).trim().toLowerCase();

final profile = <String, dynamic>{
  'manufacturer_id': manufacturer.manufacturerId,
  'company_name': manufacturer.companyName,
  'gst_number': manufacturer.gstNumber,
  'company_registration_number':
      manufacturer.companyRegistrationNumber,
  'year_of_establishment': manufacturer.yearOfEstablishment,
  'company_landline_number':
      manufacturer.companyLandlineNumber,
  'contact_person_name': manufacturer.contactPersonName,
  'email_address': manufacturer.emailAddress,
  'mobile_number': manufacturer.mobileNumber,
  'factory_address': manufacturer.factoryAddress,
  'city': manufacturer.city,
  'state': manufacturer.state,
  'pin_code': manufacturer.pinCode,
  'country': manufacturer.country,
  'product_categories': manufacturer.productCategories,
  'company_registration_certificate':
      manufacturer.companyRegistrationCertificate,
  'gst_certificate': manufacturer.gstCertificate,
  'business_address_proof': manufacturer.businessAddressProof,
  'status': status,
  'registration_status': status,
  'rejection_reason': manufacturer.rejectionReason,
};

if (status == 'rejected') {
  Get.offAll(
    () => ManufacturerRejectedScreen(profile: profile),
  );
} else if (status == 'pending') {
  Get.offAll(
    () => ManufacturerPendingScreen(profile: profile),
  );
} else if (status == 'approved') {
  _showMessage(
    'Your manufacturer registration has been approved.',
  );
} else {
  _showMessage(
    'The server returned an unrecognized registration status.',
  );
}}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: colours.primaryColor,
        foregroundColor: colours.foregroundColor,
        elevation: 0,
        title: const Text(
          'Manufacturer Registration',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),

                _buildSection(
                  number: '01',
                  title: 'Company Details',
                  subtitle: 'Enter your manufacturing business details',
                  icon: Icons.business_outlined,
                  children: [
                    _buildTextField(
                      label: 'Company Name',
                      hint: 'Enter company name',
                      controller: controller.companyNameController,
                      icon: Icons.factory_outlined,
                      required: true,
                      maxLength: 100,
                      capitalization: TextCapitalization.words,
                      validator: (value) => _captureValidationError(
                        Validators.companyName(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'GST Number',
                      hint: 'Enter 15-character GSTIN',
                      controller: controller.gstController,
                      icon: Icons.receipt_long_outlined,
                      capitalization: TextCapitalization.characters,
                      maxLength: 15,
                      validator: (value) => _captureValidationError(
                        Validators.gstNumber(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Company Registration Number',
                      hint: 'Enter registration number',
                      controller: controller.registrationNumberController,
                      icon: Icons.verified_outlined,
                      maxLength: 50,
                      validator: (value) => _captureValidationError(
                        Validators.companyRegistrationNumber(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Year of Establishment',
                      hint: 'e.g. 2018',
                      controller: controller.yearController,
                      icon: Icons.calendar_month_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 4,
                      validator: (value) => _captureValidationError(
                        Validators.establishmentYear(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Company Landline Number',
                      hint: 'Enter landline number',
                      controller: controller.landlineController,
                      icon: Icons.phone_in_talk_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9+\-() ]'),
                        ),
                      ],
                      maxLength: 20,
                      validator: (value) => _captureValidationError(
                        Validators.landline(value ?? ''),
                      ),
                    ),
                  ],
                ),
                      

                const SizedBox(height: 20),

                _buildSection(
                  number: '02',
                  title: 'Contact Person Details',
                  subtitle: 'Who should we contact about your business?',
                  icon: Icons.person_outline,
                  children: [
                    _buildTextField(
                      label: 'Contact Person Name',
                      hint: 'Enter full name',
                      controller: controller.contactNameController,
                      icon: Icons.person_outline,
                      required: true,
                      capitalization: TextCapitalization.words,
                      maxLength: 100,
                      validator: (value) => _captureValidationError(
                        Validators.name(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Mobile Number',
                      hint: 'Enter 10-digit mobile number',
                      controller: controller.mobileController,
                      icon: Icons.phone_android_outlined,
                      required: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 10,
                      validator: (value) => _captureValidationError(
                        Validators.mobile(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Email Address',
                      hint: 'company@example.com',
                      controller: controller.emailController,
                      icon: Icons.email_outlined,
                      required: true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _captureValidationError(
                        Validators.email(value ?? ''),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildSection(
                  number: '03',
                  title: 'Factory & Business Details',
                  subtitle: 'Where are your manufacturing operations?',
                  icon: Icons.factory_outlined,
                  children: [
                    _buildTextField(
                      label: 'Factory / Manufacturing Unit Address',
                      hint: 'Enter complete factory address',
                      controller: controller.addressController,
                      icon: Icons.location_on_outlined,
                      required: true,
                      maxLength: 250,
                      maxLines: 3,
                      capitalization: TextCapitalization.sentences,
                      validator: (value) => _captureValidationError(
                        Validators.address(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'City',
                      hint: 'Enter city',
                      controller: controller.cityController,
                      icon: Icons.location_city_outlined,
                      required: true,
                      capitalization: TextCapitalization.words,
                      validator: (value) => _captureValidationError(
                        Validators.locationName(value ?? '', field: 'City'),
                      ),
                    ),
                    _buildTextField(
                      label: 'State',
                      hint: 'Enter state',
                      controller: controller.stateController,
                      icon: Icons.map_outlined,
                      required: true,
                      capitalization: TextCapitalization.words,
                      validator: (value) => _captureValidationError(
                        Validators.locationName(value ?? '', field: 'State'),
                      ),
                    ),
                    _buildTextField(
                      label: 'PIN Code',
                      hint: 'Enter 6-digit PIN code',
                      controller: controller.pinCodeController,
                      icon: Icons.markunread_mailbox_outlined,
                      required: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 6,
                      validator: (value) => _captureValidationError(
                        Validators.pinCode(value ?? ''),
                      ),
                    ),
                    _buildTextField(
                      label: 'Country',
                      hint: 'Enter country',
                      controller: controller.countryController,
                      icon: Icons.public_outlined,
                      required: true,
                      capitalization: TextCapitalization.words,
                      validator: (value) => _captureValidationError(
                        Validators.locationName(value ?? '', field: 'Country'),
                      ),
                    ),
                    _buildCategorySelector(),
                  ],
                ),

                const SizedBox(height: 20),

                _buildSection(
                  number: '04',
                  title: 'Documents & Verification',
                  subtitle: 'Upload supporting business documents',
                  icon: Icons.verified_user_outlined,
                  children: [
                    Obx(() => _buildUploadBox(
                      title: 'Company Registration Certificate',
                      subtitle: 'PDF, JPG or PNG • Max 5 MB',
                      file: controller.companyCertificate.value,
                      icon: Icons.business_outlined,
                      required: true,
                      onTap: () => _pickDocument('company'),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => _buildUploadBox(
                      title: 'GST Certificate',
                      subtitle: 'PDF, JPG or PNG • Max 5 MB',
                      file: controller.gstCertificate.value,
                      icon: Icons.receipt_long_outlined,
                      required: true,
                      onTap: () => _pickDocument('gst'),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => _buildUploadBox(
                      title: 'Business Address Proof',
                      subtitle: 'PDF, JPG or PNG • Max 5 MB',
                      file: controller.addressProof.value,
                      icon: Icons.location_on_outlined,
                      required: true,
                      onTap: () => _pickDocument('address'),
                    )),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 17,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Upload clear and readable documents. '
                            'Required documents will depend on the '
                            'business verification rules.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : _registerManufacturer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colours.primaryColor,
                        foregroundColor: colours.buttonTextColor,
                        disabledBackgroundColor: Colors.orange.shade200,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.app_registration, size: 21),
                                SizedBox(width: 10),
                                Text(
                                  'Register Manufacturer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    'Please ensure all business information is accurate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
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

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF3E0),
            Color(0xFFFFE8CC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFCC80)),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/factory.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.factory_outlined,
                    size: 38,
                    color: Color(0xFFFF9800),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Your Manufacturer Account',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colours.fieldTextColor,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Register your manufacturing business and '
                  'connect with vendors and transport partners.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFFF9800),
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number  $title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF252525),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ..._withSpacing(children),
        ],
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> children) {
    final result = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      if (i != children.length - 1) {
        result.add(const SizedBox(height: 17));
      }
    }

    return result;
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool required = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization capitalization = TextCapitalization.none,
    int? maxLength,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colours.fieldTextColor,
              ),
            ),
            const SizedBox(width: 3),
            const Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: capitalization,
          maxLength: maxLength,
          maxLines: maxLines,
          validator: validator ??
              (required
                  ? (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '$label is required';
                      }
                      return null;
                    }
                  : null),
          style: const TextStyle(
            fontSize: 14,
            color: colours.fieldTextColor,
          ),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
            ),
            prefixIcon: Icon(
              icon,
              color: controller.text.trim().isNotEmpty
                  ? colours.validBorderColor
                  : colours.hintTextColor,
              size: 21,
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
              borderSide: BorderSide(color: Colors.grey.shade300),
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
              borderSide: BorderSide(
                color: colours.focusBorderColor,
                width: 1.5,
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
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  'Product Categories',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colours.fieldTextColor,
                  ),
                ),
                SizedBox(width: 3),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Select all categories that apply to your business.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colours.defaultBorderColor),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: productCategories.map((category) {
                  final selected =
                      controller.selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: selected,
                    showCheckmark: true,
                    selectedColor: const Color(0xFFFFE0B2),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFFE88900),
                    side: BorderSide(
                      color: selected
                          ? colours.primaryColor
                          : colours.defaultBorderColor,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: selected
                          ? const Color(0xFF8A4D00)
                          : const Color(0xFF444444),
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    onSelected: (value) =>
                        controller.toggleCategory(category, value),
                  );
                }).toList(),
              ),
            ),
            if (controller.selectedCategories.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${controller.selectedCategories.length} categor'
                '${controller.selectedCategories.length == 1 ? 'y' : 'ies'} selected',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE88900),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ));
  }

  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required PlatformFile? file,
    required IconData icon,
    required VoidCallback onTap, 
    bool required = false,
  }) {
    final bool hasFile = file != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile
                ? colours.validBorderColor
                : colours.defaultBorderColor,
            width: hasFile ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasFile
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF2E3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: hasFile
                    ? colours.validTextColor
                    : colours.primaryColor,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  text: TextSpan(
    children: [
      TextSpan(
        text: hasFile ? file.name : title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colours.fieldTextColor,
        ),
      ),
      if (required)
        const TextSpan(
          text: ' *',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
    ],
  ),
),
                  const SizedBox(height: 4),
                  Text(
                    hasFile ? 'File selected' : subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: hasFile ? FontWeight.w600 : FontWeight.normal,
                      color: hasFile
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
                horizontal: 11,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: colours.primaryColor),
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


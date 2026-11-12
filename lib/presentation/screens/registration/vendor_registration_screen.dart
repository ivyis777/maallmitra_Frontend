
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/controllers/vendor_registration_controller.dart';
import '../../../core/utils/validators.dart';
import 'vendor_status_screens.dart';
import '../HomePages/vendor_home_page.dart';
class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState
    extends State<VendorRegistrationScreen> {
  static const Color primaryColor = Color(0xFFFF9800);
  static const Color darkColor = Color(0xFF171717);

  // Match the Driver Registration field-state colors.
  static const Color _focusBorderColor = primaryColor;
  static const Color _validBorderColor = Color(0xFF2E7D32);
  static const Color _errorBorderColor = Color(0xFFD32F2F);
  static const Color _defaultBorderColor = Color(0xFFD6D6D6);
  static const Color _fieldTextColor = Color(0xFF263238);
  static const Color _hintTextColor = Color(0xFF757575);
  static const Color _errorTextColor = Color(0xFFD32F2F);

  bool _showFieldErrors = false;
  final Map<TextEditingController, FocusNode> _fieldFocusNodes = {};

  final VendorRegistrationController controller =
      Get.isRegistered<VendorRegistrationController>()
          ? Get.find<VendorRegistrationController>()
          : Get.put(VendorRegistrationController());

  final _formKey = GlobalKey<FormState>();

  final fullName = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final alternateMobile = TextEditingController();

  final businessName = TextEditingController();
  final businessRegistrationNumber = TextEditingController();
  final gstNumber = TextEditingController();
  final yearsInBusiness = TextEditingController();

  final addressLine1 = TextEditingController();
  final addressLine2 = TextEditingController();
  final city = TextEditingController();
  final district = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();

  String? selectedBusinessType;
  String? selectedBusinessCategory;

  String? profilePhotoPath;
  String? gstCertificatePath;
  String? addressProofPath;
  String? transportPermitPath;
  String? businessLicensePath;

//   final businessTypes = const [
//   'PROPRIETORSHIP',
// ];
   final List<Map<String, String>> businessTypes = [
  {'value': 'INDIVIDUAL', 'label': 'Individual'},
  {'value': 'PROPRIETORSHIP', 'label': 'Proprietorship'},
  {'value': 'PARTNERSHIP', 'label': 'Partnership'},
  {'value': 'PRIVATE_LIMITED', 'label': 'Private Limited'},
  {'value': 'LLP', 'label': 'Limited Liability Partnership'},
  {'value': 'OTHER', 'label': 'Other'},
];

final List<Map<String, String>> businessCategories = [
  {'value': 'GOODS_TRANSPORT', 'label': 'Goods Transport'},
  {'value': 'TRUCK_RENTAL', 'label': 'Truck Rental'},
  {'value': 'LOGISTICS', 'label': 'Logistics'},
  {'value': 'PACKERS_MOVERS', 'label': 'Packers and Movers'},
  {'value': 'OTHER', 'label': 'Other'},
];
 
//  final businessCategories = const [
//   'GOODS_TRANSPORT',
// ];
  @override
  void dispose() {
    for (final focusNode in _fieldFocusNodes.values) {
      focusNode.dispose();
    }
    fullName.dispose();
    email.dispose();
    mobile.dispose();
    alternateMobile.dispose();
    businessName.dispose();
    businessRegistrationNumber.dispose();
    gstNumber.dispose();
    yearsInBusiness.dispose();
    addressLine1.dispose();
    addressLine2.dispose();
    city.dispose();
    district.dispose();
    state.dispose();
    pincode.dispose();
    super.dispose();
  }

  Future<void> pickDocument(
    String title,
    void Function(String?) onSelected,
  ) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      
      );

      if (!mounted || result == null || result.isEmpty) return;

      final selectedFile = result.single;
      final path = selectedFile.path;

      if (path == null || path.trim().isEmpty) {
        _showMessage('Could not access the selected file. Please choose it again.');
        return;
      }

      setState(() => onSelected(path));
      debugPrint('$title selected: $path');
    } catch (e, stackTrace) {
      debugPrint('Error selecting $title: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      _showMessage('Unable to select $title. Please try again.');
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

  Widget requiredLabel(String label) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _fieldTextColor,
        ),
        children: [
          TextSpan(text: label),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: _errorTextColor),
          ),
        ],
      ),
    );
  }

  String? _validateField(
    String label,
    String? value,
    String? Function(String?)? validator,
  ) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label is required.';
    return validator?.call(text);
  }

  String? _firstFormError() {
    // Keep this order identical to the visible form order.
    final checks = <String? Function()>[
      () => _validateField('Full Name', fullName.text, (v) => Validators.name(v ?? '')),
      () => _validateField('Email Address', email.text, (v) => Validators.email(v ?? '')),
      () => _validateField('Mobile Number', mobile.text, (v) => Validators.mobile(v ?? '')),
      () => _validateField('Alternate Mobile Number', alternateMobile.text, (v) => Validators.mobile(v ?? '')),
      () => _validateField('Business Name', businessName.text, (v) => Validators.companyName(v ?? '')),
      () => selectedBusinessType == null ? 'Business Type is required.' : null,
      () => selectedBusinessCategory == null ? 'Business Category is required.' : null,
      () => _validateField('GST Number', gstNumber.text, (v) => Validators.gstNumber(v ?? '')),
      () => _validateField('Business Registration Number', businessRegistrationNumber.text, (v) => Validators.companyRegistrationNumber(v ?? '')),
      () => _validateField('Years in Business', yearsInBusiness.text, (v) {
        final error = Validators.required(v ?? '');
        if (error != null) return error;
        final years = int.tryParse(v!.trim());
        return years == null || years < 0 ? 'Enter a valid number of years' : null;
      }),
      () => _validateField('Address Line 1', addressLine1.text, (v) => Validators.address(v ?? '')),
      () => _validateField('Address Line 2', addressLine2.text, (v) => Validators.address(v ?? '')),
      () => _validateField('City', city.text, (v) => Validators.locationName(v ?? '', field: 'City')),
      () => _validateField('District', district.text, (v) => Validators.locationName(v ?? '', field: 'District')),
      () => _validateField('State', state.text, (v) => Validators.locationName(v ?? '', field: 'State')),
      () => _validateField('PIN Code', pincode.text, (v) => Validators.pinCode(v ?? '')),
    ];

    for (final check in checks) {
      final error = check();
      if (error != null) return error;
    }
    return null;
  }

  Widget sectionHeader(String number, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(
    String label,
    TextEditingController textController, {
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    // Keep one FocusNode per controller so focus changes rebuild the border.
    final focusNode = _fieldFocusNodes.putIfAbsent(
      textController,
      () => FocusNode(),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: AnimatedBuilder(
        animation: Listenable.merge([focusNode, textController]),
        builder: (context, child) {
          final value = textController.text;
          final hasValue = value.trim().isNotEmpty;
          final currentError = !hasValue
              ? '$label is required.'
              : validator?.call(value);
          final isValid = hasValue && currentError == null;
          final hasError = _showFieldErrors && currentError != null;

          final borderColor = hasError
              ? _errorBorderColor
              : focusNode.hasFocus
                  ? _focusBorderColor
                  : isValid
                      ? _validBorderColor
                      : _defaultBorderColor;

          OutlineInputBorder outline(Color color, {double width = 1}) =>
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: color, width: width),
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              requiredLabel(label),
              const SizedBox(height: 7),
              TextFormField(
                controller: textController,
                focusNode: focusNode,
                keyboardType: keyboardType,
                autovalidateMode: _showFieldErrors
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                validator: (value) =>
                    _validateField(label, value, validator),
                maxLines: maxLines,
                onChanged: (_) {
                  // Rebuild the screen so the valid/invalid border updates.
                  setState(() {});
                },
                style: const TextStyle(
                  color: _fieldTextColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: hint ?? 'Enter $label',
                  hintStyle: const TextStyle(color: _hintTextColor),
                  prefixIcon: Icon(
                    icon,
                    color: hasError
                        ? _errorTextColor
                        : hasValue
                            ? _validBorderColor
                            : _hintTextColor,
                    size: 21,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: outline(_defaultBorderColor),
                  enabledBorder: outline(borderColor),
                  focusedBorder: outline(_focusBorderColor, width: 1.5),
                  errorBorder: outline(_errorBorderColor),
                  focusedErrorBorder: outline(_errorBorderColor, width: 1.5),
                  // The inline error is rendered manually below the field.
                  // Keep Flutter's built-in error slot collapsed to avoid duplicates.
                  errorStyle: const TextStyle(
                    fontSize: 0,
                    height: 0,
                  ),
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    currentError!,
                    style: const TextStyle(
                      color: _errorTextColor,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }  
Widget dropdownField({
  required String label,
  required IconData icon,
  required String? value,
  required List<Map<String, String>> items,
  required void Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        requiredLabel(label),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          autovalidateMode: _showFieldErrors
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (value) => value == null || value.trim().isEmpty
              ? '$label is required.'
              : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _hintTextColor, size: 21),
            errorStyle: const TextStyle(
              color: _errorTextColor,
              fontSize: 12,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _defaultBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _defaultBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: _focusBorderColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _errorBorderColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: _errorBorderColor,
                width: 1.5,
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value']!,
              child: Text(item['label']!),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}


  Widget uploadBox({
    required String title,
    required String description,
    required String? path,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final selected = path != null && path.trim().isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? _validBorderColor : _defaultBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                requiredLabel(title),
                const SizedBox(height: 5),
                Text(
                  selected ? path.split(RegExp(r'[/\\]')).last : description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color:  _hintTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(
              Icons.upload_file,
              size: 16,
              color:  primaryColor,
            ),
            label: Text(
              selected ? 'Change File' : 'Choose File',
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color:  primaryColor,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(
                color:  primaryColor,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(0, 42),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitRegistration() async {
    FocusScope.of(context).unfocus();

    final firstError = _firstFormError();
    setState(() => _showFieldErrors = true);
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      _showMessage(firstError ?? 'Please check the entered details.');
      return;
    }

    final missingDocuments = <String>[];
    if (profilePhotoPath == null || profilePhotoPath!.trim().isEmpty) {
      missingDocuments.add('Profile Photo');
    }
    if (gstCertificatePath == null || gstCertificatePath!.trim().isEmpty) {
      missingDocuments.add('GST Certificate');
    }
    if (addressProofPath == null || addressProofPath!.trim().isEmpty) {
      missingDocuments.add('Business Address Proof');
    }
    if (transportPermitPath == null || transportPermitPath!.trim().isEmpty) {
      missingDocuments.add('Transport Permit');
    }
    if (businessLicensePath == null || businessLicensePath!.trim().isEmpty) {
      missingDocuments.add('Business License');
    }
    if (missingDocuments.isNotEmpty) {
      _showMessage('Please upload: ${missingDocuments.join(', ')}.');
      return;
    }
    
    debugPrint('========== VENDOR DOCUMENT PATHS ==========');
    debugPrint('Profile Photo: $profilePhotoPath');
    debugPrint('GST Certificate: $gstCertificatePath');
    debugPrint('Address Proof: $addressProofPath');
    debugPrint('Transport Permit: $transportPermitPath');
    debugPrint('Business License: $businessLicensePath');
    debugPrint('===========================================');
    debugPrint('Selected business type: $selectedBusinessType');
debugPrint('Selected business category: $selectedBusinessCategory');

    final success = await controller.registerVendor(
      fullName: fullName.text,
      email: email.text,
      mobileNumber: mobile.text,
      alternateMobileNumber: alternateMobile.text,
      businessName: businessName.text,
      businessType: selectedBusinessType!,
      businessCategory: selectedBusinessCategory!,
      gstNumber: gstNumber.text,
      businessRegistrationNumber: businessRegistrationNumber.text,
      yearsInBusiness: yearsInBusiness.text,
      addressLine1: addressLine1.text,
      addressLine2: addressLine2.text,
      city: city.text,
      district: district.text,
      state: state.text,
      pincode: pincode.text,
      profilePhotoPath: profilePhotoPath,
      gstCertificatePath: gstCertificatePath,
      addressProofPath: addressProofPath,
      transportPermitDocumentPath: transportPermitPath,
      businessLicensePath: businessLicensePath,
    );

    if (!mounted) return;

    if (!success) {
      _showMessage(
        controller.errorMessage.value.isNotEmpty
            ? controller.errorMessage.value
            : 'Unable to submit vendor registration. Please try again.',
      );
      return;
    }

    final response = controller.vendorResponse.value;
    final vendor = response?.data;

    if (vendor == null) {
      _showMessage(
        'Your registration was submitted, but vendor details could not be loaded. Please log in to check your status.',
      );
      return;
    }

    final status = (vendor.status.isNotEmpty
            ? vendor.status
            : controller.registrationStatus.value)
        .trim()
        .toLowerCase();

    final profile = <String, dynamic>{
      'vendor_id': vendor.vendorId,
      'full_name': vendor.fullName,
      'email': vendor.email,
      'mobile_number': vendor.mobileNumber,
      'alternate_mobile_number': vendor.alternateMobileNumber,
      'business_name': vendor.businessName,
      'business_type': vendor.businessType,
      'business_category': vendor.businessCategory,
      'gst_number': vendor.gstNumber,
      'business_registration_number': vendor.businessRegistrationNumber,
      'years_in_business': vendor.yearsInBusiness,
      'address_line1': vendor.addressLine1,
      'address_line2': vendor.addressLine2,
      'city': vendor.city,
      'district': vendor.district,
      'state': vendor.state,
      'pincode': vendor.pincode,
      'profile_photo': vendor.profilePhoto,
      'gst_certificate': vendor.gstCertificate,
      'address_proof': vendor.addressProof,
      'transport_permit_document': vendor.transportPermitDocument,
      'business_license': vendor.businessLicense,
      'status': status,
      'registration_status': status,
      'rejection_reason': vendor.rejectionReason,
      'reviewed_at': vendor.reviewedAt,
      'created_at': vendor.createdAt,
      'updated_at': vendor.updatedAt,
    };

    if (status == 'pending') {
      Get.offAll(() => VendorPendingScreen(profile: profile));
    } else if (status == 'rejected' || status == 'reject') {
      Get.offAll(() => VendorRejectedScreen(profile: profile));
    } else if (status == 'approved' || status == 'approve') {
      Get.offAll(() => const VendorHomePage());
    } else {
      _showMessage(
        'Your vendor registration was submitted. The current status is not recognized; please log in to check it.',
      );
    }
    debugPrint('========== VENDOR PROFILE DATA ==========');
debugPrint('Profile Photo: ${profile['profile_photo']}');
debugPrint('GST Certificate: ${profile['gst_certificate']}');
debugPrint('Address Proof: ${profile['address_proof']}');
debugPrint(
  'Transport Permit: ${profile['transport_permit_document']}',
);
debugPrint('Business License: ${profile['business_license']}');
debugPrint('=========================================');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Vendor Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
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
                    width: 62,
                    height: 62,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'assets/images/vendor.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.storefront,
                        color: primaryColor,
                        size: 34,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vendor Details',
                          style: TextStyle(
                            color: const Color(0xFF263238),
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Fill in your personal and business information',
                          style: TextStyle(
                            color: const Color(0xFF666666),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            sectionHeader('1', 'Personal Details'),
            textField(
              'Full Name',
              fullName,
              icon: Icons.person_outline,
              validator: (value) => Validators.name(value ?? ''),
            ),
            textField(
              'Email Address',
              email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value ?? ''),
            ),
            textField(
              'Mobile Number',
              mobile,
              icon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => Validators.mobile(value ?? ''),
            ),
            textField(
              'Alternate Mobile Number',
              alternateMobile,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => Validators.mobile(value ?? ''),
            ),

            sectionHeader('2', 'Business Details'),
            textField(
              'Business Name',
              businessName,
              icon: Icons.storefront_outlined,
              validator: (value) => Validators.companyName(value ?? ''),
            ),

            dropdownField(
  label: 'Business Type',
  icon: Icons.business_outlined,
  value: selectedBusinessType,
  items: businessTypes,
  onChanged: (value) {
    setState(() => selectedBusinessType = value);
  },
),

dropdownField(
  label: 'Business Category',
  icon: Icons.category_outlined,
  value: selectedBusinessCategory,
  items: businessCategories,
  onChanged: (value) {
    setState(() => selectedBusinessCategory = value);
  },
),
            textField(
              'GST Number',
              gstNumber,
              icon: Icons.receipt_long_outlined,
              validator: (value) => Validators.gstNumber(value ?? ''),
            ),
            textField(
              'Business Registration Number',
              businessRegistrationNumber,
              icon: Icons.badge_outlined,
              validator: (value) => Validators.companyRegistrationNumber(value ?? ''),
            ),
            textField(
              'Years in Business',
              yearsInBusiness,
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                final requiredError = Validators.required(value ?? '');
                if (requiredError != null) return requiredError;
                final years = int.tryParse(value!.trim());
                if (years == null || years < 0) {
                  return 'Enter a valid number of years';
                }
                return null;
              },
            ),

            sectionHeader('3', 'Business Address'),
            textField(
              'Address Line 1',
              addressLine1,
              icon: Icons.location_on_outlined,
              validator: (value) => Validators.address(value ?? ''),
            ),
            textField(
              'Address Line 2',
              addressLine2,
              icon: Icons.location_on_outlined,
              validator: (value) => Validators.address(value ?? ''),
            ),
            textField(
              'City',
              city,
              icon: Icons.location_city_outlined,
              validator: (value) => Validators.locationName(
                value ?? '',
                field: 'City',
              ),
            ),
            textField(
              'District',
              district,
              icon: Icons.map_outlined,
              validator: (value) => Validators.locationName(
                value ?? '',
                field: 'District',
              ),
            ),
            textField(
              'State',
              state,
              icon: Icons.account_balance_outlined,
              validator: (value) => Validators.locationName(
                value ?? '',
                field: 'State',
              ),
            ),
            textField(
              'PIN Code',
              pincode,
              icon: Icons.pin_drop_outlined,
              keyboardType: TextInputType.number,
              validator: (value) => Validators.pinCode(value ?? ''),
            ),

            sectionHeader('4', 'Requirements'),
            const Text(
              'Upload the required documents for verification.',
              style: TextStyle(color: _hintTextColor, fontSize: 12),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
            uploadBox(
              title: 'Profile Photo',
              description: 'Select JPG or PNG',
              path: profilePhotoPath,
              icon: Icons.person_outline,
              onTap: () => pickDocument(
                'Profile Photo',
                (path) => profilePhotoPath = path,
              ),
            ),
            uploadBox(
              title: 'GST Certificate',
              description: 'Select PDF or image',
              path: gstCertificatePath,
              icon: Icons.description_outlined,
              onTap: () => pickDocument(
                'GST Certificate',
                (path) => gstCertificatePath = path,
              ),
            ),
            uploadBox(
              title: 'Business Address Proof',
              description: 'Select PDF or image',
              path: addressProofPath,
              icon: Icons.verified_user_outlined,
              onTap: () => pickDocument(
                'Business Address Proof',
                (path) => addressProofPath = path,
              ),
            ),
            uploadBox(
              title: 'Transport Permit',
              description: 'Select PDF or image if applicable',
              path: transportPermitPath,
              icon: Icons.badge_outlined,
              onTap: () => pickDocument(
                'Transport Permit',
                (path) => transportPermitPath = path,
              ),
            ),
            uploadBox(
              title: 'Business License',
              description: 'Select PDF or image',
              path: businessLicensePath,
              icon: Icons.assignment_outlined,
              onTap: () => pickDocument(
                'Business License',
                (path) => businessLicensePath = path,
              ),
            ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'REGISTER VENDOR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

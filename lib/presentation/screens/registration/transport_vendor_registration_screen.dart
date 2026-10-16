import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/storage/colors.dart';

class TransportVendorRegistrationScreen extends StatefulWidget {
  const TransportVendorRegistrationScreen({
    super.key,
  });

  @override
  State<TransportVendorRegistrationScreen> createState() =>
      _TransportVendorRegistrationScreenState();
}

class _TransportVendorRegistrationScreenState
    extends State<TransportVendorRegistrationScreen> {

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController companyNameController =
      TextEditingController();

  final TextEditingController contactPersonController =
      TextEditingController();

  final TextEditingController mobileController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController fleetSizeController =
      TextEditingController();

  final TextEditingController operatingLocationsController =
      TextEditingController();

  final TextEditingController gstController =
      TextEditingController();

  final TextEditingController panController =
      TextEditingController();

  final TextEditingController registrationNumberController =
      TextEditingController();

  // ============================================================
  // DROPDOWN VALUES
  // ============================================================

  String? selectedBusinessType;
  String? selectedVehicleType;

  // ============================================================
  // FILE NAMES - UI ONLY
  // ============================================================

  String? gstCertificate;
  String? panCard;
  String? companyRegistration;
  String? cancelledCheque;

  @override
  void dispose() {
    companyNameController.dispose();
    contactPersonController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    fleetSizeController.dispose();
    operatingLocationsController.dispose();
    gstController.dispose();
    panController.dispose();
    registrationNumberController.dispose();

    super.dispose();
  }

  // ============================================================
  // TEMPORARY FILE SELECTION
  // ============================================================

  void _selectFile(String type) {
    setState(() {
      switch (type) {
        case 'gst':
          gstCertificate = 'GST_Certificate.pdf';
          break;

        case 'pan':
          panCard = 'PAN_Card.jpg';
          break;

        case 'registration':
          companyRegistration = 'Company_Registration.pdf';
          break;

        case 'cheque':
          cancelledCheque = 'Cancelled_Cheque.jpg';
          break;
      }
    });
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
          'Transport Vendor Registration',
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
              // BUSINESS DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '1',
                title: 'Business Details',
              ),

              const SizedBox(height: 14),

              // COMPANY NAME

              _fieldLabel(
                'Company / Vendor Name',
                required: true,
              ),

              _buildTextField(
                controller: companyNameController,
                hint: 'Enter company or vendor name',
                icon: Icons.business_outlined,
                maxLength: 100,
                textCapitalization:
                    TextCapitalization.words,
              ),

              const SizedBox(height: 16),

              // CONTACT PERSON

              _fieldLabel(
                'Contact Person Name',
                required: true,
              ),

              _buildTextField(
                controller: contactPersonController,
                hint: 'Enter contact person name',
                icon: Icons.person_outline,
                maxLength: 100,
                textCapitalization:
                    TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z ]'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // BUSINESS TYPE

              _fieldLabel(
                'Business Type',
                required: true,
              ),

              _buildDropdown(
                value: selectedBusinessType,
                hint: 'Select business type',
                icon: Icons.category_outlined,
                items: const [
                  'Transport Company',
                  'Fleet Owner',
                  'Transport Contractor',
                  'Logistics Provider',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedBusinessType = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 2
              // CONTACT DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '2',
                title: 'Contact Details',
              ),

              const SizedBox(height: 14),

              // MOBILE

              _fieldLabel(
                'Mobile Number',
                required: true,
              ),

              _buildTextField(
                controller: mobileController,
                hint: 'Enter 10 digit mobile number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              // EMAIL

              _fieldLabel(
                'Email Address',
                required: true,
              ),

              _buildTextField(
                controller: emailController,
                hint: 'Enter business email address',
                icon: Icons.email_outlined,
                keyboardType:
                    TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // ADDRESS

              _fieldLabel(
                'Business Address',
                required: true,
              ),

              _buildTextField(
                controller: addressController,
                hint: 'Enter complete business address',
                icon: Icons.location_on_outlined,
                maxLength: 250,
                maxLines: 4,
                textCapitalization:
                    TextCapitalization.sentences,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 3
              // TRANSPORT DETAILS
              // ==================================================

              _buildSectionHeader(
                number: '3',
                title: 'Transport Details',
              ),

              const SizedBox(height: 14),

              // VEHICLE TYPE

              _fieldLabel(
                'Primary Vehicle Type',
                required: true,
              ),

              _buildDropdown(
                value: selectedVehicleType,
                hint: 'Select vehicle type',
                icon: Icons.local_shipping_outlined,
                items: const [
                  'Mini Truck',
                  'Light Commercial Vehicle',
                  'Medium Truck',
                  'Heavy Truck',
                  'Trailer',
                  'Container Truck',
                  'Multi-Axle Truck',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedVehicleType = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              // FLEET SIZE

              _fieldLabel(
                'Fleet Size',
                required: true,
              ),

              _buildTextField(
                controller: fleetSizeController,
                hint: 'Enter number of vehicles',
                icon: Icons.directions_car_outlined,
                keyboardType:
                    TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              // OPERATING LOCATIONS

              _fieldLabel(
                'Operating Locations',
                required: true,
              ),

              _buildTextField(
                controller:
                    operatingLocationsController,
                hint:
                    'Enter cities / states where you operate',
                icon: Icons.map_outlined,
                maxLines: 3,
                maxLength: 250,
                textCapitalization:
                    TextCapitalization.words,
              ),

              const SizedBox(height: 22),

              // ==================================================
              // SECTION 4
              // BUSINESS DOCUMENTS
              // ==================================================

              _buildSectionHeader(
                number: '4',
                title: 'Business Documents',
              ),

              const SizedBox(height: 14),

              // GST

              _fieldLabel(
                'GST Number',
                required: false,
              ),

              _buildTextField(
                controller: gstController,
                hint:
                    'Enter 15 digit GST number (Optional)',
                icon: Icons.receipt_long_outlined,
                maxLength: 15,
                textCapitalization:
                    TextCapitalization.characters,
              ),

              const SizedBox(height: 8),

              Text(
                'GST certificate can be uploaded if the vendor is GST registered.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 16),

              // GST FILE

              _buildUploadBox(
                title: 'GST Certificate',
                subtitle:
                    'PDF, JPG, PNG (Max 5 MB)',
                fileName: gstCertificate,
                icon: Icons.receipt_long_outlined,
                onTap: () {
                  _selectFile('gst');
                },
              ),

              const SizedBox(height: 12),

              // PAN

              _fieldLabel(
                'PAN Number',
                required: true,
              ),

              _buildTextField(
                controller: panController,
                hint: 'Enter PAN number',
                icon: Icons.badge_outlined,
                maxLength: 10,
                textCapitalization:
                    TextCapitalization.characters,
              ),

              const SizedBox(height: 12),

              // PAN CARD

              _buildUploadBox(
                title: 'PAN Card',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName: panCard,
                icon: Icons.credit_card_outlined,
                onTap: () {
                  _selectFile('pan');
                },
              ),

              const SizedBox(height: 16),

              // COMPANY REGISTRATION NUMBER

              _fieldLabel(
                'Company Registration Number',
                required: false,
              ),

              _buildTextField(
                controller:
                    registrationNumberController,
                hint:
                    'Enter registration number (if applicable)',
                icon: Icons.assignment_outlined,
                textCapitalization:
                    TextCapitalization.characters,
              ),

              const SizedBox(height: 12),

              // COMPANY REGISTRATION

              _buildUploadBox(
                title: 'Company Registration Certificate',
                subtitle:
                    'PDF, JPG, PNG (Max 5 MB)',
                fileName: companyRegistration,
                icon: Icons.domain_verification_outlined,
                onTap: () {
                  _selectFile('registration');
                },
              ),

              const SizedBox(height: 12),

              // CANCELLED CHEQUE

              _buildUploadBox(
                title: 'Cancelled Cheque / Bank Proof',
                subtitle:
                    'JPG, PNG, PDF (Max 5 MB)',
                fileName: cancelledCheque,
                icon: Icons.account_balance_outlined,
                onTap: () {
                  _selectFile('cheque');
                },
              ),

              const SizedBox(height: 28),

              // ==================================================
              // REGISTER BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: () {
                    // API WILL BE CONNECTED LATER

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Transport vendor registration API will be connected later.',
                        ),
                      ),
                    );
                  },

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

                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Text(
                        'Register Vendor',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(width: 10),

                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Please make sure all business information '
                  'and documents are correct before registering.',
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
          color: const Color(0xFFFFCC80),
        ),
      ),

      child: Row(
        children: [

          // Container(
          //   width: 68,
          //   height: 68,

          //   decoration: const BoxDecoration(
          //     color: Color(0xFFFFB52E),
          //     shape: BoxShape.circle,
          //   ),

          //   child: const Icon(
          //     Icons.local_shipping_outlined,
          //     size: 40,
          //     color: Colors.white,
          //   ),
          // ),
Container(
  width: 68,
  height: 68,

  decoration: BoxDecoration(
    color: const Color(0xFFFFF2E3),
    shape: BoxShape.circle,
  ),

  child: ClipOval(
    child: Image.asset(
      'assets/images/vendor.png',
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
                  'Join as a Transport Vendor',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF202020),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Register your transport business and '
                  'start connecting with customers',
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
              color: colours.primaryColor,
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
              color: Color(0xFF263238),
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
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      inputFormatters: inputFormatters,

      maxLength: maxLength,

      maxLines: maxLines,

      textCapitalization: textCapitalization,

      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF263238),
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
            color: Colors.grey.shade300,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFFF8500),
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
          color: Colors.grey.shade300,
        ),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,

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
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,

              decoration: BoxDecoration(
                color: const Color(0xFFFFF2E3),
                borderRadius: BorderRadius.circular(12),
              ),

              child: Icon(
                icon,
                color: const Color(0xFFFF8500),
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
                      color: Colors.grey.shade600,
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
                color: const Color(0xFFFFF7ED),

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
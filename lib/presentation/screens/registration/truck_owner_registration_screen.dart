import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/storage/colors.dart';
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

  // ============================================================
  // OWNER CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController permanentAddressController =
      TextEditingController();

  final TextEditingController currentAddressController =
      TextEditingController();

  // ============================================================
  // DRIVER CONTROLLERS
  // ============================================================

  final TextEditingController licenceNumberController =
      TextEditingController();

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
  DateTime? dlIssuedDate;
  DateTime? dlExpiredDate;

  // ============================================================
  // FILE NAMES - UI ONLY
  // ============================================================

  String? identityDocument;

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
    permanentAddressController.dispose();
    currentAddressController.dispose();
    licenceNumberController.dispose();

    super.dispose();
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
  // TEMPORARY FILE SELECTION
  // ============================================================

  void _selectFile(String type) {
    setState(() {
      switch (type) {
        case 'identity':
          identityDocument = 'Identity_Document.jpg';
          break;

        case 'medical':
          medicalCertificate = 'Medical_Certificate.pdf';
          break;

        case 'police':
          policeCertificate = 'Police_Verification.pdf';
          break;

        case 'photo':
          driverPhoto = 'Driver_Photo.jpg';
          break;

        case 'aadharFront':
          aadharFront = 'Aadhar_Front.jpg';
          break;

        case 'aadharBack':
          aadharBack = 'Aadhar_Back.jpg';
          break;

        case 'dlFront':
          dlFront = 'Driving_Licence_Front.jpg';
          break;

        case 'dlBack':
          dlBack = 'Driving_Licence_Back.jpg';
          break;
      }
    });
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
      backgroundColor: const Color(0xFFF8F8F8),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF8500),
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

              _buildUploadBox(
                title: 'PAN / Aadhaar Card',
                subtitle:
                    'JPG, PNG (Max 2 MB)',
                fileName: identityDocument,
                icon: Icons.badge_outlined,
                onTap: () {
                  _selectFile('identity');
                },
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

                _buildDropdown(
                  value: selectedDlType,
                  hint: 'Select licence type',
                  icon: Icons.directions_car_outlined,
                  items: const [
                    'LMV',
                    'HMV',
                    'Transport',
                    'Commercial',
                    'Heavy Transport',
                    'Other',
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDlType = value;
                    });
                  },
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
                  fileName: medicalCertificate,
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
                  fileName: policeCertificate,
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
                  fileName: driverPhoto,
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
                  fileName: aadharFront,
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
                  fileName: aadharBack,
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
                  fileName: dlFront,
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
                  fileName: dlBack,
                  icon:
                      Icons.credit_card_outlined,
                  onTap: () {
                    _selectFile('dlBack');
                  },
                ),

                const SizedBox(height: 22),
              ],

              // ==================================================
              // REGISTER
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  // onPressed: () {

                  //   // API WILL BE CONNECTED LATER

                  //   ScaffoldMessenger.of(context)
                  //       .showSnackBar(
                  //     const SnackBar(
                  //       content: Text(
                  //         'Truck owner registration API will be connected later.',
                  //       ),
                  //     ),
                  //   );
                  // },
onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const OwnerHomePage(),
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
                        'Register Truck Owner',
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
              color: const Color(0xFFFFF2E3),
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
            color: colours.primaryColor,
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
            color: Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            Icon(
              Icons.calendar_month_outlined,
              color: Colors.blueGrey.shade500,
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
                      : const Color(0xFF263238),
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
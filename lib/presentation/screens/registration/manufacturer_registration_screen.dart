import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/storage/colors.dart';
import '../HomePages/business_home_page.dart';  
class ManufacturerRegistrationScreen extends StatefulWidget {
  const ManufacturerRegistrationScreen({
    super.key,
  });

  @override
  State<ManufacturerRegistrationScreen> createState() =>
      _ManufacturerRegistrationScreenState();
}

class _ManufacturerRegistrationScreenState
    extends State<ManufacturerRegistrationScreen> {
  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController companyNameController =
      TextEditingController();

  final TextEditingController ownerNameController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController monthlyTripsController =
      TextEditingController();

  final TextEditingController gstController =
      TextEditingController();

  // ============================================================
  // LOCAL UI STATE ONLY
  // API WILL BE CONNECTED LATER
  // ============================================================

  String? gstFileName;
  String? licenseFileName;

  @override
  void dispose() {
    companyNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    monthlyTripsController.dispose();
    gstController.dispose();

    super.dispose();
  }

  // ============================================================
  // UI
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
        backgroundColor: const Color(0xFFFF9800),
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
          'Manufacturer Registration',
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
              // HEADER CARD
              // ==================================================

              _buildHeaderCard(),

              const SizedBox(height: 22),

              // ==================================================
              // COMPANY NAME
              // ==================================================

              _fieldLabel(
                'Company Name',
                required: true,
              ),

              _buildTextField(
                controller: companyNameController,
                hint: 'Enter company name',
                icon: Icons.business_outlined,
                maxLength: 100,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // OWNER NAME
              // ==================================================

              _fieldLabel(
                'Owner Name',
                required: true,
              ),

              _buildTextField(
                controller: ownerNameController,
                hint: 'Enter owner name',
                icon: Icons.person_outline,
                maxLength: 100,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // PHONE NUMBER
              // ==================================================

              _fieldLabel(
                'Phone Number',
                required: true,
              ),

              _buildTextField(
                controller: phoneController,
                hint: 'Enter 10 digit mobile number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 18),

              // ==================================================
              // EMAIL
              // ==================================================

              _fieldLabel(
                'Email',
                required: true,
              ),

              _buildTextField(
                controller: emailController,
                hint: 'Enter your email address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // BUSINESS ADDRESS
              // ==================================================

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
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 18),

              // ==================================================
              // MONTHLY TRIPS
              // ==================================================

              _fieldLabel(
                'Monthly Trips',
                required: true,
              ),

              _buildTextField(
                controller: monthlyTripsController,
                hint: 'Enter monthly trips',
                icon: Icons.local_shipping_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 18),

              // ==================================================
              // GST NUMBER
              // ==================================================

              _fieldLabel(
                'GST Number',
                required: false,
                suffix: '(Optional)',
              ),

              _buildTextField(
                controller: gstController,
                hint: 'Enter 15 digit GST number',
                icon: Icons.description_outlined,
                maxLength: 15,
                textCapitalization: TextCapitalization.characters,
              ),

              const SizedBox(height: 8),

              Text(
                'GST certificate is required when GST number is provided',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // GST CERTIFICATE
              // ==================================================

              _buildUploadBox(
                title: 'GST Certificate Upload',
                subtitle: 'Required if GST Number is provided',
                fileName: gstFileName,
                onTap: () {
                  // FILE PICKER WILL BE CONNECTED LATER
                  setState(() {
                    gstFileName = 'GST_Certificate.pdf';
                  });
                },
              ),

              const SizedBox(height: 18),

              // ==================================================
              // BUSINESS LICENSE
              // ==================================================

              _buildUploadBox(
                title: 'Business License Upload',
                subtitle: 'PDF, JPG, PNG (Max 5 MB)',
                fileName: licenseFileName,
                onTap: () {
                  // FILE PICKER WILL BE CONNECTED LATER
                  setState(() {
                    licenseFileName = 'Business_License.pdf';
                  });
                },
              ),

              const SizedBox(height: 30),

              // ==================================================
              // REGISTER BUTTON
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  // onPressed: () {
                  //   // =================================================
                  //   // API WILL BE CONNECTED HERE LATER
                  //   // =================================================

                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       content: Text(
                  //         'Registration API will be connected later.',
                  //       ),
                  //     ),
                  //   );
                  // },

                  onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const BusinessHomePage(),
    ),
  );
},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.primaryColor  ,
                    foregroundColor: colours.buttonTextColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  'By registering, you agree to our terms and conditions.',
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
            Color(0xFFFFF3E0),
            Color(0xFFFFE8CC),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // Factory illustration placeholder
          // Container(
          //   width: 64,
          //   height: 64,

          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(16),
          //   ),

          //   child: const Icon(
          //     Icons.factory_outlined,
          //     size: 38,
          //     color: Color(0xFFFF9800),
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
      'assets/images/factory.png',
      width: 68,
      height: 68,
      fit: BoxFit.cover,
    ),
  ),
),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  'Create your Manufacturer Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Register your business and start connecting '
                  'with trusted transport partners',
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
  // FIELD LABEL
  // ============================================================

  Widget _fieldLabel(
    String title, {
    bool required = false,
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Row(
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF252525),
            ),
          ),

          if (required)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (suffix != null) ...[
            const SizedBox(width: 5),

            Text(
              suffix,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
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
        color: Color(0xFF222222),
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
        ),

        prefixIcon: Icon(
          icon,
          color: colours.primaryColor,
          size: 21,
        ),

        filled: true,

        fillColor: Colors.white,

        counterText: '',

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 16,
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
            color: Color(0xFFFF9800),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILE UPLOAD BOX
  // ============================================================

  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF252525),
          ),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: onTap,

          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(14),

              border: Border.all(
                color: const Color(0xFFFFB74D),
                width: 1.2,
              ),
            ),

            child: Row(
              children: [

                // ==================================================
                // DOCUMENT ICON
                // ==================================================

                Container(
                  width: 46,
                  height: 46,

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(
                    Icons.upload_file_outlined,
                    color: colours.primaryColor,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                // ==================================================
                // FILE INFORMATION
                // ==================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        fileName ?? title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: fileName == null
                              ? const Color(0xFF333333)
                              : const Color(0xFFFF9800),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        fileName == null
                            ? subtitle
                            : 'File selected',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ==================================================
                // CHOOSE FILE BUTTON
                // ==================================================

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(9),
                  ),

                  child: const Text(
                    'Choose File',
                    style: TextStyle(
                      color: colours.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
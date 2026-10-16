
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../HomePages/driver_home_page.dart';
import '../../../data/controllers/login_controller.dart';
import '../../../../core/utils/validators.dart';
import '../admin/admin_driver_screen.dart';
import '../widgets/otp_fields.dart';
import '../RolePage/role_selection_screen.dart';
import '../../../core/storage/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController loginController =
      AuthController();

  AuthController get authController =>
      loginController;

  String? errorMessage;
  String? successMessage;

  final TextEditingController mobileController =
      TextEditingController();

  final List<TextEditingController> otpControllers =
      List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> otpFocusNodes =
      List.generate(
    4,
    (_) => FocusNode(),
  );

  // ============================================================
  // SEND NORMAL OTP
  // ============================================================

  Future<void> sendOtp() async {
    FocusScope.of(context).unfocus();

    final validation = Validators.mobile(
      mobileController.text,
    );

    if (validation != null) {
      setState(() {
        errorMessage = validation;
        successMessage = null;
      });

      return;
    }

    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    await loginController.sendOtp(
      mobileController.text.trim(),
    );

    if (!mounted) return;

    setState(() {});

    // ==========================================================
    // OPEN OTP POPUP ONLY WHEN API WAS SUCCESSFUL
    // ==========================================================

    if (authController.otpVisible.value) {
      _showOtpDialog();
    }
  }

  // ============================================================
  // SEND WHATSAPP OTP
  // ============================================================

  Future<void> sendWhatsAppOtp() async {
    FocusScope.of(context).unfocus();

    final validation = Validators.mobile(
      mobileController.text,
    );

    if (validation != null) {
      setState(() {
        errorMessage = validation;
        successMessage = null;
      });

      return;
    }

    setState(() {
      errorMessage = null;
      successMessage = null;
    });

    await loginController.sendOtp(
      mobileController.text.trim(),
    );

    if (!mounted) return;

    setState(() {});

    // ==========================================================
    // OPEN OTP POPUP ONLY WHEN API WAS SUCCESSFUL
    // ==========================================================

    if (authController.otpVisible.value) {
      _showOtpDialog();
    }
  }

  

Future<void> verifyOtp(BuildContext dialogContext) async {
  FocusScope.of(dialogContext).unfocus();

  // 1. Collect OTP from all input fields
  final otp = otpControllers
      .map((controller) => controller.text)
      .join();

  // 2. Validate OTP
  final validationError = Validators.otp(otp);

  if (validationError != null) {
    if (!mounted) return;

    setState(() {
      errorMessage = validationError;
    });

    return;
  }

  if (!mounted) return;

  setState(() {
    errorMessage = '';
  });

  try {
    // 3. Verify OTP using the API
    final success = await loginController.verifyOtp(
      mobileController.text.trim(),
      otp,
    );

    if (!mounted) return;

    // 4. Stop if verification failed
    if (!success) {
      setState(() {
        errorMessage = 'Invalid OTP. Please try again.';
      });
      return;
    }

    // 5. Read the authenticated user's role
    final role = loginController.userRole.value
        .trim()
        .toLowerCase();

    debugPrint('OTP verification successful');
    debugPrint('ROLE FROM CONTROLLER: "$role"');

    // 6. Navigate according to the user's role.
    // Get.offAll removes the OTP dialog and previous pages.
    switch (role) {
      case 'admin':
        debugPrint('Opening AdminDriverScreen');

        Get.offAll(
          () => const AdminDriverScreen(),
        );
        break;

      case 'driver':
        debugPrint('Opening DriverHomePage');

        Get.offAll(
          () => const DriverHomePage(),
        );
    
  break;
      

      case 'owner':
        Get.offAllNamed('/owner-home');
        break;

      case 'vendor':
        Get.offAllNamed('/vendor-home');
        break;

      case 'manufacturer':
        Get.offAllNamed('/manufacturer-home');
        break;

      // default:
      //   debugPrint('Unknown role: "$role"');

      //   Get.snackbar(
      //     'Login Error',
      //     'Unable to identify your role. Please try again.',
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
     
default:
  if (role.isEmpty) {
    debugPrint(
      'Unregistered mobile. Opening RoleSelectionScreen',
    );

    Get.offAll(
      () => const RoleSelectionScreen(),
    );
  } else {
    debugPrint('Unknown role: "$role"');

    Get.snackbar(
      'Login Error',
      'Unable to identify your role. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  break;


    }
  } catch (e, stackTrace) {
    debugPrint('OTP verification/navigation error: $e');
    debugPrintStack(stackTrace: stackTrace);

    if (!mounted) return;

    setState(() {
      errorMessage = 'Something went wrong. Please try again.';
    });
  }
}
  // ============================================================
  // SHOW OTP POPUP
  // ============================================================
  void _showOtpDialog() {
    for (final controller in otpControllers) {
      controller.clear();
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor:
          Colors.black.withOpacity(0.55),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 30,
          ),
          child: _buildOtpPopup(
            dialogContext,
          ),
        );
      },
    );
  }

  // ============================================================
  // OTP POPUP
  // ============================================================

  Widget _buildOtpPopup(
    BuildContext dialogContext,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        22,
        16,
        22,
        22,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(28),

        border: Border.all(
          color: const Color(0xFFFFE0BF),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.20),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ======================================================
          // CLOSE BUTTON
          // ======================================================

          Align(
            alignment: Alignment.topRight,

            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },

              child: Container(
                width: 36,
                height: 36,

                decoration: BoxDecoration(
                  color:
                      const Color(0xFFFFF1E2),
                  borderRadius:
                      BorderRadius.circular(18),
                ),

                child: const Icon(
                  Icons.close_rounded,
                  color:
                      colours.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),

          const SizedBox(height: 2),

          // ======================================================
          // LOCK ICON
          // ======================================================

          Container(
            width: 68,
            height: 68,

            decoration: BoxDecoration(
              color:
                  const Color(0xFFFFF0DD),
              borderRadius:
                  BorderRadius.circular(22),
            ),

            child: const Icon(
              Icons.lock_outline_rounded,
              color:
                  colours.primaryColor,
              size: 34,
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ENTER OTP
          // ======================================================

          const Text(
            'Enter OTP',

            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: Color(0xFF17232E),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'OTP sent to +91 ${mobileController.text.trim()}',

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7A8790),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // OTP FIELDS
          // ======================================================

          OtpFields(
            controllers: otpControllers,
            focusNodes: otpFocusNodes,
          ),

          const SizedBox(height: 24),

          // ======================================================
          // VERIFY OTP
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 55,

            child: ElevatedButton(
             // onPressed: verifyOtp,
              onPressed: () => verifyOtp(dialogContext),

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    colours.primaryColor,

                foregroundColor:colours.buttonTextColor,

                elevation: 2,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),
              ),

              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(
                    'Login',

                    style: TextStyle(
                      fontSize: colours.buttonFontSize,
                      fontWeight: colours.buttonFontWeight,
                    ),
                  ),

                  SizedBox(width: 10),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 21,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // RESEND OTP
          // ======================================================

          const Text(
            "Didn't receive OTP?",

            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A969E),
            ),
          ),

          const SizedBox(height: 3),

          // TextButton(
          //   onPressed:
          //       authController.isLoading.value
          //           ? null
          //           : () async {

          //               Navigator.of(
          //                 dialogContext,
          //               ).pop();

          //               await sendOtp();
          //             },

          //   child: const Text(
          //     'Resend OTP',

          //     style: TextStyle(
          //       color:
          //           LocalStorage.primaryColor,
          //       fontSize: 14,
          //       fontWeight:
          //           FontWeight.w700,
          //     ),
          //   ),
  
TextButton(
  onPressed:
      authController.isLoading.value
          ? null
          : () async {
              final success =
                  await authController.resendOtp(
                mobileController.text.trim(),
              );

              if (!mounted) return;

              if (success) {
                // Clear the existing OTP fields
                for (final controller
                    in otpControllers) {
                  controller.clear();
                }

                // Keep the OTP popup open
                setState(() {});

                debugPrint(
                  'OTP resent successfully',
                );
              } else {
                debugPrint(
                  'Failed to resend OTP',
                );
              }
            },
  child: const Text(
    'Resend OTP',
    style: TextStyle(
      color: colours.primaryColor,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  ),
),
          
        ],
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    mobileController.dispose();

    for (final controller
        in otpControllers) {
      controller.dispose();
    }

    for (final node in otpFocusNodes) {
      node.dispose();
    }

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // ======================================================
          // BACKGROUND IMAGE
          // ======================================================

          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',

              fit: BoxFit.cover,

              alignment:
                  const Alignment(0, -0.50),
            ),
          ),

          // ======================================================
          // BACKGROUND OVERLAY
          // ======================================================

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,

                  colors: [
                    Colors.white
                        .withOpacity(0.10),

                    Colors.white
                        .withOpacity(0.10),

                    Colors.white
                        .withOpacity(0.15),
                  ],

                  stops: const [
                    0.0,
                    0.50,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // MAIN CONTENT
          // ======================================================

          SafeArea(
            child:
                SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),

              padding:
                  const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                35,
              ),

              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 520,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ==================================================
                      // TOP HEADER
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          // MAALMITRA LOGO

                          RichText(
                            text:
                                const TextSpan(
                              children: [

                                TextSpan(
                                  text: 'Maal',

                                  style:
                                      TextStyle(
                                    fontSize: colours.logoFontSize,
                                    fontWeight:colours.logofontweight,    
                                    color: colours.logoColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Mitra',
                                  style:
                                      TextStyle(
                                    fontSize: colours.logoFontSize,
                                    fontWeight:colours.logofontweight,    
                                    color:
                                        colours.primaryColor, 
                                
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // LANGUAGE

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                0.90,
                              ),

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                30,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                    0.06,
                                  ),
                                  blurRadius: 12,
                                  offset:
                                      const Offset(
                                    0,
                                    5,
                                  ),
                                ),
                              ],
                            ),

                            child: const Row(
                              mainAxisSize:
                                  MainAxisSize.min,

                              children: [

                                Text(
                                  'EN',

                                  style:
                                      TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    color:
                                        Color(
                                      0xFF52616B,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 5,
                                ),

                                Icon(
                                  Icons
                                      .keyboard_arrow_down_rounded,
                                  size: 18,
                                  color:
                                      Color(
                                    0xFF52616B,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 152,
                      ),

                      // ==================================================
                      // WELCOME CARD
                      // ==================================================

                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          20,
                          20,
                          20,
                          20,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                            0.84,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            25,
                          ),

                          border: Border.all(
                            color: Colors.white
                                .withOpacity(
                              0.90,
                            ),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.04,
                              ),
                              blurRadius: 25,
                              offset:
                                  const Offset(
                                0,
                                10,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            // BADGE

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFFFF0DF,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),

                              child:
                                  const Row(
                                mainAxisSize:
                                    MainAxisSize
                                        .min,

                                children: [

                                  Icon(
                                    Icons
                                        .local_shipping_rounded,
                                    size: 16,
                                    color:
                                        colours
                                            .primaryColor,
                                  ),

                                  SizedBox(
                                    width: 6,
                                  ),

                                  Text(
                                    'SMART TRANSPORT',

                                    style:
                                        TextStyle(
                                      fontSize: 10,
                                      fontWeight:
                                          FontWeight
                                              .w800,
                                      letterSpacing:
                                          0.8,
                                      color:
                                          colours
                                              .primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            const Text(
                              'Chaliye',

                              style:
                                  TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .w900,
                                color:
                                    Color(
                                  0xFF17232E,
                                ),
                                height: 1.05,
                                letterSpacing:
                                    -1,
                              ),
                            ),

                            const SizedBox(
                              height: 2,
                            ),

                            const Text(
                              'shuru karein',

                              style:
                                  TextStyle(
                                fontSize: 28,
                                fontWeight:
                                    FontWeight
                                        .w900,
                                color:
                                    colours
                                        .primaryColor,
                                height: 1.05,
                                letterSpacing:
                                    -1,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(
                              'Mobile number se login karein',

                              style:
                                  TextStyle(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight
                                        .w500,
                                color:
                                    Color(
                                  0xFF667781,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================================
                      // TRANSPORT CARD
                      // ==================================================

                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                            0.94,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            20,
                          ),

                          border: Border.all(
                            color:
                                const Color(
                              0xFFFFE2C2,
                            ),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.05,
                              ),
                              blurRadius: 18,
                              offset:
                                  const Offset(
                                0,
                                7,
                              ),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [

                            // TRUCK ICON

                            Container(
                              width: 62,
                              height: 62,

                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  begin:
                                      Alignment
                                          .topLeft,
                                  end:
                                      Alignment
                                          .bottomRight,
                                  colors: [
                                    colours.primaryColor,
                                    colours.primaryColor,
                                  ],
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  18,
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: colours.primaryColor
                                        .withOpacity(
                                      0.25,
                                    ),
                                    blurRadius: 12,
                                    offset:
                                        const Offset(
                                      0,
                                      6,
                                    ),
                                  ),
                                ],
                              ),

                              child:
                                  const Icon(
                                Icons
                                    .local_shipping_rounded,
                                color:
                                    Colors.white,
                                size: 34,
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // TRANSPORT TEXT

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Text(
                                    'Aapka transport',

                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .w800,
                                      color:
                                          Color(
                                        0xFF17232E,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    'ab ek hi jagah',

                                    style:
                                        TextStyle(
                                      fontSize: 14,
                                      color:
                                          Color(
                                        0xFF78858F,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ARROW

                            // Container(
                            //   width: 34,
                            //   height: 34,

                            //   decoration:
                            //       BoxDecoration(
                            //     color:
                            //         const Color(
                            //       0xFFFFF2E3,
                            //     ),

                            //     borderRadius:
                            //         BorderRadius
                            //             .circular(
                            //       12,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // ==================================================
                      // LOGIN FORM CARD
                      // ==================================================

                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.all(
                          20,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                            0.97,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            25,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.07,
                              ),
                              blurRadius: 28,
                              offset:
                                  const Offset(
                                0,
                                12,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            // ==================================================
                            // MOBILE LABEL
                            // ==================================================

                            const Text(
                              'MOBILE NUMBER',

                              style:
                                  TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                letterSpacing:
                                    0.8,
                                color:
                                    Color(
                                  0xFF657581,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 9,
                            ),

                            // ==================================================
                            // MOBILE FIELD
                            // ==================================================

                            Container(
                              height: 58,

                              decoration:
                                  BoxDecoration(
                                color:
                                    const Color(
                                  0xFFF9FAFB,
                                ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  16,
                                ),

                                border:
                                    Border.all(
                                  color:
                                      const Color(
                                    0xFFE3E7EA,
                                  ),
                                ),
                              ),

                              child: Row(
                                children: [

                                  // +91

                                  const Padding(
                                    padding:
                                        EdgeInsets
                                            .only(
                                      left: 16,
                                    ),

                                    child: Row(
                                      children: [

                                        Text(
                                          '+91',

                                          style:
                                              TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight
                                                    .w700,
                                            color:
                                                Color(
                                              0xFF263746,
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 5,
                                        ),

                                        Icon(
                                          Icons
                                              .keyboard_arrow_down_rounded,
                                          size: 18,
                                          color:
                                              Color(
                                            0xFF667781,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Container(
                                    width: 1,
                                    height: 25,
                                    color:
                                        const Color(
                                      0xFFDDE1E4,
                                    ),
                                  ),

                                  // MOBILE INPUT

                                  Expanded(
                                    child:
                                        TextField(
                                      controller:
                                          mobileController,

                                      keyboardType:
                                          TextInputType
                                              .phone,

                                      maxLength: 10,

                                      style:
                                          const TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        color:
                                            Color(
                                          0xFF263746,
                                        ),
                                      ),

                                      decoration:
                                          const InputDecoration(
                                        hintText:
                                            'Enter mobile number',

                                        hintStyle:
                                            TextStyle(
                                          color:
                                              Color(
                                            0xFFADB6BC,
                                          ),
                                          fontWeight:
                                              FontWeight
                                                  .w400,
                                        ),

                                        counterText:
                                            '',

                                        border:
                                            InputBorder
                                                .none,

                                        contentPadding:
                                            EdgeInsets
                                                .symmetric(
                                          horizontal:
                                              14,
                                          vertical:
                                              17,
                                        ),
                                      ),

                                      inputFormatters: [
                                        FilteringTextInputFormatter
                                            .digitsOnly,

                                        LengthLimitingTextInputFormatter(
                                          10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // ==================================================
                            // OTP BUTTON
                            // ==================================================

                            SizedBox(
                              width:
                                  double.infinity,
                              height: 58,

                              child:
                                  DecoratedBox(
                                decoration:
                                    BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                    begin:
                                        Alignment
                                            .centerLeft,
                                    end:
                                        Alignment
                                            .centerRight,
                                    colors: [
                                      Color(
                                        0xFFFF9D2E,
                                      ),
                                      Color(
                                        0xFFFF6B00,
                                      ),
                                    ],
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    16,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color(
                                        0xFFFF7A00,
                                      ).withOpacity(
                                        0.28,
                                      ),
                                      blurRadius: 15,
                                      offset:
                                          const Offset(
                                        0,
                                        7,
                                      ),
                                    ),
                                  ],
                                ),

                                child:
                                    Obx(
                                  () =>
                                      ElevatedButton(
                                    onPressed:
                                        authController
                                                .isLoading
                                                .value
                                            ? null
                                            : sendOtp,

                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          Colors
                                              .transparent,

                                      disabledBackgroundColor:
                                          Colors
                                              .transparent,

                                      shadowColor:
                                          Colors
                                              .transparent,

                                      foregroundColor:colours.buttonTextColor,

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          16,
                                        ),
                                      ),
                                    ),

                                    child:
                                        authController
                                                .isLoading
                                                .value
                                            ? const SizedBox(
                                                width:
                                                    23,
                                                height:
                                                    23,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth:
                                                      2.5,
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
                                                    'OTP bhejein',

                                                    style:
                                                        TextStyle(
                                                      fontSize:colours.buttonFontSize,
                                                      fontWeight:colours.buttonFontWeight,
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width:
                                                        10,
                                                  ),

                                                  Icon(
                                                    Icons
                                                        .arrow_forward_rounded,
                                                    size:
                                                        21,
                                                  ),
                                                ],
                                              ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            // ==================================================
                            // OR
                            // ==================================================

                            Row(
                              children: [

                                Expanded(
                                  child:
                                      Container(
                                    height: 1,
                                    color:
                                        const Color(
                                      0xFFE8EAEC,
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding:
                                      EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                  ),

                                  child: Text(
                                    'OR',

                                    style:
                                        TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      color:
                                          Color(
                                        0xFF9AA6AD,
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child:
                                      Container(
                                    height: 1,
                                    color:
                                        const Color(
                                      0xFFE8EAEC,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 13,
                            ),

                            // ==================================================
                            // WHATSAPP TEXT
                            // ==================================================

                            const Center(
                              child: Text(
                                'WhatsApp par bhi OTP paayein',

                                style:
                                    TextStyle(
                                  fontSize: 13,
                                  color:
                                      Color(
                                    0xFF8A969E,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            // ==================================================
                            // WHATSAPP BUTTON
                            // ==================================================

                            SizedBox(
                              width:
                                  double.infinity,
                              height: 54,

                              child:
                                  Obx(
                                () =>
                                    OutlinedButton(
                                  onPressed:
                                      authController
                                              .isLoading
                                              .value
                                          ? null
                                          : sendWhatsAppOtp,

                                  style:
                                      OutlinedButton
                                          .styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xFFF6FFF9,
                                    ),

                                    foregroundColor:
                                        const Color(
                                      0xFF17232E,
                                    ),

                                    side:
                                        const BorderSide(
                                      color:
                                          Color(
                                        0xFFD5F1DD,
                                      ),
                                    ),

                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                    ),
                                  ),

                                  child:
                                      const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,

                                    children: [

                                      Icon(
                                        Icons
                                            .chat_rounded,
                                        color:
                                            Color(
                                          0xFF20B957,
                                        ),
                                        size: 22,
                                      ),

                                      SizedBox(
                                        width: 10,
                                      ),

                                      Text(
                                        'WhatsApp OTP',

                                        style:
                                            TextStyle(
                                          fontSize:
                                              15,
                                          fontWeight:
                                              FontWeight
                                                  .w800,
                                        ),
                                      ),

                                      SizedBox(
                                        width: 8,
                                      ),

                                      Icon(
                                        Icons
                                            .arrow_forward_rounded,
                                        size: 18,
                                        color:
                                            Color(
                                          0xFF20B957,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==================================================
                      // ERROR MESSAGE
                      // ==================================================

                      if (errorMessage !=
                          null) ...[
                        const SizedBox(
                          height: 14,
                        ),

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 15,
                            vertical: 11,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFFF1F1,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),

                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFFFFD4D4,
                              ),
                            ),
                          ),

                          child: Text(
                            errorMessage!,

                            textAlign:
                                TextAlign.center,

                            style:
                                const TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.red,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ),
                      ],

                      // ==================================================
                      // SUCCESS MESSAGE
                      // ==================================================

                      if (successMessage !=
                          null) ...[
                        const SizedBox(
                          height: 14,
                        ),

                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 15,
                            vertical: 11,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFF0FFF5,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),

                            border:
                                Border.all(
                              color:
                                  const Color(
                                0xFFC8EFD6,
                              ),
                            ),
                          ),

                          child: Text(
                            successMessage!,

                            textAlign:
                                TextAlign.center,

                            style:
                                const TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.green,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






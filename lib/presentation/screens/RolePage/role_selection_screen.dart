
import 'package:flutter/material.dart';

import '../registration/manufacturer_registration_screen.dart';
import '../registration/truck_owner_registration_screen.dart';
import '../registration/driver_registration_screen.dart';
import '../registration/transport_vendor_registration_screen.dart';
import '../../../core/storage/colors.dart';

class RoleSelectionScreen extends StatelessWidget {
  
  const RoleSelectionScreen({super.key});
  static const Color textcolor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),

      body: Stack(
        children: [

          // ============================================================
          // FULL SCREEN BACKGROUND IMAGE
          // ============================================================

          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // ============================================================
          // WHITE TRANSPARENT OVERLAY
          // ============================================================

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.94),
                    Colors.white.withOpacity(0.97),
                  ],
                  stops: const [
                    0.0,
                    0.35,
                    0.70,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          // ============================================================
          // MAIN CONTENT
          // ============================================================

          SafeArea(
            child: Column(
              children: [

                // ======================================================
                // HEADER
                // ======================================================

                Container(
                  height: 72,
                  width: double.infinity,

                  // IMPORTANT:
                  // transparent instead of white
                  color: Colors.transparent,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // ==================================================
                      // MAALMITRA LOGO
                      // ==================================================

                      RichText(
                        text: const TextSpan(
                          children: [

                            TextSpan(
                              text: 'Maal',
                              style: TextStyle(
                                color: colours.logoColor,
                                fontSize: colours.logoFontSize,
                                fontWeight: colours.logofontweight,
                              ),
                            ),

                            TextSpan(
                              text: 'Mitra',
                              style: TextStyle(
                                color: colours.primaryColor,
                                fontSize: colours.logoFontSize,
                                fontWeight: colours.logofontweight,
                              ),
                            ),

                          ],
                        ),
                      ),

                      // ==================================================
                      // LANGUAGE
                      // ==================================================

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.82),
                          borderRadius: BorderRadius.circular(30),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: const Row(
                          children: [

                            Text(
                              'EN',
                              style: TextStyle(
                                color: Color(0xFF25313E),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(width: 4),

                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 18,
                              color: Color(0xFF45515F),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ======================================================
                // SCROLLABLE CONTENT
                // ======================================================

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: Column(
                      children: [

                        // ==================================================
                        // HERO SECTION
                        // ==================================================

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.fromLTRB(
                            28,
                            45,
                            28,
                            25,
                          ),

                          color: Colors.transparent,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // ==========================================
                              // HEADING
                              // ==========================================

                              RichText(
                                text:  TextSpan(
                                  children: [

                                    TextSpan(
                                      text: 'Aap ',
                                      style: TextStyle(
                                        color: textcolor,
                                        fontSize:
                                            25,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),

                                    TextSpan(
                                      text: 'kaun',
                                      style: TextStyle(
                                        color: textcolor,
                                        fontSize:
                                            25,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),

                                    TextSpan(
                                      text: ' hain?',
                                      style: TextStyle(
                                        color: textcolor,
                                        fontSize:
                                            25,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ==========================================
                              // SUBTITLE
                              // ==========================================

                               Text(
                                'Apna kaam choose karein',
                                style: TextStyle(
                                  color: textcolor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 60),

                              // ==========================================
                              // ORANGE LINE
                              // ==========================================

                              Container(
                                height: 5,
                                width: 65,

                                
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // MANUFACTURER
                        // ==================================================

                        _RoleCard(
                          imagePath: 'assets/images/factory.png',

                          title: 'Manufacturer / Business',

                          subtitle: 'Maal bhejna hai',

                          description:
                              'Apne products ko desh bhar mein bhejein.',

                          backgroundColor:
                              colours.rolecardbgcolor.withOpacity(0.88) ,

                          borderColor:colours.primaryColor,

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ManufacturerRegistrationScreen(),
                              ),
                            );
                          },
                        ),

                        // ==================================================
                        // TRUCK OWNER
                        // ==================================================

                        _RoleCard(
                          imagePath: 'assets/images/truck1.png',

                          title: 'Truck Owner',

                          subtitle: 'Gaadi aur load',

                          description:
                              'Apni gaadi register karein aur load paayein.',

                          backgroundColor:
                              colours.rolecardbgcolor.withOpacity(0.88) ,

                          borderColor:colours.primaryColor,

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TruckOwnerRegistrationScreen(),
                              ),
                            );
                          },
                        ),

                        // ==================================================
                        // DRIVER
                        // ==================================================

                        _RoleCard(
                          imagePath: 'assets/images/driver.png',

                          title: 'Driver',

                          subtitle: 'Trip aur earning',

                          description:
                              'Trip lein, kamai badhayein aur apni pehchaan banayein.',

                          backgroundColor:
                              colours.rolecardbgcolor.withOpacity(0.88) ,

                          borderColor:colours.primaryColor,

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DriverRegistrationScreen(),
                              ),
                            );
                          },
                        ),

                        // ==================================================
                        // TRANSPORT VENDOR
                        // ==================================================

                        _RoleCard(
                          imagePath: 'assets/images/vendor.png',

                          title: 'Transport Vendor',

                          subtitle: 'Fleet manage karna',

                          description:
                              'Multiple gaadiyon ka aasani se prabandhan karein.',

                          backgroundColor:
                              colours.rolecardbgcolor.withOpacity(0.88) ,

                          borderColor:colours.primaryColor,
                      

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TransportVendorRegistrationScreen(),
                              ),
                            );
                          },
                        ),

                        // ==================================================
                        // FOOTER
                        // ==================================================

                        const SizedBox(height: 22),

                         Padding(
                          padding: EdgeInsets.only(
                            bottom: 30,
                          ),

                          child: Text(
                            'Aap baad mein role badal sakte hain',

                            style: TextStyle(
                              color: textcolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ======================================================================
// ROLE CARD
// ======================================================================

class _RoleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _RoleCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 7,
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,

          borderRadius: BorderRadius.circular(24),

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              // Keep your card colors
              // but make them slightly transparent
              // so the background can still be seen.

              color: backgroundColor.withOpacity(0.88),

              borderRadius: BorderRadius.circular(24),

              border: Border.all(
                color: borderColor,
                width: 1.3,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),

            child: Row(
              children: [

                // ======================================================
                // IMAGE
                // ======================================================

                Container(
                  width: 88,
                  height: 88,

                  padding: const EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 16),

                // ======================================================
                // TEXT
                // ======================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        title,

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style:  TextStyle(
                          color:  
                        RoleSelectionScreen.textcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,

                        style:TextStyle(
                          color:  RoleSelectionScreen.textcolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        description,

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style:  TextStyle(
                          color:  RoleSelectionScreen.textcolor,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ======================================================
                // ARROW
                // ======================================================

                Container(
                  width: 44,
                  height: 44,

                  decoration: const BoxDecoration(
                    color: colours.primaryColor,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
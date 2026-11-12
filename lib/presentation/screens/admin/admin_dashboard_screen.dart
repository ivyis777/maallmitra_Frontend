
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'admin_truck_owner_screen.dart';
// import '../../../core/storage/colors.dart';
// import 'admin_manufacturer_screen.dart';
// import 'admin_driver_screen.dart';
// import 'admin_vendor_screen.dart';


// class AdminDashboardScreen extends StatelessWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F7F7),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: colours.primaryColor,
//         title: RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: 'Maal',
//                 style: TextStyle(
//                   color: colours.logoColor,
//                   fontSize: colours.logoFontSize,
//                   fontWeight: colours.logofontweight,
//                 ),
//               ),
//               TextSpan(
//                 text: 'Mitra',
//                 style: TextStyle(
//                   color: const Color.fromARGB(255, 30, 28, 25),
//                   fontSize: colours.logoFontSize,
//                   fontWeight: colours.logofontweight,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Admin Dashboard',
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               const Text(
//                 'Manage your MaalMitra operations',
//                 style: TextStyle(color: Colors.black54),
//               ),
//               const SizedBox(height: 24),

//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 14,
//                 mainAxisSpacing: 14,
//                 childAspectRatio: 0.95,
//                 children: [
//                   _dashboardCard(
//                     title: 'Driver Registrations',
//                     icon: Icons.people_alt_rounded,
//                     onTap: () {
//                       Get.to(
//                         () => const AdminDriverScreen(),
//                       );
//                     },
//                   ),
//                   _dashboardCard(
//                     title: 'vendor Management',
//                     icon: Icons.business_rounded,
//                     onTap: () {
//                           Get.to(() =>  AdminVendorScreen());
//                     },
//                   ),
//                   _dashboardCard(
//                     title: 'Truck Owner Registrations',
//                     icon: Icons.local_shipping_rounded,
//                     onTap: () {
//                       Get.to(
//                     () => const AdminTruckOwnerScreen(),
// );
//                     },
//                   ),
//                   _dashboardCard(
//                     title: 'Manufacturer Management',
//                     icon: Icons.factory_rounded,
//                     onTap: () {
//                       Get.to(() => AdminManufacturerScreen());
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _dashboardCard({
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       color: Colors.white,
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//         side: BorderSide(
//           color: colours.primaryColor.withOpacity(0.25),
//         ),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 42,
//                 color: colours.primaryColor,
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Icon(
//                 Icons.arrow_forward_rounded,
//                 color: colours.primaryColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _comingSoon(String section) {
//     Get.snackbar(
//       section,
//       'This section will be connected when its screen and API are ready.',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_truck_owner_screen.dart';
import '../../../core/storage/colors.dart';
import 'admin_manufacturer_screen.dart';
import 'admin_driver_screen.dart';
import 'admin_vendor_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),

      body: Stack(
        children: [

          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // WHITE TRANSPARENT GRADIENT
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
                    Colors.white.withOpacity(0.98),
                  ],
                  stops: const [
                    0.0,
                    0.30,
                    0.65,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: Column(
              children: [

                // HEADER
                Container(
                  height: 72,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Row(
                    children: [
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
                    ],
                  ),
                ),

                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // DASHBOARD HEADING
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(
                            28,
                            45,
                            28,
                            30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                'Admin Dashboard',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Manage your MaalMitra operations',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // ORANGE LINE
                              Container(
                                height: 4,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: colours.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // DRIVER REGISTRATIONS
                        _AdminCard(
                          imagePath: 'assets/images/driver.png',
                          title: 'Driver Registrations',
                          description:
                              'View, verify and manage driver registrations.',
                          onTap: () {
                            Get.to(
                              () => const AdminDriverScreen(),
                            );
                          },
                        ),

                        // VENDOR MANAGEMENT
                        _AdminCard(
                          imagePath: 'assets/images/vendor.png',
                          title: 'Vendor Management',
                          description:
                              'Manage transport vendors and their details.',
                          onTap: () {
                            Get.to(
                              () => AdminVendorScreen(),
                            );
                          },
                        ),

                        // TRUCK OWNER REGISTRATIONS
                        _AdminCard(
                          imagePath: 'assets/images/truck1.png',
                          title: 'Truck Owner Registrations',
                          description:
                              'View and manage truck owner registrations.',
                          onTap: () {
                            Get.to(
                              () => const AdminTruckOwnerScreen(),
                            );
                          },
                        ),

                        // MANUFACTURER MANAGEMENT
                        _AdminCard(
                          imagePath: 'assets/images/factory.png',
                          title: 'Manufacturer Management',
                          description:
                              'Manage manufacturer registrations and details.',
                          onTap: () {
                            Get.to(
                              () => AdminManufacturerScreen(),
                            );
                          },
                        ),

                        const SizedBox(height: 25),
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


// ============================================================
// ADMIN DASHBOARD CARD
// ============================================================

class _AdminCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AdminCard({
    required this.imagePath,
    required this.title,
    required this.description,
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
              color: colours.rolecardbgcolor.withOpacity(0.88),

              borderRadius: BorderRadius.circular(24),

              border: Border.all(
                color: colours.primaryColor,
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

                // IMAGE
                Container(
                  width: 88,
                  height: 88,
                  padding: const EdgeInsets.all(6),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(width: 12),

                // VERTICAL DIVIDER
                Container(
                  width: 1.5,
                  height: 72,
                  color: colours.primaryColor.withOpacity(0.5),
                ),

                const SizedBox(width: 14),

                // CARD TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ORANGE ARROW
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


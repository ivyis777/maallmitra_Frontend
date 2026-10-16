

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/screens/admin/admin_driver_screen.dart';
import 'core/storage/colors.dart';
import 'presentation/screens/LoginPage/loginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaalMitraApp());
}

class MaalMitraApp extends StatelessWidget {
  const MaalMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MaalMitra',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;

  late Animation<double> _truckAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _taglineAnimation;
  late Animation<double> _roadAnimation;

  @override
  void initState() {
    super.initState();

    // ============================================================
    // MAIN ANIMATION
    // ============================================================

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    );

    // ============================================================
    // TRUCK ANIMATION
    // ============================================================

    _truckAnimation = Tween<double>(
      begin: -500,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ============================================================
    // LOGO ANIMATION
    // ============================================================

    _logoAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.40,
          0.75,
          curve: Curves.easeOut,
        ),
      ),
    );

    // ============================================================
    // TAGLINE ANIMATION
    // ============================================================

    _taglineAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.58,
          0.85,
          curve: Curves.easeOut,
        ),
      ),
    );

    // ============================================================
    // ROAD ANIMATION
    // ============================================================

    _roadAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.15,
          0.65,
          curve: Curves.easeOut,
        ),
      ),
    );

    // ============================================================
    // BACKGROUND PULSE
    // ============================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat(
        reverse: true,
      );

    // ============================================================
    // START MAIN ANIMATION
    // ============================================================

    _mainController.forward().whenComplete(() {
      if (!mounted) return;

      // ============================================================
      // GO TO LOGIN AFTER SPLASH COMPLETES
      // ============================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
           builder: (context) => const LoginPage(),
         // builder: (context) => const AdminDriverScreen(),
          
         ),     


      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        19,
        18,
        18,
      ),

      body: SafeArea(
        child: Stack(
          children: [

            // ========================================================
            // ORANGE BACKGROUND
            // ========================================================

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colours.primaryColor,
                      colours.primaryColor,
                      colours.primaryColor,
                    ],
                  ),
                ),
              ),
            ),

            // ========================================================
            // BACKGROUND GLOW
            // ========================================================

            Center(
              child: AnimatedBuilder(
                animation: _pulseController,

                builder: (context, child) {
                  final scale =
                      0.90 +
                      (_pulseController.value * 0.10);

                  return Transform.scale(
                    scale: scale,

                    child: Container(
                      width: 330,
                      height: 330,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: Colors.white.withOpacity(
                          0.06,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(
                              0.12,
                            ),
                            blurRadius: 100,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ========================================================
            // MAIN CONTENT
            // ========================================================

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  // ====================================================
                  // TRUCK
                  // ====================================================

                  AnimatedBuilder(
                    animation: _truckAnimation,

                    builder: (
                      context,
                      child,
                    ) {
                      return Transform.translate(
                        offset: Offset(
                          _truckAnimation.value,
                          0,
                        ),
                        child: child,
                      );
                    },

                    child: Image.asset(
                      'assets/images/truck.png',
                      width: 245,
                      height: 165,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ====================================================
                  // ROAD
                  // ====================================================

                  AnimatedBuilder(
                    animation: _roadAnimation,

                    builder: (
                      context,
                      child,
                    ) {
                      return SizedBox(
                        width: 220,

                        child: LinearProgressIndicator(
                          value: _roadAnimation.value,
                          minHeight: 3,

                          backgroundColor:
                              Colors.white.withOpacity(
                            0.20,
                          ),

                          color: Colors.white,
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ====================================================
                  // MAALMITRA LOGO
                  // ====================================================

                  FadeTransition(
                    opacity: _logoAnimation,

                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),

                        children: [

                          TextSpan(
                            text: 'Maal',
                            style: TextStyle(
                              color: colours.foregroundColor,
                            ),
                          ),

                          TextSpan(
                            text: 'Mitra',
                            style: TextStyle(
                              color: colours.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ====================================================
                  // TAGLINE
                  // ====================================================

                  FadeTransition(
                    opacity: _taglineAnimation,

                    child: const Text(
                      'Smart Truck Booking',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // BOTTOM LOADING
            // ========================================================

            Positioned(
              bottom: 70,
              left: 0,
              right: 0,

              child: Center(
                child: SizedBox(
                  width: 130,

                  child: LinearProgressIndicator(
                    minHeight: 3,

                    backgroundColor:
                        Colors.white.withOpacity(
                      0.20,
                    ),

                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ========================================================
            // BRAND
            // ========================================================

            const Positioned(
              bottom: 35,
              left: 0,
              right: 0,

              child: Center(
                child: Text(
                  'MAALMITRA',

                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../../core/storage/colors.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int selectedIndex = 0;

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color dark = Color(0xFF17212B);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF687386);
  static const Color background = Color(0xFFF7F8FA);

  // ==========================================================
  // ASSETS
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            _buildHomePage(),
            _buildSimplePage("Loads"),
            _buildSimplePage("Post"),
            _buildSimplePage("Trips"),
            _buildSimplePage("Profile"),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ==========================================================
  // HOME PAGE
  // ==========================================================

  Widget _buildHomePage() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [

        // HERO
        SliverToBoxAdapter(
          child: _buildHeroSection(),
        ),

        // CURRENT TRIP
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _buildCurrentTripCard(),
          ),
        ),

        // TRIP BUTTON
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildTripButton(),
          ),
        ),

        // TITLE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Aaj ke kaam",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text(
                        "View all",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textGrey,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: textGrey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // WORK CARDS
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate(
              [
                _buildWorkCard(
                  icon: Icons.location_on_rounded,
                  title: "Loading point",
                  subtitle: "Reach by 10:00 AM",
                  backgroundColor: const Color(0xFFFFF1E7),
                  iconBackground: const Color(0xFFFFDCD5),
                  iconColor: Colors.redAccent,
                  arrowColor: colours.primaryColor,
                  onTap: () {},
                ),

                _buildWorkCard(
                  icon: Icons.description_rounded,
                  title: "Documents",
                  subtitle: "E-way bill ready",
                  backgroundColor: const Color(0xFFEAF6FF),
                  iconBackground: const Color(0xFFDDEEFF),
                  iconColor: const Color(0xFF2389E8),
                  arrowColor: const Color(0xFF2389E8),
                  onTap: () {},
                ),

                _buildWorkCard(
                  icon: Icons.camera_alt_rounded,
                  title: "Delivery proof",
                  subtitle: "Photo + OTP",
                  backgroundColor: const Color(0xFFEAFBF2),
                  iconBackground: const Color(0xFFD7F5E6),
                  iconColor: const Color(0xFF09A95A),
                  arrowColor: const Color(0xFF09A95A),
                  onTap: () {},
                ),

                _buildWorkCard(
                  icon: Icons.currency_rupee_rounded,
                  title: "Earning",
                  subtitle: "₹ 31,500",
                  backgroundColor: const Color(0xFFF2EDFF),
                  iconBackground: const Color(0xFFE4D9FF),
                  iconColor: const Color(0xFF6B3DDB),
                  arrowColor: const Color(0xFF6B3DDB),
                  onTap: () {},
                ),
              ],
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.38,
            ),
          ),
        ),

        // FUEL + DELIVERY
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 25),
            child: _buildTripInfoCard(),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HERO SECTION
  // ==========================================================

  Widget _buildHeroSection() {
    return Container(
      height: 375,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7EA),
            Color(0xFFFFD9A1),
            Color(0xFFFFA34B),
          ],
        ),
      ),
      child: Stack(
        children: [

          // ----------------------------------------------------
          // HEADER
          // ----------------------------------------------------

          Positioned(
            left: 18,
            right: 18,
            top: 14,
            child: Row(
              children: [

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.80),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: dark,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Maal",
                          style: TextStyle(
                            fontSize: colours.logoFontSize,
                            fontWeight: colours.logofontweight,
                            color: colours.logoColor,
                          ),
                        ),
                        TextSpan(
                          text: "Mitra",
                          style: TextStyle(
                            fontSize: colours.logoFontSize,
                            fontWeight: colours.logofontweight,
                            color: colours.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "EN",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: dark,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // NOTIFICATION
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 25,
                          color: dark,
                        ),
                      ),

                      Positioned(
                        top: 7,
                        right: 7,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // DRIVER TITLE
          // ----------------------------------------------------

          const Positioned(
            left: 22,
            top: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver Home",
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    color: dark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Aaj ka trip",
                  style: TextStyle(
                    fontSize: 16,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // Driver IMAGE
          // ----------------------------------------------------

          Positioned(
            right: -35,
            top: 125,
            child: SizedBox(
              width: 270,
              height: 175,
              child: Image.asset(
              'assets/images/driver.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.local_shipping_rounded,
                    color: colours.primaryColor,
                    size: 110,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CURRENT TRIP
  // ==========================================================

  Widget _buildCurrentTripCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
      decoration: BoxDecoration(
        color: dark,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // LABEL + STATUS
          Row(
            children: [

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colours.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "CURRENT TRIP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0CA85A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 9,
                      color: Color(0xFF72FFB0),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "ON WAY",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          // ROUTE
          const Text(
            "Bengaluru → Hyderabad",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          // LOAD + PRICE
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: Colors.white70,
                size: 23,
              ),

              const SizedBox(width: 8),

              const Text(
                "32 Ton",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 15),

              Container(
                width: 1,
                height: 22,
                color: Colors.white30,
              ),

              const SizedBox(width: 15),

              const Text(
                "₹ 31,500",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ROUTE LINE
          Row(
            children: [

              const Icon(
                Icons.location_on_rounded,
                color: colours.primaryColor,
                size: 29,
              ),

              Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: CustomPaint(
                    painter: _DashedLinePainter(),
                  ),
                ),
              ),

              const Icon(
                Icons.local_shipping_rounded,
                color: colours.primaryColor,
                size: 30,
              ),

              Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: CustomPaint(
                    painter: _DashedLinePainter(),
                  ),
                ),
              ),

              const Icon(
                Icons.location_on_rounded,
                color: Colors.redAccent,
                size: 29,
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Row(
            children: [
              Text(
                "Bengaluru",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                "Hyderabad",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TRIP BUTTON
  // ==========================================================

  Widget _buildTripButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = 3;
        });
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF8A00),
              Color(0xFFFF6B00),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: colours.primaryColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.navigation_rounded,
              color: Colors.white,
              size: 25,
            ),

            SizedBox(width: 10),

            Text(
              "Trip kholein",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(width: 12),

            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // WORK CARD
  // ==========================================================

  Widget _buildWorkCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color backgroundColor,
    required Color iconBackground,
    required Color iconColor,
    required Color arrowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [

            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 27,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: arrowColor,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // FUEL + DELIVERY CARD
  // ==========================================================

  Widget _buildTripInfoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF5E8),
            Color(0xFFFFF0DF),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Expanded(
            child: Row(
              children: [

                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE4C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_gas_station_rounded,
                    color: colours.primaryColor,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 10),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fuel left",
                      style: TextStyle(
                        fontSize: 12,
                        color: textGrey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "120 km",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            height: 50,
            width: 1,
            color: Colors.black.withOpacity(0.08),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Row(
              children: [

                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE4C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: colours.primaryColor,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Est. delivery",
                        style: TextStyle(
                          fontSize: 12,
                          color: textGrey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Today, 8:30 PM",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [

              _buildNavItem(
                index: 0,
                icon: Icons.home_rounded,
                title: "Home",
              ),

              _buildNavItem(
                index: 1,
                icon: Icons.inventory_2_outlined,
                title: "Loads",
              ),

              _buildNavItem(
                index: 2,
                icon: Icons.add_rounded,
                title: "Post",
                isPostButton: true,
              ),

              _buildNavItem(
                index: 3,
                icon: Icons.list_alt_rounded,
                title: "Trips",
              ),

              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                title: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // NAV ITEM
  // ==========================================================

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String title,
    bool isPostButton = false,
  }) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: isSelected ? 35 : 0,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: colours.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Container(
              width: isPostButton ? 43 : 30,
              height: isPostButton ? 43 : 27,
              decoration: isPostButton
                  ? const BoxDecoration(
                      color: colours.primaryColor,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Icon(
                icon,
                size: isPostButton ? 27 : 21,
                color: isPostButton
                    ? Colors.white
                    : isSelected
                        ? colours.primaryColor
                        : const Color(0xFF7A8496),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? colours.primaryColor
                    : const Color(0xFF7A8496),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TEMPORARY PAGES
  // ==========================================================

  Widget _buildSimplePage(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
      ),
    );
  }
}

// ==========================================================
// DASHED ROUTE LINE
// ==========================================================

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF8500)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const dashWidth = 7;
    const dashSpace = 5;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(
          startX + dashWidth,
          size.height / 2,
        ),
        paint,
      );

      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
import 'package:flutter/material.dart';

import '../../../core/storage/colors.dart';

class BusinessHomePage extends StatefulWidget {
  const BusinessHomePage({super.key});

  @override
  State<BusinessHomePage> createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
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
            _buildSimplePage("Post Load"),
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

        SliverToBoxAdapter(
          child: _buildHeroSection(),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: _buildFindTruckCard(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 14),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Meri bookings",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
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

        // BOOKINGS
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildBookingCard(
                  from: "Pune",
                  to: "Bengaluru",
                  amount: "₹42,500",
                  status: "Truck assigned",
                  statusColor: const Color(0xFF19A85B),
                  statusBackground: const Color(0xFFE7F8EE),
                  date: "25 Sep 2026",
                  weight: "32 Ton",
                  packageColor: const Color(0xFFFFF1E5),
                ),

                const SizedBox(height: 12),

                _buildBookingCard(
                  from: "Bengaluru",
                  to: "Chennai",
                  amount: "₹31,000",
                  status: "Truck dhoondh rahe hain",
                  statusColor: colours.primaryColor,
                  statusBackground: const Color(0xFFFFF1DD),
                  date: "28 Sep 2026",
                  weight: "20 Ton",
                  packageColor: const Color(0xFFEAF6FF),
                ),
              ],
            ),
          ),
        ),

        // LIVE TRACKING
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _buildLiveTrackingCard(),
          ),
        ),

        // QUICK SERVICES
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 25, 18, 14),
            child: const Text(
              "Quick services",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate(
              [
                _buildServiceItem(
                  icon: Icons.receipt_long_rounded,
                  title: "Invoices",
                  subtitle: "Payment details",
                  iconColor: const Color(0xFFFF5B7A),
                  backgroundColor: const Color(0xFFFFEAF0),
                ),

                _buildServiceItem(
                  icon: Icons.qr_code_scanner_rounded,
                  title: "Repeat Booking",
                  subtitle: "Quick book again",
                  iconColor: const Color(0xFF00B985),
                  backgroundColor: const Color(0xFFE7FAF4),
                ),

                _buildServiceItem(
                  icon: Icons.headset_mic_rounded,
                  title: "Support",
                  subtitle: "Get help",
                  iconColor: const Color(0xFF7656E8),
                  backgroundColor: const Color(0xFFF0EBFF),
                ),

                _buildServiceItem(
                  icon: Icons.star_rounded,
                  title: "Refer & Earn",
                  subtitle: "Earn rewards",
                  iconColor: const Color(0xFF3698E8),
                  backgroundColor: const Color(0xFFE8F5FF),
                ),
              ],
            ),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              childAspectRatio: 0.72,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 25),
        ),
      ],
    );
  }

  // ==========================================================
  // HERO SECTION
  // ==========================================================

  Widget _buildHeroSection() {
    return Container(
      height: 340,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8EA),
            Color(0xFFFFD99E),
            Color(0xFFFFA447),
          ],
        ),
      ),
      child: Stack(
        children: [

          // HEADER
          Positioned(
            left: 18,
            right: 18,
            top: 15,
            child: Row(
              children: [

                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    size: 25,
                    color: dark,
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

          // GREETING
          const Positioned(
            left: 20,
            top: 92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Namaste, Name 👋",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: dark,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Aaj kya bhejna hai?",
                  style: TextStyle(
                    fontSize: 15,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          // TRUCK IMAGE
          Positioned(
            right: -35,
            top: 125,
            child: SizedBox(
              width: 245,
              height: 150,
              child: Image.asset(
                'assets/images/factory.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.local_shipping_rounded,
                    size: 100,
                    color: colours.primaryColor,
                  );
                },
              ),
            ),
          ),

          // STATS
          Positioned(
            left: 18,
            right: 18,
            bottom: 15,
            child: Container(
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  _buildStat(
                    icon: Icons.inventory_2_rounded,
                    value: "5",
                    title: "Total Bookings",
                  ),

                  _buildStatDivider(),

                  _buildStat(
                    icon: Icons.local_shipping_rounded,
                    value: "2",
                    title: "In Transit",
                  ),

                  _buildStatDivider(),

                  _buildStat(
                    icon: Icons.check_circle_rounded,
                    value: "3",
                    title: "Delivered",
                    iconColor: const Color(0xFF16A45A),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STAT
  // ==========================================================

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String title,
    Color iconColor = dark,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 42,
      color: Colors.black.withOpacity(0.08),
    );
  }

  // ==========================================================
  // FIND TRUCK CARD
  // ==========================================================

  Widget _buildFindTruckCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF7ED),
            Color(0xFFFFEFE1),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colours.primaryColor.withOpacity(0.10),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [

          Row(
            children: [

              Container(
                width: 70,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(
                  'assets/images/truck.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.inventory_2_rounded,
                      size: 42,
                      color: colours.primaryColor,
                    );
                  },
                ),
              ),

              const SizedBox(width: 15),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Maal bhejna hai?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Truck 1 minute mein dhoondhein",
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.location_on_rounded,
                color: colours.primaryColor,
                size: 35,
              ),
            ],
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
            child: Container(
              height: 46,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF8500),
                    Color(0xFFFF6B00),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Truck dhoondhein",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOOKING CARD
  // ==========================================================

  Widget _buildBookingCard({
    required String from,
    required String to,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBackground,
    required String date,
    required String weight,
    required Color packageColor,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [

            // PACKAGE
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: packageColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/package.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.inventory_2_rounded,
                    color: Color(0xFF996633),
                    size: 34,
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "$from → $to",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textGrey,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 1,
                        height: 13,
                        color: Colors.grey.shade300,
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 14,
                        color: textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        weight,
                        style: const TextStyle(
                          fontSize: 10,
                          color: textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // PRICE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status == "Truck assigned"
                        ? "Confirmed"
                        : "Searching",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 6),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: textGrey,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // LIVE TRACKING
  // ==========================================================

  Widget _buildLiveTrackingCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = 3;
        });
      },
      child: Container(
        height: 145,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: dark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: dark.withOpacity(0.16),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [

            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Live trip tracking",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Apne truck ki live location dekhein",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            // ROUTE
            Positioned(
              left: 5,
              right: 5,
              bottom: 12,
              child: Row(
                children: [

                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.redAccent,
                    size: 30,
                  ),

                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: colours.primaryColor,
                            width: 2,
                          ),
                        ),
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
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: colours.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.location_on_rounded,
                    color: colours.primaryColor,
                    size: 30,
                  ),
                ],
              ),
            ),

            // BUTTON
            Positioned(
              right: 0,
              top: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: colours.primaryColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Text(
                      "Dekhein",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 13,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // QUICK SERVICE
  // ==========================================================

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [

          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 27,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 9,
              color: textGrey,
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
          top: Radius.circular(24),
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
    final bool selected = selectedIndex == index;

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
              width: selected ? 34 : 0,
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
                    : selected
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
                    selected ? FontWeight.w800 : FontWeight.w500,
                color: selected
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
  // TEMPORARY OTHER PAGES
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
import 'package:flutter/material.dart';

import '../../../core/storage/colors.dart';

class OwnerHomePage extends StatefulWidget {
  const OwnerHomePage({super.key});

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  int selectedIndex = 0;

  // ==========================================================
  // COLORS
  // ==========================================================

  
  static const Color dark = Color(0xFF17212B);
  static const Color textDark = Color(0xFF172033);
  static const Color textGrey = Color(0xFF687386);
  static const Color background = Color(0xFFF7F8FA);

  // ==========================================================
  // ASSET PATHS
  // Change these according to your actual image names
  // ==========================================================

  
  static const String searchImage = 'assets/images/search.png';
  static const String truckSmallImage = 'assets/images/truck_small.png';
  static const String tripImage = 'assets/images/trip.png';
  static const String paymentImage = 'assets/images/payment.png';

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

        // ------------------------------------------------------
        // HEADER / HERO
        // ------------------------------------------------------

        SliverToBoxAdapter(
          child: _buildHeroSection(),
        ),

        // ------------------------------------------------------
        // EARNING CARD
        // ------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: _buildEarningCard(),
          ),
        ),

        // ------------------------------------------------------
        // QUICK ACTION TITLE
        // ------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 26, 18, 14),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Aaj kya karna hai?",
                    style: TextStyle(
                      fontSize: 21,
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
                          color: Color(0xFF59647A),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF59647A),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ------------------------------------------------------
        // QUICK ACTIONS
        // ------------------------------------------------------

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildListDelegate(
              [
                _buildActionCard(
                  title: "Load dhoondo",
                  subtitle: "Apni route ka load",
                  image: searchImage,
                  backgroundColor: const Color(0xFFFFF2E5),
                  onTap: () {},
                ),

                _buildActionCard(
                  title: "Gaadi lagao",
                  subtitle: "Truck available karo",
                  image: truckSmallImage,
                  backgroundColor: const Color(0xFFEFFBEF),
                  onTap: () {},
                ),

                _buildActionCard(
                  title: "Trip dekho",
                  subtitle: "Live trip status",
                  image: tripImage,
                  backgroundColor: const Color(0xFFEAF6FF),
                  onTap: () {},
                ),

                _buildActionCard(
                  title: "Payment",
                  subtitle: "Kitna mila / baki",
                  image: paymentImage,
                  backgroundColor: const Color(0xFFF4EEFF),
                  onTap: () {},
                ),
              ],
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.30,
            ),
          ),
        ),

        // ------------------------------------------------------
        // RETURN LOAD
        // ------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _buildReturnLoadCard(),
          ),
        ),

        // ------------------------------------------------------
        // MAIN CTA
        // ------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 25),
            child: _buildMainButton(),
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
      height: 330,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF4DF),
            Color(0xFFFFD39B),
            Color(0xFFFFA64D),
          ],
        ),
      ),
      child: Stack(
        children: [

          // ----------------------------------------------------
          // TOP HEADER
          // ----------------------------------------------------

          Positioned(
            left: 18,
            right: 18,
            top: 16,
            child: Row(
              children: [

                // MENU
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: dark,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                // LOGO
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

                // LANGUAGE
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
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: dark,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: dark,
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
                          color: dark,
                          size: 25,
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
          // GREETING
          // ----------------------------------------------------

          const Positioned(
            left: 20,
            top: 88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Namaste, Ramesh 👋",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: dark,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Aaj ki gaadi aur load dekhein",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF59647A),
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // TRUCK IMAGE
          // ----------------------------------------------------

          Positioned(
            right: -20,
            top: 115,
            child: SizedBox(
              width: 235,
              height: 145,
              child: Image.asset(
                'assets/images/truck.png',
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

          // ----------------------------------------------------
          // STATS
          // ----------------------------------------------------

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 78,
              color: Colors.white.withOpacity(0.58),
              child: Row(
                children: [

                  _buildHeroStat(
                    icon: Icons.route_rounded,
                    value: "12",
                    title: "Total Loads",
                  ),

                  _buildVerticalDivider(),

                  _buildHeroStat(
                    icon: Icons.local_shipping_rounded,
                    value: "3",
                    title: "Active Trips",
                  ),

                  _buildVerticalDivider(),

                  _buildHeroStat(
                    icon: Icons.currency_rupee_rounded,
                    value: "₹28K",
                    title: "Total Earnings",
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
  // HERO STAT
  // ==========================================================

  Widget _buildHeroStat({
    required IconData icon,
    required String value,
    required String title,
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
                size: 19,
                color: dark,
              ),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF59647A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 42,
      width: 1,
      color: Colors.white.withOpacity(0.8),
    );
  }

  // ==========================================================
  // EARNING CARD
  // ==========================================================

  Widget _buildEarningCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [

          // EARNING ICON
          Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: colours.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          // EARNING
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aaj ki earning",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "₹ 18,450",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // PERCENTAGE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0FA968),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  "+12%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "today",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
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
  // QUICK ACTION CARD
  // ==========================================================

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String image,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [

            // IMAGE
            Positioned(
              top: 2,
              left: 2,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_outlined,
                      size: 42,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            // ARROW
            Positioned(
              right: 0,
              bottom: 5,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: dark,
                ),
              ),
            ),

            // TEXT
            Positioned(
              left: 0,
              bottom: 4,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 4),

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
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // RETURN LOAD CARD
  // ==========================================================

  Widget _buildReturnLoadCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF5E9),
            Color(0xFFFFEEE1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE1C7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // LABEL
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
              "RETURN LOAD",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ROUTE
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Bengaluru → Hyderabad",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: textGrey,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "25 Ton",
                          style: TextStyle(
                            fontSize: 12,
                            color: textGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(width: 13),

                        Icon(
                          Icons.route_rounded,
                          size: 16,
                          color: textGrey,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "560 km",
                          style: TextStyle(
                            fontSize: 12,
                            color: textGrey,
                            fontWeight: FontWeight.w600,
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
                  const Text(
                    "₹ 28,000",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "View details →",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: colours.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // MAIN BUTTON
  // ==========================================================

  Widget _buildMainButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to load search page
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: colours.primaryColor.withOpacity(0.28),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 27,
            ),

            SizedBox(width: 12),

            Text(
              "Load ke liye dekhein",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),

            SizedBox(width: 12),

            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
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
          height: 70,
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

            // TOP ORANGE INDICATOR
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: isSelected ? 35 : 0,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: colours.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Container(
              width: isPostButton ? 42 : 30,
              height: isPostButton ? 42 : 27,
              decoration: isPostButton
                  ? BoxDecoration(
                      color: colours.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colours.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                icon,
                size: isPostButton ? 26 : 22,
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
  // OTHER PAGES
  // Temporary pages until you connect your existing screens
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
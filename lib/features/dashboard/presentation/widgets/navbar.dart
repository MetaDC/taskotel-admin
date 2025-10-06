import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  // ---------------------------
  // Dynamic Nav Items List
  // ---------------------------
  static final List<NavItem> navItems = [
    NavItem("Dashboard", Routes.dashboard),
    NavItem("Clients", Routes.clients),
    NavItem("Hotel Master", Routes.masterHotels),
    NavItem("Subscription Plan", Routes.subscriptionPlans),
    NavItem("Transactions", Routes.transactions),
    NavItem("Reports", Routes.reports),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWid(
      mobile: buildMobileNavbar(context),
      desktop: buildDesktopNavbar(context),
    );
  }

  // ---------------------------
  // Desktop Navbar
  // ---------------------------
  Widget buildDesktopNavbar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1C1C1E),
      elevation: 0,
      titleSpacing: 20,

      title: Row(
        children: [
          logo(),
          const SizedBox(width: 10),
          Text(
            "Taskotel",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 30),
          // loop through navItems
          ...navItems.map((item) => buildNavItem(context, item)).toList(),
          const Spacer(),
          _iconWithBadge(Icons.notifications, 0),
          const SizedBox(width: 20),
          userDropdown(context: context),
        ],
      ),
    );
  }

  Container logo() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Text(
        "T",
        style: GoogleFonts.inter(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ---------------------------
  // Mobile Navbar
  // ---------------------------
  Widget buildMobileNavbar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1C1C1E),
      elevation: 0,
      title: Row(
        children: [
          logo(),
          const SizedBox(width: 10),
          Text(
            "Taskotel",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
      actions: [
        mobileDropDown(isMobile: true, context: context),
        const SizedBox(width: 10),
        _iconWithBadge(Icons.notifications, 0),
        const SizedBox(width: 10),
        userDropdown(isMobile: true, context: context),
      ],
    );
  }

  // ---------------------------
  // Helper Widgets
  // ---------------------------
  Widget buildNavItem(BuildContext context, NavItem item) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isActive =
        currentRoute == item.route || currentRoute.startsWith("${item.route}/");

    return GestureDetector(
      onTap: () {
        if (!isActive) context.go(item.route);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Color(0xff3c83f6) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          item.label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w600,
            fontSize: isActive ? 15 : 14.5,
          ),
        ),
      ),
    );
  }

  Widget _iconWithBadge(IconData icon, int count) {
    return count > 0
        ? Badge(
            label: Text("$count"),
            child: Icon(icon, color: Colors.white),
          )
        : Icon(icon, color: Colors.white);
  }

  Widget mobileDropDown({
    bool isMobile = false,
    required BuildContext context,
  }) {
    return PopupMenuButton<String>(
      color: Colors.white,
      offset: const Offset(0, 40),
      onSelected: (value) {
        final item = navItems.firstWhere(
          (e) => e.label == value,
          orElse: () => NavItem("", ""),
        );
        if (item.route.isNotEmpty) {
          context.go(item.route);
        }
      },
      itemBuilder: (context) {
        return navItems
            .map(
              (item) =>
                  PopupMenuItem(value: item.label, child: Text(item.label)),
            )
            .toList();
      },
      child: Row(
        children: [
          const InkWell(
            radius: 16,

            child: Icon(Icons.settings, color: Colors.white, size: 23),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 8),
            Text(
              "Super Admin",
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Widget userDropdown({bool isMobile = false, required BuildContext context}) {
    return PopupMenuButton<String>(
      color: Colors.white,
      offset: const Offset(0, 40),
      onSelected: (value) {
        if (value == "Settings") {
          // 👉 Navigate to settings page
          // context.go("/settings");
        } else if (value == "Logout") {
          context.read<AuthCubit>().logout(context);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: "Settings",
            child: Row(
              children: [
                Icon(Icons.settings, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                Text("Settings"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: "Logout",
            child: Row(
              children: [
                Icon(Icons.logout, size: 18, color: Colors.black54),
                SizedBox(width: 8),
                Text("Logout"),
              ],
            ),
          ),
        ];
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Color(0xFF4f4f53),
            child: Icon(Icons.person_outlined, color: Colors.white, size: 20),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 8),
            Text(
              "Super Admin",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ],
      ),
    );
  }
}

@override
Size get preferredSize => const Size.fromHeight(60);

// ---------------------------
// Helper Model
// ---------------------------
class NavItem {
  final String label;
  final String route;
  const NavItem(this.label, this.route);
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/routes/routes.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/auth/presentation/cubit/auth_cubit.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

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
          ...navItems.map((item) => _NavItemWidget(item: item)).toList(),
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
        borderRadius: BorderRadius.circular(8),
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
          const CircleAvatar(
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

// ---------------------------
// ✅ Hoverable NavItem Widget
// ---------------------------
class _NavItemWidget extends StatefulWidget {
  final NavItem item;
  const _NavItemWidget({required this.item});

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isActive =
        currentRoute == widget.item.route ||
        currentRoute.startsWith("${widget.item.route}/");

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (!isActive) context.go(widget.item.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xff3c83f6)
                : (isHovered ? const Color(0xFF2A2A2D) : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            widget.item.label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isActive ? 15 : 14.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// Helper Model
// ---------------------------
class NavItem {
  final String label;
  final String route;
  const NavItem(this.label, this.route);
}

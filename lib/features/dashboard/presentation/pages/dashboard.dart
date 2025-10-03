import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/dashboard/presentation/widgets/navbar.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Navbar(),
      ),
      body: ResponsiveWid(
        mobile: Column(children: [Expanded(child: child)]),
        desktop: Column(children: [Expanded(child: child)]),
      ),
    );
  }
}

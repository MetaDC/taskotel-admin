import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';

class PageHeaderWithButton extends StatelessWidget {
  final String heading;
  final String subHeading;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const PageHeaderWithButton({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWid(
      mobile: _buildMobileLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.headerHeading),
        Text(subHeading, style: AppTextStyles.headerSubheading),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: _buttonStyle(),
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: Text(buttonText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading, style: AppTextStyles.headerHeading),
            Text(subHeading, style: AppTextStyles.headerSubheading),
          ],
        ),
        ElevatedButton.icon(
          style: _buttonStyle(),
          onPressed: onButtonPressed,
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: Text(buttonText),
        ),
      ],
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff3c83f6),
      overlayColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class PageHeaderWithTitle extends StatelessWidget {
  String heading;
  String subHeading;

  PageHeaderWithTitle({
    super.key,
    required this.heading,
    required this.subHeading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.headerHeading),
        Text(subHeading, style: AppTextStyles.headerSubheading),
      ],
    );
  }
}

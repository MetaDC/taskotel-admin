import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';

class PageHeaderWithButton extends StatelessWidget {
  String heading;
  String subHeading;
  String buttonText;
  VoidCallback onButtonPressed;
  PageHeaderWithButton({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading, style: AppTextStyles.headerHeading),
            Text(subHeading, style: AppTextStyles.headerSubheading),
          ],
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff3c83f6),
            overlayColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            onButtonPressed();
          },
          icon: const Icon(Icons.add, size: 16, color: Colors.white),
          label: Text(buttonText),
        ),
      ],
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

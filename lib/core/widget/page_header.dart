import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';

class PageHeader extends StatelessWidget {
  String heading;
  String subHeading;
  String buttonText;
  VoidCallback onButtonPressed;
  PageHeader({
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
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            onButtonPressed();
          },
          icon: const Icon(Icons.add),
          label: Text(buttonText),
        ),
      ],
    );
  }
}

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
            Text(
              heading,
              style: true
                  ? TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    )
                  : AppTextStyles.headerHeading,
            ),
            Text(
              subHeading,
              style: true
                  ? TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff64748b),
                    )
                  : AppTextStyles.headerSubheading,
            ),
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

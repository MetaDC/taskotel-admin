// core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final headerHeading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static final headerSubheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.slateGray,
  );
  static final tabelHeader = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.slateGray,
  );
  static final dialogHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
  static final textFieldTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.primary,
  );

  // Navigation
  static final navBarItems = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  //stat cards styles
  static final statCardLabel = GoogleFonts.albertSans(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.slateGray,
  );
  static final statCardValue = GoogleFonts.albertSans(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static final hintText = GoogleFonts.albertSans(
    fontSize: 16,
    color: AppColors.slateGray,
    fontWeight: FontWeight.w400,
  );
}

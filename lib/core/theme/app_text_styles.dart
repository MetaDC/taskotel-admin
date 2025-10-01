// core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final headerHeading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  );
  static final headerSubheading = TextStyle(
    fontSize: 15,
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
    fontSize: 14,
    fontWeight: FontWeight.w500,
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

  // ============ TABLE STYLES ============

  // Table Row Primary Text (Bold text like names, IDs)
  static final tableRowPrimary = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: AppColors.textBlackColor,
  );

  // Table Row Secondary Text (Smaller, gray text)
  static final tableRowSecondary = TextStyle(
    fontSize: 13.5,
    color: AppColors.slateGray,
  );

  // Table Row Normal Text (Regular data)
  static final tableRowNormal = TextStyle(
    fontSize: 14,
    color: AppColors.textBlackColor,
    fontWeight: FontWeight.w500,
  );

  // Table Row Bold Numbers/Values
  static final tableRowBoldValue = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.textBlackColor,
  );

  // Table Row Regular Text
  static final tableRowRegular = TextStyle(
    fontSize: 14,
    color: AppColors.textBlackColor,
  );

  // Table Row Date Text
  static final tableRowDate = TextStyle(
    fontSize: 15,
    color: AppColors.textBlackColor,
  );
}

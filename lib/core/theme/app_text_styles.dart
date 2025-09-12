// core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final heading = GoogleFonts.albertSans(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  static final heading2 = GoogleFonts.albertSans(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final hintText = GoogleFonts.albertSans(
    fontSize: 16,
    color: AppColors.grey2,
    fontWeight: FontWeight.w400,
  );
  static final label = GoogleFonts.albertSans(
    fontSize: 12,
    color: AppColors.grey2,
    fontWeight: FontWeight.w700,
  );

  static final button = GoogleFonts.albertSans(
    fontSize: 16,
    // color: AppColors.white,
  );

  static final formtitle = GoogleFonts.albertSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final appBarHeading = GoogleFonts.albertSans(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
}

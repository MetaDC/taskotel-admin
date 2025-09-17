// core/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // NEW
  static final headerHeading = GoogleFonts.albertSans(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static final headerSubheading = GoogleFonts.albertSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.grey.shade500,
  );
  // Navigation
  static final navBarItems = GoogleFonts.albertSans(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // Headings
  static final heading1 = GoogleFonts.albertSans(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final heading2 = GoogleFonts.albertSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static final heading3 = GoogleFonts.albertSans(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // Body text
  static final body1 = GoogleFonts.albertSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  static final body2 = GoogleFonts.albertSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  // Caption
  static final caption = GoogleFonts.albertSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  // Button text
  static final button = GoogleFonts.albertSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

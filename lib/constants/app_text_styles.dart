import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heroTitle => GoogleFonts.syne(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -2,
        color: AppColors.textPrimary,
      );

  static TextStyle get heroTitleMobile => GoogleFonts.syne(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get sectionTitle => GoogleFonts.syne(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get sectionTitleMobile => GoogleFonts.syne(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -1,
        color: AppColors.textPrimary,
      );

  static const TextStyle sectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.5,
    color: AppColors.accent,
  );

  static TextStyle get cardTitle => GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.8,
    color: AppColors.textMuted,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.75,
    color: AppColors.textMuted,
  );

  static const TextStyle navLink = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textMuted,
  );

  static TextStyle get statNumber => GoogleFonts.syne(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        height: 1,
        color: AppColors.textPrimary,
      );

  static const TextStyle statLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.bgPrimary,
  );
}

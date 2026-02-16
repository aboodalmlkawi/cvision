import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {

  // Big headlines (H1)
  static TextStyle get h1 => GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Intermediate headings (H2)
  static TextStyle get h2 => GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Section Titles
  static TextStyle get sectionTitle => GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryAccent,
  );

  // Regular texts (Body)
  static TextStyle get body => GoogleFonts.cairo(
    fontSize: 14,
    color: Colors.white70,
  );

  // Button Text
  static TextStyle get button => GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Hints
  static TextStyle get caption => GoogleFonts.cairo(
    fontSize: 12,
    color: Colors.grey,
  );
}
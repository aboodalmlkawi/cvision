import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const Color background = Color(0xFF1A1A1D);
  static const Color surface = Color(0xFF2C2C2E);

  // Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Color gradient for cards
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF3E3E42), Color(0xFF2C2C2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Additional colors
  static const Color primaryAccent = Color(0xFFAB47BC); // بنفسجي فاتح
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
}
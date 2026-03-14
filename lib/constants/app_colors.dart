import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF8B5CF6); // Violet
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  
  // Game Feedback
  static const Color correct = Color(0xFF10B981); // Emerald
  static const Color wrong = Color(0xFFEF4444); // Red
  
  // Neutral
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF94A3B8);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Deep Ocean palette
  static const Color deepOcean = Color(0xFF0A1628);
  static const Color oceanBlue = Color(0xFF0D2B4E);
  static const Color midBlue = Color(0xFF0E4D8B);
  static const Color brightBlue = Color(0xFF1A7FD4);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentTeal = Color(0xFF00B8A0);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFE8F4FD);
  static const Color glassWhite = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color errorRed = Color(0xFFFF4757);
  static const Color successGreen = Color(0xFF2ED573);
  static const Color warningAmber = Color(0xFFFFD93D);

  // Gradient definitions
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepOcean, oceanBlue, Color(0xFF0A2040)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x26FFFFFF), Color(0x0DFFFFFF)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [brightBlue, accentCyan],
  );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.deepOcean,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.brightBlue,
          secondary: AppColors.accentCyan,
          surface: AppColors.oceanBlue,
          error: AppColors.errorRed,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: GoogleFonts.orbitron(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.pureWhite,
            letterSpacing: 2,
          ),
          displayMedium: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.pureWhite,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.pureWhite,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.softWhite,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.softWhite,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.accentCyan,
            letterSpacing: 0.8,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        useMaterial3: true,
      );
}

// Helper extensions
extension CurrencyFormat on double {
  String toUSD() {
    if (this >= 1000000) {
      return '\$${(this / 1000000).toStringAsFixed(2)}M';
    } else if (this >= 1000) {
      return '\$${(this / 1000).toStringAsFixed(1)}K';
    }
    return '\$${toStringAsFixed(0)}';
  }

  String toFullUSD() {
    final parts = toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final formatted = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '\$$formatted.$decPart';
  }
}

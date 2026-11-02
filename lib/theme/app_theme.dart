import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary900 = Color(0xFF1F3A35),
      primary800 = Color(0xFF294A43),
      primary700 = Color(0xFF365D54),
      primary600 = Color(0xFF447268),
      primary500 = Color(0xFF557F75),
      primary100 = Color(0xFFE6EFEC),
      primary050 = Color(0xFFF3F7F6);
  static const accent500 = Color(0xFFC98952),
      neutral950 = Color(0xFF171A19),
      neutral800 = Color(0xFF363B39),
      neutral700 = Color(0xFF505653),
      neutral600 = Color(0xFF6D736F),
      neutral500 = Color(0xFF8A908C),
      neutral400 = Color(0xFFA7ACA9),
      neutral300 = Color(0xFFC6CAC7),
      neutral200 = Color(0xFFDEE1DF),
      neutral100 = Color(0xFFECEFED),
      neutral050 = Color(0xFFF7F8F7);
  static const success700 = Color(0xFF2F6B4F),
      success100 = Color(0xFFE4F2EA),
      error700 = Color(0xFFB23A3A),
      error100 = Color(0xFFFBE7E7),
      warning700 = Color(0xFF9A6817),
      warning100 = Color(0xFFFFF1D4),
      info700 = Color(0xFF35698F),
      info100 = Color(0xFFE5F0F8);
}

abstract final class AppTheme {
  static ThemeData get light {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.neutral300),
    );
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.neutral050,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary800,
        primary: AppColors.primary800,
        surface: Colors.white,
        error: AppColors.error700,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -.5,
          color: AppColors.neutral950,
        ),
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: AppColors.neutral950,
        ),
        headlineMedium: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          height: 1.25,
          color: AppColors.neutral950,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.neutral950,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.neutral950,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.neutral950,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: AppColors.neutral600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.primary600, width: 1.5),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error700),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error700, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.neutral500, fontSize: 14),
        errorStyle: const TextStyle(color: AppColors.error700, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 48),
          backgroundColor: AppColors.primary800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: AppColors.neutral800,
          side: const BorderSide(color: AppColors.neutral300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.neutral950,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

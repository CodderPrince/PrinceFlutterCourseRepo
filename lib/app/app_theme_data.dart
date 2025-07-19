import 'package:craft_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData get lightThemeData {
    return ThemeData(
      fontFamily: 'Poppins',
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: AppColors.getMaterialColor(AppColors.themeColor),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        headlineLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.teal,
        ),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.themeColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        border: buildOutlineInputBorder(),
        focusedBorder: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        hintStyle: TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.themeColor),
    );
  }
}

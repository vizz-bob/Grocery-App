import 'package:flutter/material.dart';
import 'bhejdu_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    fontFamily: "Poppins",
    scaffoldBackgroundColor: BhejduColors.bgLight,
    primaryColor: BhejduColors.primaryBlue,

    appBarTheme: const AppBarTheme(
      backgroundColor: BhejduColors.primaryBlue,
      elevation: 0,
      toolbarHeight: 65,
      centerTitle: true,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    cardTheme: const CardThemeData(
      color: BhejduColors.white,
      elevation: 3,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: BhejduColors.primaryBlue,
      unselectedItemColor: BhejduColors.textGrey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: BhejduColors.white,
      type: BottomNavigationBarType.fixed,
      elevation: 12,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: BhejduColors.textDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: BhejduColors.textDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: BhejduColors.textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: BhejduColors.textGrey,
      ),
    ),
  );
}

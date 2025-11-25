import 'package:admin/widgets/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData getTheme() {
  return ThemeData(
    hoverColor: const Color.fromRGBO(64, 202, 251, 0.35),

    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    dividerColor: Colors.grey,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(64, 202, 251, 0.95),
      inverseSurface: const Color(0xFFD9F6FF),
      onPrimary: const Color(0xFFF7FDFF),
    ),
    useMaterial3: true,
    primaryColorDark: const Color(0XFF0082B0),
    primaryColorLight: const Color.fromRGBO(255, 255, 255, 1.06),
    primaryColor: const Color.fromRGBO(4, 130, 176, 1),
    secondaryHeaderColor: const Color.fromRGBO(0, 130, 176, 1),
    disabledColor: const Color.fromRGBO(126, 134, 153, 1),
    // secondaryHeaderColor: const Color.fromRGBO(45, 62, 82, 1),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      labelStyle: TextStyle(
        color: Color(0xFF8998A8), // Label color
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    tabBarTheme: TabBarThemeData(
      indicatorColor: AppColors.darkBlueColor,
    ),

    drawerTheme: DrawerThemeData(backgroundColor: AppColors.darkBlueColor),
    appBarTheme: AppBarTheme(
      backgroundColor:
          const Color.fromRGBO(64, 202, 251, 0.95), // Set app bar color
      iconTheme: IconThemeData(color: AppColors.darkBlueColor),
      actionsIconTheme: IconThemeData(
        color: AppColors.darkBlueColor,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
    ),

    iconTheme: IconThemeData(
      color: AppColors.darkBlueColor,
    ),
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color.fromRGBO(45, 62, 82, 1),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF4B545C), // Cursor color
      selectionColor: Color(0xFF8998A8), // Selection highlight color
      selectionHandleColor: Color(0xFFC7EEFF), // Handle color
    ),
    focusColor: const Color(0xffd51820),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 17,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 10,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 36,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
      ),
      headlineLarge: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 20,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 28,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(45, 62, 82, 1),
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: const TextStyle(
        color: Color.fromRGBO(126, 134, 153, 1),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(64, 202, 251, 0.95),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0XFF0082B0),
        onPrimary: Color.fromRGBO(64, 202, 251, 0.95),
        secondary: Colors.grey,
        onSecondary: Color(0xFF459BBA),
        error: Color(0xffd51820),
        onError: Color(0xffd51820),
        surface: Colors.white,
        onSurface: Color.fromRGBO(64, 202, 251, 0.95),
      ),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    primaryColorDark: const Color(0XFF0082B0),
    disabledColor: const Color.fromRGBO(126, 134, 153, 1),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0XFF0082B0),
        onPrimary: Colors.grey,
        secondary: Colors.grey,
        onSecondary: Color(0xFF459BBA),
        error: Color(0xffd51820),
        onError: Color(0xffd51820),
        surface: Colors.white,
        onSurface: Colors.white,
      ),
    ),
    dividerColor: Colors.white,
    hoverColor: const Color.fromRGBO(64, 202, 251, 0.35),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromRGBO(64, 202, 251, 0.95),
      inverseSurface: AppColors.darkBlueColor,
      onPrimary: const Color.fromRGBO(46, 42, 42, 0.9019607843137255),
      brightness:
          Brightness.dark, // Set light or dark mode explicitly if needed
    ),
    useMaterial3: true,
    primaryColorLight: const Color.fromRGBO(46, 42, 42, 0.9019607843137255),
    primaryColor: const Color.fromRGBO(4, 130, 176, 1),
    secondaryHeaderColor: const Color(0xFF0082B0),
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: Color.fromRGBO(45, 62, 82, 1),
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: Brightness.dark,
      barBackgroundColor: AppColors.darkBlueColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      labelStyle: TextStyle(
        color: Color(0xFF8998A8), // Label color
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
    tabBarTheme: const TabBarThemeData(
      indicatorColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor:
          const Color.fromRGBO(64, 202, 251, 0.95), // Set app bar color
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.darkBlueColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white54),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF4B545C), // Cursor color
      selectionColor: Color(0xFF8998A8), // Selection highlight color
      selectionHandleColor: Color(0xFFC7EEFF), // Handle color
    ),
    focusColor: const Color(0xffd51820),
    textTheme: const TextTheme(
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 36,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w900,
      ),
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        color: Color.fromRGBO(124, 124, 124, 1),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor:
        const Color.fromRGBO(46, 42, 42, 0.9019607843137255),
    // Transparent black background
  );
}

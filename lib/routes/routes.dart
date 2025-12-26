import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:password_book_flutter/pages/ui/colors.dart';

import '../pages/Home/Generate/Generate.dart';
import '../pages/Home/Password/AddPassword.dart';
import '../pages/Home/Password/PasswordDetails.dart';
import '../pages/Login/Login.dart';
import '../pages/MainView/MainView.dart';
import '../pages/Registry/Registry.dart';
import '../pages/SplashScreen/SplashScreen.dart';

// 白天主题配置
ThemeData get lightTheme {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'myFont',
    brightness: Brightness.light,
    scaffoldBackgroundColor: colorWhite,
    appBarTheme: const AppBarTheme(
      backgroundColor: colorWhite,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: colorPrimary,
      secondary: colorDark,
      tertiary: colorInputBorder,
      surface: colorWhite,
      onSurface: colorDark,
      background: colorWhite,
      onBackground: colorDark,
      error: colorPrimary,
      onError: colorWhite,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: colorDark),
      bodyMedium: TextStyle(color: colorDark),
      bodySmall: TextStyle(color: colorDark),
      titleLarge: TextStyle(color: colorDark),
      titleMedium: TextStyle(color: colorDark),
      titleSmall: TextStyle(color: colorDark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: colorWhite,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorPrimary,
        side: const BorderSide(color: colorInputBorder),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: colorInputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorInputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorPrimary),
      ),
    ),
    cardTheme: const CardThemeData(
      color: colorWhite,
    ),
  );
}

// 黑夜主题配置
ThemeData get darkTheme {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'myFont',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colorDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: colorDark,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: colorPrimary,
      secondary: colorDark,
      tertiary: colorGray,
      surface: colorDark,
      onSurface: colorWhite,
      background: colorDark,
      onBackground: colorWhite,
      error: colorPrimary,
      onError: colorWhite,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: colorWhite),
      bodyMedium: TextStyle(color: colorWhite),
      bodySmall: TextStyle(color: colorWhite),
      titleLarge: TextStyle(color: colorWhite),
      titleMedium: TextStyle(color: colorWhite),
      titleSmall: TextStyle(color: colorWhite),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorPrimary,
        foregroundColor: colorWhite,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorPrimary,
        side: const BorderSide(color: colorWhite),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: colorWhite),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorWhite),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorPrimary),
      ),
    ),
    cardTheme: const CardThemeData(
      color: colorDark,
    ),
  );
}

List<GetPage> getRoutes(){
  return [
    GetPage(name: "/Main", page: () => Mainview()),
    GetPage(name: "/Login", page: () => Login()),
    GetPage(name: "/Registry", page: () => Registry()),
    GetPage(name: "/SplashScreen", page: () => SplashScreen()),
    GetPage(name: '/Password', page: () => Addpassword()),
    GetPage(name: '/details', page: () => PasswordDetails()),
    GetPage(name: '/generate', page: () => Generate())
  ];
}
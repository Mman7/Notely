import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//TODO set dark editor text color

final myTheme = ThemeData(
    textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF44339D)),
        bodyMedium: TextStyle(color: Color(0xFF44339D)),
        headlineSmall: TextStyle(color: Color(0xFF44339D)),
        headlineLarge: TextStyle(color: Color(0xFF44339D)),
        labelLarge: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Color(0xFF44339D))),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Color(0xFF44339D))),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: HexColor('#504099'),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      unselectedItemColor: HexColor('#E9E6FD'),
      showUnselectedLabels: false,
    ),
    primaryColor: Color(0xFFA291FF),
    colorScheme: ColorScheme.light().copyWith(
        tertiary: Color(0xFFFFFFFF),
        primary: const Color.fromARGB(255, 163, 145, 255),
        secondary: const Color(0xFF44339D),
        surfaceBright: Color(0xFF44339D),
        surface: const Color(0xFAFAFAFA)));

final myDarkTheme = ThemeData(
    textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.grey),
        bodySmall: TextStyle(color: Colors.white)),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Colors.black)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: HexColor('#504099'),
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w500,
      ),
      unselectedItemColor: HexColor('#E9E6FD'),
      showUnselectedLabels: false,
    ),
    primaryColor: Color(0xFFA291FF),
    colorScheme: ColorScheme.light().copyWith(
        primary: const Color(0xFF44339C),
        secondary: const Color(0xFF0F0F41),
        tertiary: Color(0xFF333333),
        surfaceBright: Color(0xFFD1CCFC),
        surface: const Color(0xFF222222)));

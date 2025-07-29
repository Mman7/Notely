import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

//TODO setup dark mode finish this up
final myTheme = ThemeData(
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.orange,
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
        primary: const Color(0xFF917EF3),
        secondary: const Color(0xFF44339D),
        surfaceBright: Color(0xFFD1CCFC),
        surface: const Color(0xFFFAFAFA)));

final darkTheme = ThemeData(
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.orange,
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
    colorScheme: ColorScheme.light().copyWith(
      primary: HexColor('#504099'),
      secondary: HexColor('#E9E6FD'),
    ));

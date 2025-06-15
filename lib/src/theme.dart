import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

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
    colorScheme: ColorScheme.light().copyWith(
        primary: HexColor('#504099'),
        secondary: HexColor('#E9E6FD'),
        surface: HexColor('#F9F8FD')));

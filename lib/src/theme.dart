import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

final myTheme = ThemeData(
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.orange,
      filled: true,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: hexToColor('#504099'),
      unselectedItemColor: hexToColor('#E9E6FD'),
    ),
    colorScheme: ColorScheme.light().copyWith(
        primary: hexToColor('#504099'),
        secondary: hexToColor('#E9E6FD'),
        surface: hexToColor('#F9F8FD')));

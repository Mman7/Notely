import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
PopupMenuItem<dynamic> CustomPopupMenuItem(
    {VoidCallback? onTap, IconData? icon, String? text}) {
  return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
          ),
          Text(' $text')
        ],
      ));
}

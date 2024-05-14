import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPress;
  final Icon icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child:
          TextButton.icon(onPressed: onPress, icon: icon, label: Text(label)),
    );
  }
}

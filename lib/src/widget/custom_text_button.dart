import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class CustomTextButton extends StatelessWidget {
  CustomTextButton(
      {super.key,
      this.showText = true,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.isSelected});
  bool showText;
  bool? isSelected = false;
  IconData icon;
  String text;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    var isExtended = context.read<AppProvider>().isSidebarExtended;

    /// this prevent text rebuild
    isExtendedText() {
      Widget textWidget = Expanded(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ).animate().slideX(begin: 10, end: 0, curve: Curves.bounceIn),
      );

      // if sidebar is extended text widget will not rebuild
      return isExtended
          ? textWidget
          : FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 125)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return textWidget;
                } else {
                  return Container();
                }
              });
    }

    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(7.5),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(icon), showText ? isExtendedText() : Container()],
            ),
          ),
        ),
      ),
    );
  }
}

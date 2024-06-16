import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed,
      this.borderRadiusValue = BorderRadius.zero,
      this.textColor = Colors.black,
      this.bgColor = Colors.transparent,
      this.btnColor = Colors.black,
      this.margin = EdgeInsets.zero});
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color? btnColor;
  final Color bgColor;
  final Color textColor;
  final EdgeInsets margin;
  final BorderRadius borderRadiusValue;

  @override
  Widget build(BuildContext context) {
    var isExtended = context.read<AppProvider>().isSidebarExtended;

    /// this function prevent text rebuild
    isExtendedText() {
      Widget textWidget = Expanded(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w500, color: textColor),
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
      // height: 35,
      margin: margin,
      child: Material(
        borderRadius: borderRadiusValue,
        color: bgColor,
        child: InkWell(
          borderRadius: borderRadiusValue,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: btnColor,
                ),
                isExtended ? isExtendedText() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

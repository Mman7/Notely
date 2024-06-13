import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:syncnote/src/provider/app_provider.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.showText = true,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.specialBtn = false,
  });
  final bool showText;
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool specialBtn;

  @override
  Widget build(BuildContext context) {
    var isExtended = context.read<AppProvider>().isSidebarExtended;

    /// this function prevent text rebuild
    isExtendedText() {
      Widget textWidget = Expanded(
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: specialBtn ? Colors.white : Colors.black),
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
        borderRadius: BorderRadius.circular(7.5),
        color: specialBtn ? Colors.redAccent : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7.5),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: specialBtn ? Colors.white : Colors.black,
                ),
                showText ? isExtendedText() : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

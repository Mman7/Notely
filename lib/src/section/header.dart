import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Text(
          'Welcome to MeloNote',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }
}

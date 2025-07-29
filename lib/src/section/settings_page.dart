import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  size: 25.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                trailing: Switch(
                    value: _isSwitch,
                    onChanged: (value) {
                      setState(() => _isSwitch = !_isSwitch);
                    }),
                onTap: () {
                  setState(() => _isSwitch = !_isSwitch);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

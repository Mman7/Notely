import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:melonote/src/provider/app_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitch = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      _isSwitch = context.read<AppProvider>().isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    toggle() {
      setState(() => _isSwitch = !_isSwitch);
      context.read<AppProvider>().darkModeToggle();
    }

    DeviceType deviceType = context.read<AppProvider>().getDeviceType();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FractionallySizedBox(
          widthFactor: deviceType == DeviceType.windows ||
                  deviceType == DeviceType.tablet
              ? 0.7
              : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  size: 25.sp,
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
                ),
                trailing:
                    Switch(value: _isSwitch, onChanged: (value) => toggle()),
                onTap: () => toggle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

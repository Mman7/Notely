import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainer)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OptionBtn(
              title: 'Enable Dark Mode',
              icon: Icons.dark_mode_outlined,
              isSwitch: context.read<AppStatus>().isDarkMode,
              callback: () {
                context.read<AppStatus>().darkModeToggle();
              },
            ),
            Gap(10),
            Tooltip(
              message:
                  'Automatically sync notes between devices when changes are made.',
              child: OptionBtn(
                title: 'Enable Automatic Sync',
                icon: Icons.sync,
                isSwitch: context.read<AppStatus>().isSyncing,
                callback: () {
                  context.read<AppStatus>().toggleIsSyncing();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionBtn extends StatefulWidget {
  const OptionBtn(
      {super.key,
      required this.callback,
      required this.isSwitch,
      required this.title,
      required this.icon});

  final VoidCallback callback;
  final bool isSwitch;
  final String title;
  final IconData icon;

  @override
  State<OptionBtn> createState() => _OptionBtnState();
}

class _OptionBtnState extends State<OptionBtn> {
  bool _isSwitch = false;

  @override
  initState() {
    super.initState();
    _isSwitch = widget.isSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              setState(() => _isSwitch = !_isSwitch);
              widget.callback();
            },
            child: Row(children: [
              Icon(
                widget.icon,
                size: 25.sp,
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
              Gap(15),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
              Expanded(child: Container()),
              Switch(
                  value: _isSwitch,
                  onChanged: (value) {
                    setState(() => _isSwitch = value);
                    widget.callback();
                  }),
            ])));
  }
}

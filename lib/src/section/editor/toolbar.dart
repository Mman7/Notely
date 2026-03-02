import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notely/src/provider/app_status.dart';
import 'package:provider/provider.dart';

class Toolbar extends StatelessWidget {
  Toolbar(
      {super.key,
      required QuillController controller,
      required this.deviceType})
      : _controller = controller;

  final QuillController _controller;
  DeviceType deviceType;

  static Map<String, String> _fontFamilyItems() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return const {
          'Arial': 'Arial',
          'Calibri': 'Calibri',
          'Cambria': 'Cambria',
          'Georgia': 'Georgia',
          'Segoe UI': 'Segoe UI',
          'Times New Roman': 'Times New Roman',
          'Courier New': 'Courier New',
          'Consolas': 'Consolas',
          'Clear': 'Clear',
        };
      case TargetPlatform.macOS:
        return const {
          'Arial': 'Arial',
          'Helvetica': 'Helvetica',
          'Helvetica Neue': 'Helvetica Neue',
          'Avenir': 'Avenir',
          'Georgia': 'Georgia',
          'Times': 'Times',
          'Courier': 'Courier',
          'Menlo': 'Menlo',
          'Clear': 'Clear',
        };
      case TargetPlatform.linux:
        return const {
          'Liberation Sans': 'Liberation Sans',
          'Liberation Serif': 'Liberation Serif',
          'Liberation Mono': 'Liberation Mono',
          'DejaVu Sans': 'DejaVu Sans',
          'DejaVu Serif': 'DejaVu Serif',
          'DejaVu Sans Mono': 'DejaVu Sans Mono',
          'sans-serif': 'sans-serif',
          'serif': 'serif',
          'monospace': 'monospace',
          'Clear': 'Clear',
        };
      case TargetPlatform.android:
        return const {
          'sans-serif': 'sans-serif',
          'Roboto': 'Roboto',
          'sans-serif-medium': 'sans-serif-medium',
          'serif': 'serif',
          'Noto Serif': 'Noto Serif',
          'monospace': 'monospace',
          'Clear': 'Clear',
        };
      case TargetPlatform.iOS:
        return const {
          'San Francisco': '.SF Pro Text',
          'Helvetica Neue': 'Helvetica Neue',
          'Avenir Next': 'Avenir Next',
          'Georgia': 'Georgia',
          'Times New Roman': 'Times New Roman',
          'Courier': 'Courier',
          'Menlo': 'Menlo',
          'Clear': 'Clear',
        };
      case TargetPlatform.fuchsia:
        return const {
          'sans-serif': 'sans-serif',
          'serif': 'serif',
          'monospace': 'monospace',
          'Clear': 'Clear',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 15,
                offset: Offset(0, 2),
                spreadRadius: 1),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          controller: ScrollController(),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Theme(
              data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        onSurface: context.watch<AppStatus>().isDarkMode
                            ? Colors.white
                            : Colors.black,
                        primary: Colors.blue,
                      )),
              child: QuillSimpleToolbar(
                  controller: _controller,
                  config: QuillSimpleToolbarConfig(
                    color: Colors.red,
                    axis: Axis.horizontal,
                    buttonOptions: QuillSimpleToolbarButtonOptions(
                        fontFamily: QuillToolbarFontFamilyButtonOptions(
                          items: _fontFamilyItems(),
                          renderFontFamilies: true,
                        ),
                        backgroundColor: QuillToolbarColorButtonOptions(),
                        base: QuillToolbarBaseButtonOptions(
                            iconTheme: QuillIconTheme(
                                iconButtonUnselectedData: IconButtonData(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color),
                                iconButtonSelectedData:
                                    IconButtonData(style: ButtonStyle())))),
                  )),
            ),
          ),
        ));
  }
}

import 'package:ai_assistant/common/theme/app_theme.dart';
import 'package:flutter/material.dart';

Future<void> showThemeModeDialog(
    BuildContext context, AppTheme themeNotifier, ThemeMode currentMode) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Theme Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light Mode'),
              value: ThemeMode.light,
              groupValue: currentMode,
              onChanged: (ThemeMode? value) {
                themeNotifier.setLightMode();
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark Mode'),
              value: ThemeMode.dark,
              groupValue: currentMode,
              onChanged: (ThemeMode? value) {
                themeNotifier.setDarkMode();
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System Default'),
              value: ThemeMode.system,
              groupValue: currentMode,
              onChanged: (ThemeMode? value) {
                themeNotifier.setSystemMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

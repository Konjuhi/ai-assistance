import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_color_extension.dart';
import 'app_typography_extension.dart';

final themeProvider = ChangeNotifierProvider<AppTheme>((ref) => AppTheme());

class AppTheme with ChangeNotifier {
  static const String _themeModeKey = 'themeMode';

  ThemeMode _themeMode = ThemeMode.system;
  Brightness _brightness = Brightness.light;

  AppTheme() {
    _loadThemeFromPreferences();
  }

  ThemeMode get themeMode => _themeMode;
  Brightness get brightness => _brightness;
  Brightness get platformBrightness =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  ThemeData get lightTheme => light(brightness: Brightness.light);
  ThemeData get darkTheme => dark(brightness: Brightness.dark);

  ThemeData get theme {
    if (_themeMode == ThemeMode.light) return lightTheme;
    if (_themeMode == ThemeMode.dark) return darkTheme;
    return platformBrightness == Brightness.dark ? darkTheme : lightTheme;
  }

  void setLightMode() {
    _themeMode = ThemeMode.light;
    _brightness = Brightness.light;
    _saveThemeToPreferences(_themeMode);
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = ThemeMode.dark;
    _brightness = Brightness.dark;
    _saveThemeToPreferences(_themeMode);
    notifyListeners();
  }

  void setSystemMode() {
    _themeMode = ThemeMode.system;
    _brightness = platformBrightness;
    _saveThemeToPreferences(_themeMode);
    notifyListeners();
  }

  Future<void> _saveThemeToPreferences(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;

    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  static ThemeData light({required Brightness brightness}) {
    const colors = AppColorsExtension.light;
    const typography = AppTypographyExtension.light;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.scaffoldBackground,
      textTheme: _buildTextTheme(typography),
      pageTransitionsTheme: _pageTransitionTheme(),
      inputDecorationTheme:
          InputDecorationTheme(labelStyle: TextStyle(color: colors.paragraph)),
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: colors.paragraph,
      ),
      extensions: const [colors, typography],
    );
  }

  static ThemeData dark({required Brightness brightness}) {
    const colors = AppColorsExtension.dark;
    const typography = AppTypographyExtension.dark;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.scaffoldBackground,
      textTheme: _buildTextTheme(typography),
      inputDecorationTheme:
          InputDecorationTheme(labelStyle: TextStyle(color: colors.paragraph)),
      pageTransitionsTheme: _pageTransitionTheme(),
      colorScheme: ColorScheme.fromSeed(
        brightness: brightness,
        seedColor: colors.paragraph,
      ),
      extensions: const [colors, typography],
    );
  }

  static TextTheme _buildTextTheme(AppTypographyExtension typography) {
    return TextTheme(
      headlineLarge: typography.headlineLarge,
      headlineMedium: typography.headlineMedium,
      headlineSmall: typography.headlineSmall,
      titleLarge: typography.titleLarge,
      titleSmall: typography.titleSmall,
      bodyLarge: typography.bodyLarge,
      bodyMedium: typography.bodyMedium,
      bodySmall: typography.bodySmall,
      labelMedium: typography.labelMedium,
      displayMedium: typography.displayMedium,
    );
  }

  static PageTransitionsTheme _pageTransitionTheme() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }
}

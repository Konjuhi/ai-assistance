import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color title;
  final Color paragraph;
  final Color scaffoldBackground;

  const AppColorsExtension({
    required this.title,
    required this.paragraph,
    required this.scaffoldBackground,
  });

  static const light = AppColorsExtension(
    title: AppColorsExtensionLight.title,
    paragraph: AppColorsExtensionLight.paragraph,
    scaffoldBackground: AppColorsExtensionLight.scaffoldBackground,
  );

  static const dark = AppColorsExtension(
    title: AppColorsExtensionDark.title,
    paragraph: AppColorsExtensionDark.paragraph,
    scaffoldBackground: AppColorsExtensionDark.scaffoldBackground,
  );

  @override
  AppColorsExtension copyWith(
      {Color? title, Color? paragraph, Color? scaffoldBackground}) {
    return AppColorsExtension(
        title: title ?? this.title,
        paragraph: paragraph ?? this.paragraph,
        scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground);
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;

    return AppColorsExtension(
        title: Color.lerp(title, other.title, t) ?? title,
        paragraph: Color.lerp(paragraph, other.paragraph, t) ?? paragraph,
        scaffoldBackground:
            Color.lerp(scaffoldBackground, other.scaffoldBackground, t) ??
                scaffoldBackground);
  }
}

class AppColorsExtensionLight {
  const AppColorsExtensionLight();

  static const Color title = Color(0xFF301B39);
  static const Color paragraph = Color(0xFF5A366F);
  static const scaffoldBackground = Color(0xFFFDFEFA);
}

class AppColorsExtensionDark {
  const AppColorsExtensionDark();

  static const Color title = Color(0xFFCEDEFF);
  static const Color paragraph = Color(0xFFA6C990);

  static const scaffoldBackground = Color(0xFF121212);
}

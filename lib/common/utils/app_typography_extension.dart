import 'package:flutter/material.dart';

import 'app_color_extension.dart';
import 'assets.dart';

class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  const AppTypographyExtension({
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelMedium,
    required this.displayMedium,
  });

  final TextStyle headlineSmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelMedium;
  final TextStyle displayMedium;

  static const light = AppTypographyExtension(
    headlineLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 32,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Headline - Large | usage: Page title',
    ),
    headlineMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 28,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Headline - Medium | usage: Page title',
    ),
    headlineSmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 22,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Headline - Small | usage: Page title',
    ),
    titleLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 22,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Title - Large | usage: Widget title',
    ),
    titleMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Title - Large | usage: Widget title',
    ),
    titleSmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Title - Small | usage: List label',
    ),
    bodyLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Body - Large | usage: Paragraph title, Widget title',
    ),
    bodyMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColorsExtensionLight.paragraph,
      debugLabel: 'figma: Body - Medium | usage: Page description',
    ),
    bodySmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColorsExtensionLight.paragraph,
      debugLabel: 'figma: Body - Small | usage: Page description, '
          'Orchestra page',
    ),
    labelMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColorsExtensionLight.paragraph,
      debugLabel: 'figma: Label - Medium | usage: Text filed Text',
    ),
    displayMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: AppColorsExtensionLight.paragraph,
      debugLabel: 'figma: Display - Medium | usage: Social Button text',
    ),
  );

  static const dark = AppTypographyExtension(
    headlineLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 32,
      color: AppColorsExtensionDark.title,
      debugLabel: 'figma: Headline - Large | usage: Page title',
    ),
    headlineMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 28,
      color: AppColorsExtensionDark.title,
      debugLabel: 'figma: Headline - Medium | usage: Page title',
    ),
    headlineSmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 22,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Headline - Small | usage: Page title',
    ),
    titleLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 22,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Title - Large | usage: Widget title',
    ),
    titleMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: AppColorsExtensionLight.title,
      debugLabel: 'figma: Title - Large | usage: Widget title',
    ),
    titleSmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Title - Small | usage: List label',
    ),
    bodyLarge: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: AppColorsExtensionDark.title,
      debugLabel: 'figma: Body - Large | usage: Paragraph title, Widget title',
    ),
    bodyMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Body - Medium | usage: Page description',
    ),
    bodySmall: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Body - Small | usage: Page description',
    ),
    labelMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Label - Medium | usage: Text filed label',
    ),
    displayMedium: TextStyle(
      fontFamily: Fonts.satoshi,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: AppColorsExtensionDark.paragraph,
      debugLabel: 'figma: Display - Medium | usage: Social Button text',
    ),
  );

  @override
  ThemeExtension<AppTypographyExtension> copyWith({
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelMedium,
    TextStyle? displayMedium,
  }) {
    return AppTypographyExtension(
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      headlineSmall: headlineSmall ?? this.headlineSmall,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelMedium: labelMedium ?? this.labelMedium,
      displayMedium: displayMedium ?? this.displayMedium,
    );
  }

  @override
  ThemeExtension<AppTypographyExtension> lerp(
    covariant ThemeExtension<AppTypographyExtension>? other,
    double t,
  ) {
    if (other is! AppTypographyExtension) return this;
    return AppTypographyExtension(
      headlineLarge: TextStyle.lerp(headlineLarge, other.headlineLarge, t) ??
          light.headlineLarge,
      headlineMedium: TextStyle.lerp(headlineMedium, other.headlineMedium, t) ??
          light.headlineMedium,
      headlineSmall: TextStyle.lerp(headlineSmall, other.headlineSmall, t) ??
          light.headlineSmall,
      titleLarge:
          TextStyle.lerp(titleLarge, other.titleLarge, t) ?? light.titleLarge,
      titleMedium: TextStyle.lerp(titleMedium, other.titleMedium, t) ??
          light.titleMedium,
      titleSmall:
          TextStyle.lerp(titleSmall, other.titleSmall, t) ?? light.titleSmall,
      bodyLarge:
          TextStyle.lerp(bodyLarge, other.bodyLarge, t) ?? light.bodyLarge,
      bodyMedium:
          TextStyle.lerp(bodyMedium, other.bodyMedium, t) ?? light.bodyMedium,
      bodySmall:
          TextStyle.lerp(bodySmall, other.bodySmall, t) ?? light.bodySmall,
      labelMedium: TextStyle.lerp(labelMedium, other.labelMedium, t) ??
          light.labelMedium,
      displayMedium: TextStyle.lerp(displayMedium, other.displayMedium, t) ??
          light.displayMedium,
    );
  }

  @override
  String toString() {
    return 'AppTypography{\n\t'
        'headlineLarge: $headlineLarge \n\t'
        'headlineMedium: $headlineMedium \n\t'
        'headlineSmall: $headlineSmall \n\t'
        'titleLarge: $titleLarge \n\t'
        'titleMedium: $titleMedium \n\t'
        'titleSmall: $titleSmall \n\t'
        'bodyLarge: $bodyLarge \n\t'
        'bodyMedium: $bodyMedium \n\t'
        'bodySmall: $bodySmall \n\t'
        'labelMedium: $labelMedium \n\t'
        'displayMedium: $displayMedium \n'
        '\n}';
  }
}

import 'package:flutter/material.dart';

import 'app_color_extension.dart';

extension ThemeColors on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}

extension ThemeText on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

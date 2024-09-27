import 'package:flutter/material.dart';

extension ThemeText on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

import 'package:flutter/material.dart';

TextStyle? getTextStyle(TextStyle? textStyle) {
  return textStyle?.copyWith();
}

//TODO : apply theme
getAppThemeData(context) {
  return ThemeData(
    textTheme: TextTheme(displayMedium: TextStyle(color: Colors.grey[300], fontSize: 14)),
  );
}

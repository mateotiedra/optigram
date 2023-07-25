import 'package:flutter/material.dart';

class ThemeConfig {
  TextStyle? getTextStyle(TextStyle? textStyle) {
    return textStyle?.copyWith();
  }

  static ThemeData appData = ThemeData(
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.grey[300], fontSize: 14),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: colorPalette['ig-primary-button'],
    ),
  );

  static Color primaryColor = const Color(0xFF2DCFF3);
  static Color secondaryColor = const Color(0xFF7D6AF9);

  static Map<String, Color> colorPalette = {
    'ig-primary-background': const Color(0xFF130C36),
    'ig-secondary-background': const Color(0xFF231C4F),
    'ig-highlight-background': secondaryColor,
    'ig-primary-button': primaryColor,
    //'ig-primary-text': primaryColor,
    'always-dark-overlay': const Color.fromRGBO(0, 0, 0, 0.36),
    'ig-secondary-button-background': Color.fromARGB(255, 17, 11, 46),
    'ig-elevated-separator': const Color.fromARGB(255, 55, 45, 124),
    'ig-separator': const Color.fromARGB(255, 55, 45, 124),
    'messenger-card-background': secondaryColor,
  };
}

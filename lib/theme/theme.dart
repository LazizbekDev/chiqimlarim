import 'package:flutter/material.dart';
import 'colors.dart';
import 'app_text_theme.dart';

ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(
    primary: primaryColor,
    secondary: accentColor,
    surface: backgroundColor,
    onError: error
  ),
  scaffoldBackgroundColor: backgroundColor,
  cardColor: cardColor,
  textTheme: appTextTheme,
);

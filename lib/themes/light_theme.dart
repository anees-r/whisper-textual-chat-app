import 'package:flutter/material.dart';
import 'package:textual_chat_app/app_assets.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppAssets.lightIconColor,
    primaryContainer: AppAssets.lightBackgroundColor,
    secondaryContainer: AppAssets.lightTextColor,
    tertiaryContainer: AppAssets.lightCardColor
  )

);
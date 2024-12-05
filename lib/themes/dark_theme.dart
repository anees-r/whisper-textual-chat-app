import 'package:flutter/material.dart';
import 'package:textual_chat_app/app_assets.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppAssets.darkIconColor,
    primaryContainer: AppAssets.darkBackgroundColor,
    secondaryContainer: AppAssets.darkTextColor,
    tertiaryContainer: AppAssets.darkCardColor
  )
);
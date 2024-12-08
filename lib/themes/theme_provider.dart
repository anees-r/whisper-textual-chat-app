import 'package:flutter/material.dart';
import 'package:textual_chat_app/themes/dark_theme.dart';
import 'package:textual_chat_app/themes/light_theme.dart';
import 'package:textual_chat_app/themes/theme_data_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme; // Default theme

  // init ThemeDataService instance
  final ThemeDataService _themeDataService = ThemeDataService();

  // constructor to load theme preference
  ThemeProvider() {
    _loadThemePreference(); // Load theme preference when initialized
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkTheme;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
      _saveThemePreference('darkTheme'); // Save dark theme preference
    } else {
      themeData = lightTheme;
      _saveThemePreference('lightTheme'); // Save light theme preference
    }
  }

  Future<void> _saveThemePreference(String theme) async {
    await _themeDataService.saveThemeMode(theme);
  }

  Future<void> _loadThemePreference() async {
    String savedTheme = await _themeDataService.getThemeMode();
    themeData = (savedTheme == 'darkTheme') ? darkTheme : lightTheme;
  }
}

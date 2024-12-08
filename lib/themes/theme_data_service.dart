import 'package:hive/hive.dart';

class ThemeDataService {
  static const String _boxName = 'settings';
  static const String _themeKey = 'theme';

  // Open the box and get the theme value
  Future<void> saveThemeMode(String theme) async {
    var box = await Hive.openBox(_boxName);
    await box.put(_themeKey, theme);
  }

  // Open the box and get the saved theme value 
  Future<String> getThemeMode() async {
    var box = await Hive.openBox(_boxName);
    return box.get(_themeKey, defaultValue: "lightTheme");
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeModePrefKey = 'themeMode';

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeNotifier() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString(_themeModePrefKey);
    _isDarkMode = themeMode == 'dark';
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(_themeModePrefKey, _isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  late final SharedPreferences _sharedPrefs;
  final double defaultFontSize = 18;

  // Loading SharedPreferences instance
  Future<void> initPrefs() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    // Retrieving value
    final appTheme = _sharedPrefs.getString("appTheme");
    // If appTheme is dark
    if (appTheme?.compareTo("dark") == 0) return ThemeMode.dark;
    // Else
    return ThemeMode.light;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Saving setting with key "appTheme"
    await _sharedPrefs.setString(
        "appTheme", theme == ThemeMode.dark ? "dark" : "light");
  }

  // Returns true if app is in dark mode
  static bool isDarkMode(ThemeMode appTheme) {
    return appTheme == ThemeMode.dark;
  }

  // Saving preferred font size
  Future<void> saveFontSize(double fontSize) async {
    await _sharedPrefs.setDouble("fontSize", fontSize);
  }

  // Retrieving user-saved font size
  double getFontSize() {
    return _sharedPrefs.getDouble("fontSize") ?? defaultFontSize;
  }
}

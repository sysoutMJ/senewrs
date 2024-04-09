import 'package:flutter/material.dart';

class SettingsHelper {
  // Returns True if App Theme is in dark mode
  static bool isDarkMode(ThemeMode appTheme) {
    return appTheme == ThemeMode.dark;
  }
}

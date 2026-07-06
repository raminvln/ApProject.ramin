import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(ThemeMode initialMode) : super(initialMode);

  void toggleTheme(bool isDark) {
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Global instance
  static final ThemeNotifier instance = ThemeNotifier(ThemeMode.system);
}
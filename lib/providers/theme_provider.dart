import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Notifier para manejar cambios de tema
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode newThemeMode) {
    if (_themeMode != newThemeMode) {
      _themeMode = newThemeMode;
      notifyListeners();
    }
  }
}

/// Provider para acceso rápido al tema actual
final themeProvider = ChangeNotifierProvider<ThemeNotifier>(
  create: (ref) => ThemeNotifier(),
);

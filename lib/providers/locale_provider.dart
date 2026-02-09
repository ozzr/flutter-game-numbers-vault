import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// StateNotifier para manejar cambios de locale de manera eficiente
class LocaleNotifier extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale? newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }
}

/// Provider para acceso rápido al locale actual
final localeProvider = ChangeNotifierProvider<LocaleNotifier>(
  create: (ref) => LocaleNotifier(),
);

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

/// Provider para evitar llamadas repetidas a AppLocalizations.of(context)
/// Cachea la instancia durante la construcción del widget
final localizationsProvider = Provider<AppLocalizations>(
  create: (ref) {
    throw UnimplementedError('Must be overridden in Consumer');
  },
);

/// Extensión para acceder fácilmente al locale notifier
extension LocaleContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

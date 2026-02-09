import 'package:flutter/material.dart';

/// Widgets estáticos y const reutilizables para evitar rebuilds
class StaticWidgets {
  static const SizedBox spacing4 = SizedBox(height: 4);
  static const SizedBox spacing8 = SizedBox(height: 8);
  static const SizedBox spacing12 = SizedBox(height: 12);
  static const SizedBox spacing16 = SizedBox(height: 16);
  static const SizedBox spacing20 = SizedBox(height: 20);
  static const SizedBox spacing24 = SizedBox(height: 24);
  static const SizedBox spacing32 = SizedBox(height: 32);

  static const SizedBox spacingH8 = SizedBox(width: 8);
  static const SizedBox spacingH12 = SizedBox(width: 12);
  static const SizedBox spacingH16 = SizedBox(width: 16);

  static const EdgeInsets padding12All = EdgeInsets.all(12);
  static const EdgeInsets padding16All = EdgeInsets.all(16);
  static const EdgeInsets padding20All = EdgeInsets.all(20);
  static const EdgeInsets paddingH16V12 = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets paddingH32V16 = EdgeInsets.symmetric(
    horizontal: 32,
    vertical: 16,
  );

  static const BorderRadius br8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius br10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadius br12 = BorderRadius.all(Radius.circular(12));
  static const BorderRadius br16 = BorderRadius.all(Radius.circular(16));

  static const CircularProgressIndicator loadingIndicator =
      CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );

  static const Icon infoIcon = Icon(Icons.info_outline, color: Colors.blue);
  static const Icon lockIcon = Icon(Icons.lock, size: 24);
  static const Icon languageIcon = Icon(Icons.language);
  static const Icon checkIcon = Icon(Icons.check, size: 16);
}

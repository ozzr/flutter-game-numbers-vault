import 'package:flutter/widgets.dart';
import 'translations.dart';
import 'strings.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  String tr(String key, [Map<String, String>? args]) {
    final code = locale.languageCode;
    String? value = kTranslations[code]?[key] ?? kExtraTranslations[code]?[key];
    value ??=
        kTranslations['en']?[key] ?? kExtraTranslations['en']?[key] ?? key;
    if (args != null && args.isNotEmpty) {
      args.forEach((k, v) {
        value = value!.replaceAll('{$k}', v);
      });
    }
    return value!;
  }

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (instance == null) {
      return AppLocalizations(WidgetsBinding.instance.window.locale);
    }
    return instance;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      kTranslations.keys.contains(locale.languageCode) ||
      kExtraTranslations.keys.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/player_data_service.dart';
import 'models/models.dart';
import 'l10n/app_localizations.dart';
import 'l10n/translations.dart';
import 'providers/locale_provider.dart';
import 'providers/player_data_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final playerDataService = PlayerDataService();
  await playerDataService.initialize();

  final playerData = await playerDataService.loadPlayerData('Player');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
          create: (_) =>
              PlayerDataNotifier()..loadPlayerData('Player', playerDataService),
        ),
      ],
      child: MyApp(
        playerData: playerData,
        playerDataService: playerDataService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final PlayerData playerData;
  final PlayerDataService playerDataService;

  const MyApp({
    super.key,
    required this.playerData,
    required this.playerDataService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleNotifier, ThemeNotifier>(
      builder: (context, localeNotifier, themeNotifier, _) {
        return MaterialApp(
          title: 'Numbers Vault',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: kTranslations.keys.map((c) => Locale(c)).toList(),
          locale: localeNotifier.locale,
          themeMode: themeNotifier.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1), // Indigo
              brightness: Brightness.light,
            ),
            typography: Typography.material2021(),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
            ),
            typography: Typography.material2021(),
            appBarTheme: const AppBarTheme(
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            cardTheme: CardThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade800,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          home: HomeScreen(
            initialPlayerData: playerData,
            playerDataService: playerDataService,
          ),
        );
      },
    );
  }
}

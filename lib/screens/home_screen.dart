import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/player_data_service.dart';
import '../widgets/reusable_widgets.dart';
import '../widgets/static_widgets.dart';
import '../widgets/statistics_section.dart';
import '../widgets/levels_grid.dart';
import 'game_screen.dart';
import '../l10n/app_localizations.dart';
import '../l10n/translations.dart';
import '../providers/locale_provider.dart';
import '../providers/player_data_provider.dart';

class HomeScreen extends StatelessWidget {
  final PlayerData initialPlayerData;
  final PlayerDataService playerDataService;

  const HomeScreen({
    Key? key,
    required this.initialPlayerData,
    required this.playerDataService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleNotifier, PlayerDataNotifier>(
      builder: (context, localeNotifier, playerDataNotifier, _) {
        final playerData = playerDataNotifier.playerData ?? initialPlayerData;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).tr('app_title')),
            centerTitle: true,
            elevation: 0,
            actions: [
              PopupMenuButton<String>(
                icon: StaticWidgets.languageIcon,
                onSelected: (code) {
                  localeNotifier.setLocale(Locale(code));
                },
                itemBuilder: (context) {
                  return kTranslations.keys.map((code) {
                    return PopupMenuItem(
                      value: code,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(code),
                          if (localeNotifier.locale?.languageCode == code)
                            StaticWidgets.checkIcon,
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await playerDataNotifier.loadPlayerData(
                playerData.playerName,
                playerDataService,
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Encabezado con nombre del jugador
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: StaticWidgets.padding20All,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).tr('welcome'),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                        StaticWidgets.spacing4,
                        Text(
                          playerData.playerName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                StaticWidgets.spacing24,

                // Estadísticas
                Text(
                  AppLocalizations.of(context).tr('statistics_header'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StaticWidgets.spacing12,
                StatisticsSection(playerData: playerData),
                StaticWidgets.spacing24,

                // Niveles disponibles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).tr('available_levels'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppButton(
                      label: '+1',
                      onPressed: () async {
                        final maxDigits = playerData.unlockedLevels
                            .map((l) => l.digits)
                            .reduce((a, b) => a > b ? a : b);
                        final newDigits = maxDigits + 1;

                        await playerDataService.addNewLevel(
                          playerData,
                          newDigits,
                        );
                        await playerDataNotifier.loadPlayerData(
                          playerData.playerName,
                          playerDataService,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                ).tr('new_level_added', {'n': '$newDigits'}),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: StaticWidgets.paddingH16V12,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                StaticWidgets.spacing12,
                LevelsGrid(
                  levels: playerData.unlockedLevels,
                  onLevelTap: (level) {
                    if (!level.isUnlocked) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            ).tr('unlock_prev_level'),
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(
                          initialPlayerData: playerData,
                          playerDataService: playerDataService,
                          level: level,
                        ),
                      ),
                    ).then((_) {
                      playerDataNotifier.loadPlayerData(
                        playerData.playerName,
                        playerDataService,
                      );
                    });
                  },
                ),
                StaticWidgets.spacing24,

                // Información adicional
                Card(
                  elevation: 1,
                  color: Colors.blue.withOpacity(0.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: StaticWidgets.padding16All,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StaticWidgets.infoIcon,
                            StaticWidgets.spacingH8,
                            Text(
                              AppLocalizations.of(context).tr('tips_title'),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        StaticWidgets.spacing12,
                        Text(
                          AppLocalizations.of(context).tr('tips_text'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                StaticWidgets.spacing32,
              ],
            ),
          ),
        );
      },
    );
  }
}

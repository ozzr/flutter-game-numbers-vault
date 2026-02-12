import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/game_utils.dart';
import '../l10n/app_localizations.dart';
import 'reusable_widgets.dart';

/// Widget optimizado para mostrar estadísticas (const constructor)
class StatisticsSection extends StatelessWidget {
  final PlayerData playerData;

  const StatisticsSection({super.key, required this.playerData});

  @override
  Widget build(BuildContext context) {
    final avgTime = playerData.averageResolutionTime == null
        ? "N/A"
        : GameUtils.formatDuration(playerData.averageResolutionTime!);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          title: AppLocalizations.of(context).tr('passwords_cracked_label'),
          value: playerData.totalPasswordsCracked.toString(),
          icon: Icons.lock_open,
          iconColor: Colors.green,
        ),
        StatCard(
          title: AppLocalizations.of(context).tr('average_time_label'),
          value: avgTime,
          icon: Icons.timer,
          iconColor: Colors.blue,
        ),
      ],
    );
  }
}

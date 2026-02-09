import 'package:flutter/material.dart';
import '../widgets/static_widgets.dart';
import '../l10n/app_localizations.dart';

/// Timers y contadores de intentos widget optimizado
class GameTimerDisplay extends StatelessWidget {
  final int timeRemaining;
  final int maxTime;

  const GameTimerDisplay({
    Key? key,
    required this.timeRemaining,
    required this.maxTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWarning = timeRemaining < 30;
    return Container(
      padding: StaticWidgets.padding16All,
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.red.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: StaticWidgets.br12,
        border: Border.all(color: isWarning ? Colors.red : Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: isWarning ? Colors.red : Colors.blue),
          StaticWidgets.spacingH8,
          Text(
            '${AppLocalizations.of(context).tr('time_label_prefix')}${Duration(seconds: timeRemaining).toString().split('.').first}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

/// Contador de intentos restantes optimizado
class AttemptsRemainingDisplay extends StatelessWidget {
  final int attemptsRemaining;

  const AttemptsRemainingDisplay({Key? key, required this.attemptsRemaining})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWarning = attemptsRemaining < 3;
    return Container(
      padding: StaticWidgets.padding16All,
      decoration: BoxDecoration(
        color: isWarning
            ? Colors.red.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: StaticWidgets.br12,
        border: Border.all(color: isWarning ? Colors.red : Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.format_list_numbered,
            color: isWarning ? Colors.red : Colors.blue,
          ),
          StaticWidgets.spacingH8,
          Text(
            '${AppLocalizations.of(context).tr('attempts_remaining_label', {'n': '$attemptsRemaining'})}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

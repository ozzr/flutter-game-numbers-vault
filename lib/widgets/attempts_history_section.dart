import 'package:flutter/material.dart';
import '../models/models.dart';
import 'reusable_widgets.dart';
import 'static_widgets.dart';

/// Widget optimizado para mostrar historial de intentos invertido
class AttemptsHistorySection extends StatelessWidget {
  final List<GameAttempt> attemptsHistory;

  const AttemptsHistorySection({Key? key, required this.attemptsHistory})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attemptsHistory.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaticWidgets.spacing24,
        Text(
          'Historial de intentos',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        StaticWidgets.spacing12,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attemptsHistory.length,
          itemBuilder: (context, index) {
            // Invertir índice para mostrar últimos intentos arriba
            final reverseIndex = attemptsHistory.length - 1 - index;
            final attempt = attemptsHistory[reverseIndex];
            return AttemptHistoryCard(
              attemptNumber: reverseIndex + 1,
              guess: attempt.guess,
              correctPosition: attempt.correctPosition,
              wrongPosition: attempt.wrongPosition,
            );
          },
        ),
      ],
    );
  }
}

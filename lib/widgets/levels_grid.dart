import 'package:flutter/material.dart';
import '../models/models.dart';
import 'reusable_widgets.dart';

/// Widget optimizado para mostrar grilla de niveles
class LevelsGrid extends StatelessWidget {
  final List<Level> levels;
  final ValueChanged<Level> onLevelTap;

  const LevelsGrid({super.key, required this.levels, required this.onLevelTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        return LevelCard(
          digits: level.digits,
          isUnlocked: level.isUnlocked,
          highScore: level.highScore < 999 ? level.highScore : null,
          averageTime: level.averageTime,
          totalSessions: level.totalSessions > 0 ? level.totalSessions : null,
          onTap: () => onLevelTap(level),
        );
      },
    );
  }
}

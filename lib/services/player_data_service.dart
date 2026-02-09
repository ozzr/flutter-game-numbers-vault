import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class PlayerDataService {
  static const String _playerDataKey = 'player_data';

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Obtiene los datos del jugador o crea unos nuevos
  Future<PlayerData> loadPlayerData(String playerName) async {
    final jsonString = _prefs.getString(_playerDataKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return PlayerData.fromJson(json);
      } catch (e) {
        // Si hay un error al cargar, creamos nuevos datos
        return _createNewPlayerData(playerName);
      }
    }

    return _createNewPlayerData(playerName);
  }

  /// Crea nuevos datos del jugador con niveles desbloqueados por defecto
  PlayerData _createNewPlayerData(String playerName) {
    final now = DateTime.now();
    final levels = [
      Level(digits: 2, isUnlocked: true),
      Level(digits: 3, isUnlocked: false),
      Level(digits: 4, isUnlocked: false),
      Level(digits: 5, isUnlocked: false),
    ];

    return PlayerData(
      playerName: playerName,
      totalPasswordsCracked: 0,
      averageResolutionTime: null,
      unlockedLevels: levels,
      gameHistory: [],
      createdAt: now,
      lastPlayedAt: now,
    );
  }

  /// Guarda los datos del jugador
  Future<void> savePlayerData(PlayerData playerData) async {
    playerData.updateStats();
    final json = playerData.toJson();
    final jsonString = jsonEncode(json);
    await _prefs.setString(_playerDataKey, jsonString);
  }

  /// Agrega una nueva sesión de juego al historial
  Future<void> addGameSession(
    PlayerData playerData,
    GameSession session,
  ) async {
    playerData.gameHistory.add(session);
    playerData.lastPlayedAt = DateTime.now();

    // Actualizar el nivel correspondiente
    final levelIndex = playerData.unlockedLevels.indexWhere(
      (l) => l.digits == session.levelDigits,
    );
    if (levelIndex != -1) {
      final level = playerData.unlockedLevels[levelIndex];
      level.totalSessions++;

      if (session.completed) {
        // Incrementar contador de sesiones completadas para este nivel
        level.completedSessions++;

        // Solo desbloquear el siguiente nivel una vez se hayan completado
        // al menos 10 partidas en el nivel actual
        const requiredCompletions = 10;
        if (levelIndex + 1 < playerData.unlockedLevels.length) {
          final nextLevel = playerData.unlockedLevels[levelIndex + 1];
          if (level.completedSessions >= requiredCompletions) {
            nextLevel.isUnlocked = true;
          }
        }

        // Actualizar puntuación alta (menos intentos es mejor)
        if (session.attempts < level.highScore) {
          level.highScore = session.attempts;
        }

        // Actualizar tiempo promedio usando sesiones completadas para este nivel
        final completedSessions = playerData.gameHistory
            .where((s) => s.levelDigits == session.levelDigits && s.completed)
            .toList();

        if (completedSessions.isNotEmpty && session.timeTaken != null) {
          final totalTime = completedSessions.fold<Duration>(
            Duration.zero,
            (sum, s) => sum + (s.timeTaken ?? Duration.zero),
          );
          level.averageTime = totalTime ~/ completedSessions.length;
        }
      }
    }

    await savePlayerData(playerData);
  }

  /// Agrega un nuevo nivel desbloqueado
  Future<void> addNewLevel(PlayerData playerData, int newDigits) async {
    // Verificar que no exista ya
    final exists = playerData.unlockedLevels.any((l) => l.digits == newDigits);

    if (!exists) {
      playerData.unlockedLevels.add(
        Level(digits: newDigits, isUnlocked: false),
      );
      // El siguiente nivel se desbloquea naturalmente al completar el nivel anterior
      await savePlayerData(playerData);
    }
  }

  /// Limpia todos los datos del jugador
  Future<void> clearAllData() async {
    await _prefs.remove(_playerDataKey);
  }
}

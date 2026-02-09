/// Representa un intento de adivinanza con sus resultados
class GameAttempt {
  final List<int> guess;
  final int correctPosition;
  final int wrongPosition;
  final DateTime timestamp;

  GameAttempt({
    required this.guess,
    required this.correctPosition,
    required this.wrongPosition,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'guess': guess,
    'correctPosition': correctPosition,
    'wrongPosition': wrongPosition,
    'timestamp': timestamp.toIso8601String(),
  };

  factory GameAttempt.fromJson(Map<String, dynamic> json) => GameAttempt(
    guess: List<int>.from(json['guess'] as List),
    correctPosition: json['correctPosition'] as int,
    wrongPosition: json['wrongPosition'] as int,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

/// Representa las estadísticas de una partida individual
class GameSession {
  final int levelDigits;
  final String gameMode; // 'timed', 'take_your_time', 'limited_count'
  final bool completed;
  final int attempts;
  final Duration? timeTaken;
  final int? timeLimit; // en segundos
  final int? attemptLimit;
  final DateTime startTime;
  final DateTime? endTime;
  final List<GameAttempt> attemptsHistory;

  GameSession({
    required this.levelDigits,
    required this.gameMode,
    required this.completed,
    required this.attempts,
    this.timeTaken,
    this.timeLimit,
    this.attemptLimit,
    required this.startTime,
    this.endTime,
    required this.attemptsHistory,
  });

  Map<String, dynamic> toJson() => {
    'levelDigits': levelDigits,
    'gameMode': gameMode,
    'completed': completed,
    'attempts': attempts,
    'timeTaken': timeTaken?.inMilliseconds,
    'timeLimit': timeLimit,
    'attemptLimit': attemptLimit,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'attemptsHistory': attemptsHistory.map((a) => a.toJson()).toList(),
  };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
    levelDigits: json['levelDigits'] as int,
    gameMode: json['gameMode'] as String,
    completed: json['completed'] as bool,
    attempts: json['attempts'] as int,
    timeTaken: json['timeTaken'] != null
        ? Duration(milliseconds: json['timeTaken'] as int)
        : null,
    timeLimit: json['timeLimit'] as int?,
    attemptLimit: json['attemptLimit'] as int?,
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] != null
        ? DateTime.parse(json['endTime'] as String)
        : null,
    attemptsHistory:
        (json['attemptsHistory'] as List<dynamic>?)
            ?.map((a) => GameAttempt.fromJson(a as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

/// Representa un nivel desbloqueado del jugador
class Level {
  final int digits;
  bool isUnlocked;
  int highScore; // Mejor puntuación (menos intentos)
  Duration? averageTime;
  int totalSessions;
  int completedSessions;

  Level({
    required this.digits,
    required this.isUnlocked,
    this.highScore = 999,
    this.averageTime,
    this.totalSessions = 0,
    this.completedSessions = 0,
  });

  Map<String, dynamic> toJson() => {
    'digits': digits,
    'isUnlocked': isUnlocked,
    'highScore': highScore,
    'averageTime': averageTime?.inMilliseconds,
    'totalSessions': totalSessions,
    'completedSessions': completedSessions,
  };

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    digits: json['digits'] as int,
    isUnlocked: json['isUnlocked'] as bool,
    highScore: json['highScore'] as int? ?? 999,
    averageTime: json['averageTime'] != null
        ? Duration(milliseconds: json['averageTime'] as int)
        : null,
    totalSessions: json['totalSessions'] as int? ?? 0,
    completedSessions: json['completedSessions'] as int? ?? 0,
  );
}

/// Representa los datos del jugador y sus estadísticas generales
class PlayerData {
  String playerName;
  int totalPasswordsCracked;
  Duration? averageResolutionTime;
  List<Level> unlockedLevels;
  List<GameSession> gameHistory;
  DateTime createdAt;
  DateTime lastPlayedAt;

  PlayerData({
    required this.playerName,
    this.totalPasswordsCracked = 0,
    this.averageResolutionTime,
    this.unlockedLevels = const [],
    this.gameHistory = const [],
    required this.createdAt,
    required this.lastPlayedAt,
  });

  /// Calcula el tiempo promedio de resolución basado en todas las sesiones completadas
  Duration? calculateAverageTime() {
    final completedSessions = gameHistory
        .where((session) => session.completed)
        .toList();
    if (completedSessions.isEmpty) return null;

    final totalDuration = completedSessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + (session.timeTaken ?? Duration.zero),
    );

    return totalDuration ~/ completedSessions.length;
  }

  /// Calcula el total de contraseñas crackeadas
  void updateStats() {
    totalPasswordsCracked = gameHistory
        .where((session) => session.completed)
        .length;
    averageResolutionTime = calculateAverageTime();
  }

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'totalPasswordsCracked': totalPasswordsCracked,
    'averageResolutionTime': averageResolutionTime?.inMilliseconds,
    'unlockedLevels': unlockedLevels.map((l) => l.toJson()).toList(),
    'gameHistory': gameHistory.map((g) => g.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'lastPlayedAt': lastPlayedAt.toIso8601String(),
  };

  factory PlayerData.fromJson(Map<String, dynamic> json) => PlayerData(
    playerName: json['playerName'] as String,
    totalPasswordsCracked: json['totalPasswordsCracked'] as int? ?? 0,
    averageResolutionTime: json['averageResolutionTime'] != null
        ? Duration(milliseconds: json['averageResolutionTime'] as int)
        : null,
    unlockedLevels:
        (json['unlockedLevels'] as List<dynamic>?)
            ?.map((l) => Level.fromJson(l as Map<String, dynamic>))
            .toList() ??
        [],
    gameHistory:
        (json['gameHistory'] as List<dynamic>?)
            ?.map((g) => GameSession.fromJson(g as Map<String, dynamic>))
            .toList() ??
        [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
  );
}

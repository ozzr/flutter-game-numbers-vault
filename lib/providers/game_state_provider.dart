import 'package:flutter/foundation.dart';
import 'dart:async';
import '../logic/game_logic.dart';
import '../models/models.dart';

class GameStateNotifier extends ChangeNotifier {
  late RandomNumberStore _gameLogic;
  late String _gameMode; // 'unlimited', 'timed', 'limited_count', 'both'
  late int _timeRemaining;
  late int _attemptsRemaining;
  late Timer? _timer;
  bool _gameCompleted = false;
  int _attempts = 0;
  final List<GameAttempt> _attemptsHistory = [];
  DateTime? _startTime;
  DateTime? _endTime;
  int _timeLimit = 120;
  int _maxAttempts = 15;
  String? _endReasonKey;
  Map<String, String>? _endReasonData;

  // Getters
  RandomNumberStore get gameLogic => _gameLogic;
  String get gameMode => _gameMode;
  int get timeRemaining => _timeRemaining;
  int get attemptsRemaining => _attemptsRemaining;
  bool get gameCompleted => _gameCompleted;
  int get attempts => _attempts;
  List<GameAttempt> get attemptsHistory => _attemptsHistory;
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;
  int get timeLimit => _timeLimit;
  int get maxAttempts => _maxAttempts;
  String? get endReasonKey => _endReasonKey;
  Map<String, String>? get endReasonData => _endReasonData;

  /// Determine game mode based on attempt number (cycles through modes)
  /// Attempt 1: unlimited
  /// Attempt 2: timed
  /// Attempt 3: limited_count
  /// Attempt 4: both
  /// Attempt 5+: repeats cycle
  static String _determineGameMode(int attemptNumber) {
    // attemptNumber is 1-based
    final cyclePosition = ((attemptNumber - 1) % 4);
    switch (cyclePosition) {
      case 0:
        return 'unlimited';
      case 1:
        return 'timed';
      case 2:
        return 'limited_count';
      case 3:
        return 'both';
      default:
        return 'unlimited';
    }
  }

  /// Calculate time limit based on digits
  static int _calculateTimeLimit(int digits) {
    // Scale time based on difficulty
    return 60 + (digits * 15); // 75s for 1 digit, 150s for 6 digits
  }

  /// Calculate attempt limit based on digits (reduced for limited_count mode)
  static int _calculateAttemptLimit(int digits) {
    // Reduced compared to original: roughly 10^(digits/2)
    switch (digits) {
      case 1:
        return 10;
      case 2:
        return 12;
      case 3:
        return 15;
      case 4:
        return 20;
      case 5:
        return 25;
      default:
        return 30;
    }
  }

  void initializeGame(
    int digits,
    int attemptNumber, {
    int? timeLimit,
    int? maxAttempts,
  }) {
    // Determine mode based on attempt number (cyclical)
    _gameMode = _determineGameMode(attemptNumber);
    _gameLogic = RandomNumberStore(digits);

    // Use provided limits or calculate based on mode
    if (_gameMode == 'unlimited') {
      _timeLimit = 999999; // Effectively unlimited
      _maxAttempts = 999999;
    } else if (_gameMode == 'timed') {
      _timeLimit = timeLimit ?? _calculateTimeLimit(digits);
      _maxAttempts = 999999;
    } else if (_gameMode == 'limited_count') {
      _timeLimit = 999999;
      _maxAttempts = maxAttempts ?? _calculateAttemptLimit(digits);
    } else if (_gameMode == 'both') {
      // Both time and attempt limits
      _timeLimit = timeLimit ?? _calculateTimeLimit(digits);
      _maxAttempts = maxAttempts ?? _calculateAttemptLimit(digits);
    }

    _timeRemaining = _timeLimit;
    _attemptsRemaining = _maxAttempts;
    _startTime = DateTime.now();
    _timer = null;
    _gameCompleted = false;
    _attempts = 0;
    _attemptsHistory.clear();
    _endReasonKey = null;
    _endReasonData = null;
    notifyListeners();
  }

  void startTimer(VoidCallback onTimeOver) {
    if (_gameMode == 'unlimited' || _timeLimit == 999999) {
      return; // No timer for unlimited mode
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeRemaining--;
      if (_timeRemaining <= 0) {
        _timer?.cancel();
        onTimeOver();
      }
      notifyListeners();
    });
  }

  void _onTimeOver() {
    _endGameInternal(
      completed: false,
      messageKey: 'time_over',
      messageData: {'answer': _gameLogic.storedNumbers.join('-')},
    );
  }

  void validateGuess(List<int> guess, int levelDigits) {
    if (_gameCompleted) return;

    _attempts++;
    final hints = _gameLogic.hints(guess);
    final attempt = GameAttempt(
      guess: guess,
      correctPosition: hints['correctPosition'] ?? 0,
      wrongPosition: hints['wrongPosition'] ?? 0,
      timestamp: DateTime.now(),
    );

    _attemptsHistory.add(attempt);

    if (attempt.correctPosition == levelDigits) {
      _endGameInternal(completed: true);
      return;
    }

    // Check attempts limit for limited_count or both modes
    if (_gameMode == 'limited_count' || _gameMode == 'both') {
      _attemptsRemaining--;
      if (_attemptsRemaining <= 0) {
        _endGameInternal(
          completed: false,
          messageKey: 'attempts_over',
          messageData: {'answer': _gameLogic.storedNumbers.join('-')},
        );
        return;
      }
    }

    notifyListeners();
  }

  void _endGameInternal({
    required bool completed,
    String? messageKey,
    Map<String, String>? messageData,
  }) {
    _endTime = DateTime.now();
    _timer?.cancel();
    _gameCompleted = true;
    _endReasonKey = messageKey;
    _endReasonData = messageData;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

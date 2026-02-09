import 'package:flutter/foundation.dart';
import 'dart:async';
import '../logic/game_logic.dart';
import '../models/models.dart';

class GameStateNotifier extends ChangeNotifier {
  late RandomNumberStore _gameLogic;
  late String _gameMode;
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

  void initializeGame(int digits, int timeLimit, int maxAttempts) {
    _gameMode = 'take_your_time';
    _gameLogic = RandomNumberStore(digits);
    _timeLimit = timeLimit;
    _maxAttempts = maxAttempts;
    _timeRemaining = timeLimit;
    _attemptsRemaining = maxAttempts;
    _startTime = DateTime.now();
    _timer = null;
    _gameCompleted = false;
    _attempts = 0;
    _attemptsHistory.clear();
    notifyListeners();
  }

  void startTimer(VoidCallback onTimeOver) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeRemaining--;
      if (_timeRemaining <= 0) {
        _timer?.cancel();
        onTimeOver();
      }
      notifyListeners();
    });
  }

  void handleGameModeChange(String newMode, int timeLimit, int maxAttempts) {
    _gameMode = newMode;
    _timer?.cancel();

    if (newMode == 'timed') {
      _timeRemaining = timeLimit;
      startTimer(_onTimeOver);
    } else if (newMode == 'limited_count') {
      _attemptsRemaining = maxAttempts;
    }
    notifyListeners();
  }

  void _onTimeOver() {
    _endGameInternal(completed: false, messageKey: 'time_over');
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

    if (_gameMode == 'limited_count') {
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

  String? _endReasonKey;
  Map<String, String>? _endReasonData;

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

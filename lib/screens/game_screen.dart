import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/minimum_attempts_calculator.dart';
import '../models/models.dart';
import '../services/player_data_service.dart';
import '../widgets/reusable_widgets.dart';
import '../config/game_config.dart';
import '../utils/game_utils.dart';
import '../providers/game_state_provider.dart';
import '../l10n/app_localizations.dart';

class GameScreen extends StatelessWidget {
  final Level level;
  final PlayerData initialPlayerData;
  final PlayerDataService playerDataService;

  const GameScreen({
    super.key,
    required this.level,
    required this.initialPlayerData,
    required this.playerDataService,
  });

  @override
  Widget build(BuildContext context) {
    final timeLimit = GameConfig.getTimeLimit(level.digits);
    final maxAttempts = GameConfig.getAttemptLimit(level.digits);

    return ChangeNotifierProvider(
      create: (_) {
        final notifier = GameStateNotifier();
        notifier.initializeGame(
          level.digits,
          level.currentAttempt,
          timeLimit: timeLimit,
          maxAttempts: maxAttempts,
        );
        return notifier;
      },
      child: Consumer<GameStateNotifier>(
        builder: (context, gameState, _) {
          return _GameScreenContent(
            level: level,
            initialPlayerData: initialPlayerData,
            playerDataService: playerDataService,
            gameState: gameState,
          );
        },
      ),
    );
  }
}

class _GameScreenContent extends StatefulWidget {
  final Level level;
  final PlayerData initialPlayerData;
  final PlayerDataService playerDataService;
  final GameStateNotifier gameState;

  const _GameScreenContent({
    required this.level,
    required this.initialPlayerData,
    required this.playerDataService,
    required this.gameState,
  });

  @override
  State<_GameScreenContent> createState() => _GameScreenContentState();
}

class _GameScreenContentState extends State<_GameScreenContent> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.level.digits,
      (_) => TextEditingController(),
    );

    // Listener para detectar fin del juego y auto-start timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = context.read<GameStateNotifier>();
      gameState.addListener(_onGameStateChanged);

      // Auto-start timer if in timed or both mode
      if ((gameState.gameMode == 'timed' || gameState.gameMode == 'both') &&
          gameState.timeLimit < 999999) {
        gameState.startTimer(_onTimeOver);
      }
    });
  }

  void _onGameStateChanged() {
    final gameState = context.read<GameStateNotifier>();
    if (gameState.gameCompleted && !_gameEndedCalled) {
      _gameEndedCalled = true;
      final completed =
          gameState.attemptsHistory.isNotEmpty &&
          gameState.attemptsHistory.last.correctPosition == widget.level.digits;
      String? message;
      final reasonKey = gameState.endReasonKey;
      if (reasonKey != null) {
        final data = gameState.endReasonData ?? {};
        message = AppLocalizations.of(context).tr(reasonKey, data);
      }
      _endGame(completed: completed, message: message);
    }
  }

  void _onTimeOver() {
    // Timer callback - notifyListeners will trigger _onGameStateChanged
    // which handles the game end logic
  }

  bool _gameEndedCalled = false;

  @override
  void dispose() {
    try {
      final gameState = context.read<GameStateNotifier>();
      gameState.removeListener(_onGameStateChanged);
    } catch (_) {}
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateGuess() {
    // Validar que todos los campos estén completos
    if (_controllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).tr('fill_all_digits')),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    final guess = _controllers.map((c) => int.parse(c.text)).toList();
    widget.gameState.validateGuess(guess, widget.level.digits);

    // Limpiar campos
    for (var controller in _controllers) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();
  }

  void _endGame({required bool completed, String? message}) {
    final gameState = widget.gameState;
    final timeTaken = gameState.endTime != null
        ? gameState.endTime!.difference(gameState.startTime!)
        : Duration.zero;

    // Capturar el número de intento actual ANTES de incrementarlo
    final currentAttemptNumber = widget.level.currentAttempt;

    final session = GameSession(
      levelDigits: widget.level.digits,
      gameMode: gameState.gameMode,
      completed: completed,
      attempts: gameState.attempts,
      timeTaken: timeTaken,
      timeLimit: gameState.gameMode == 'timed' ? gameState.timeLimit : null,
      attemptLimit: gameState.gameMode == 'limited_count'
          ? gameState.maxAttempts
          : null,
      startTime: gameState.startTime!,
      endTime: gameState.endTime,
      attemptsHistory: gameState.attemptsHistory,
    );

    // Capturar datos antes de posible dispose
    final attempts = gameState.attempts;

    // Actualizar contador de intentos en el nivel
    if (completed) {
      // Si se completó exitosamente, incrementar para el próximo intento en el mismo nivel
      widget.level.currentAttempt++;
    }
    // Si no se completó, mantener igual para reintentar el mismo modo

    // Guardar la sesión
    widget.playerDataService.addGameSession(widget.initialPlayerData, session);

    // Mostrar resultado
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showResultDialog(
          completed: completed,
          timeTaken: timeTaken,
          message: message,
          attempts: attempts,
          attemptNumber: currentAttemptNumber,
        );
      }
    });
  }

  void _showResultDialog({
    required bool completed,
    required Duration timeTaken,
    String? message,
    required int attempts,
    required int attemptNumber,
  }) {
    final minimumAttempts = MinimumAttemptsCalculator.calculateMinimumAttempts(
      widget.level.digits,
    );
    final feedback = MinimumAttemptsCalculator.getAttemptFeedback(
      attempts,
      minimumAttempts,
    );
    final bonusPoints = MinimumAttemptsCalculator.calculateBonusPoints(
      attempts,
      minimumAttempts,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          completed
              ? AppLocalizations.of(context).tr('congrats')
              : AppLocalizations.of(context).tr('game_finished'),
          style: TextStyle(color: completed ? Colors.green : Colors.orange),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (completed)
                Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).tr('password_cracked'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(Icons.cancel, color: Colors.orange, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      message ?? AppLocalizations.of(context).tr('no_password'),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _ResultRow(label: 'Intento:', value: '$attemptNumber'),
                    const SizedBox(height: 8),
                    _ResultRow(
                      label: AppLocalizations.of(context).tr('attempts_made'),
                      value: '$attempts',
                    ),
                    const SizedBox(height: 8),
                    _ResultRow(
                      label: AppLocalizations.of(context).tr('total_time'),
                      value: _formatDuration(timeTaken),
                    ),
                    if (completed) ...[
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: AppLocalizations.of(
                          context,
                        ).tr('minimum_theoretical'),
                        value:
                            '$minimumAttempts ${AppLocalizations.of(context).tr('attempts')}',
                      ),
                      const SizedBox(height: 8),
                      _ResultRow(
                        label: AppLocalizations.of(context).tr('efficiency'),
                        value: completed ? feedback : 'N/A',
                      ),
                      if (completed)
                        Column(
                          children: [
                            const SizedBox(height: 8),
                            _ResultRow(
                              label: AppLocalizations.of(
                                context,
                              ).tr('bonus_points'),
                              value: '$bonusPoints',
                            ),
                          ],
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).tr('back_to_home')),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return GameUtils.formatDuration(duration);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameStateNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(
                context,
              ).tr('level_title', {'digits': '${widget.level.digits}'}),
            ),
            Text(
              'Intento ${widget.level.currentAttempt}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game mode indicator
            if (!gameState.gameCompleted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gameState.gameMode == 'unlimited'
                          ? Icons.check_circle
                          : gameState.gameMode == 'timed'
                          ? Icons.timer
                          : gameState.gameMode == 'limited_count'
                          ? Icons.format_list_numbered
                          : Icons.layers,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).tr(
                        gameState.gameMode == 'unlimited'
                            ? 'mode_unlimited'
                            : gameState.gameMode == 'timed'
                            ? 'mode_timed'
                            : gameState.gameMode == 'limited_count'
                            ? 'mode_limited_count'
                            : 'mode_both',
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),

            if (!gameState.gameCompleted) const SizedBox(height: 16),

            // Display timer if in timed or both mode
            if (!gameState.gameCompleted &&
                (gameState.gameMode == 'timed' || gameState.gameMode == 'both'))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: gameState.timeRemaining < 30
                      ? Colors.red.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: gameState.timeRemaining < 30
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      color: gameState.timeRemaining < 30
                          ? Colors.red
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppLocalizations.of(context).tr('time_label_prefix')}${_formatDuration(Duration(seconds: gameState.timeRemaining))}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: gameState.timeRemaining < 30
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

            // Display attempts if in limited_count or both mode
            if (!gameState.gameCompleted &&
                (gameState.gameMode == 'limited_count' ||
                    gameState.gameMode == 'both'))
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: gameState.attemptsRemaining < 3
                      ? Colors.red.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: gameState.attemptsRemaining < 3
                        ? Colors.red
                        : Colors.blue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_list_numbered,
                      color: gameState.attemptsRemaining < 3
                          ? Colors.red
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).tr(
                        'attempts_remaining_label',
                        {'n': '${gameState.attemptsRemaining}'},
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: gameState.attemptsRemaining < 3
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

            if (!gameState.gameCompleted) const SizedBox(height: 24),

            if (!gameState.gameCompleted)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).tr('enter_password', {'n': '${widget.level.digits}'}),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Row(
                      spacing: 6,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        widget.level.digits,
                        (index) => SizedBox(
                          width: 60,
                          child: DigitInputField(
                            controller: _controllers[index],
                            onChanged: (value) {
                              if (value.isEmpty && index > 0) {
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _validateGuess,
                      child: Text(AppLocalizations.of(context).tr('validate')),
                    ),
                  ),
                ],
              ),

            if (!gameState.gameCompleted &&
                gameState.attemptsHistory.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context).tr('attempts_history'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gameState.attemptsHistory.length,
                    itemBuilder: (context, index) {
                      // Invertir índice para mostrar últimos intentos arriba
                      final reverseIndex =
                          gameState.attemptsHistory.length - 1 - index;
                      final attempt = gameState.attemptsHistory[reverseIndex];
                      return AttemptHistoryCard(
                        attemptNumber: reverseIndex + 1,
                        guess: attempt.guess,
                        correctPosition: attempt.correctPosition,
                        wrongPosition: attempt.wrongPosition,
                      );
                    },
                  ),
                ],
              ),

            if (gameState.gameCompleted)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

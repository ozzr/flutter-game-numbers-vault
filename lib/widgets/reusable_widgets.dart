import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'static_widgets.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final ButtonStyle? style;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style:
          style ??
          ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            disabledBackgroundColor: Colors.grey.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: StaticWidgets.loadingIndicator,
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}

class DigitInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String hintText;

  const DigitInputField({
    Key? key,
    required this.onChanged,
    this.validator,
    this.controller,
    this.hintText = "0",
  }) : super(key: key);

  @override
  State<DigitInputField> createState() => _DigitInputFieldState();
}

class _DigitInputFieldState extends State<DigitInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged: (value) {
        if (value.length <= 1) {
          widget.onChanged(value);
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        } else {
          _controller.text = value.substring(0, 1);
        }
      },
      validator: widget.validator,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      inputFormatters: const [],
      decoration: InputDecoration(
        hintText: widget.hintText,
        counterText: "",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  final int digits;
  final bool isUnlocked;
  final int? highScore;
  final Duration? averageTime;
  final VoidCallback onTap;
  final int? totalSessions;

  const LevelCard({
    Key? key,
    required this.digits,
    required this.isUnlocked,
    this.highScore,
    this.averageTime,
    required this.onTap,
    this.totalSessions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Card(
        elevation: isUnlocked ? 4 : 0,
        color: isUnlocked
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$digits ${AppLocalizations.of(context).tr('digits_word')}",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                  StaticWidgets.spacing8,
                  if (isUnlocked && highScore != null)
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).tr('best_score', {'score': '$highScore'}),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (totalSessions != null)
                          Text(
                            AppLocalizations.of(
                              context,
                            ).tr('total_games', {'count': '$totalSessions'}),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                      ],
                    )
                  else if (!isUnlocked)
                    Text(
                      AppLocalizations.of(context).tr('locked_requirement'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            if (!isUnlocked)
              Positioned(top: 8, right: 8, child: StaticWidgets.lockIcon),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AttemptHistoryCard extends StatelessWidget {
  final int attemptNumber;
  final List<int> guess;
  final int correctPosition;
  final int wrongPosition;

  const AttemptHistoryCard({
    Key? key,
    required this.attemptNumber,
    required this.guess,
    required this.correctPosition,
    required this.wrongPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Número de intento
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "#$attemptNumber",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Guess
            Expanded(
              child: Text(
                guess.join("-"),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Hints
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "✓ $correctPosition",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "~ $wrongPosition",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GameModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;

  const GameModeSelector({
    Key? key,
    required this.selectedMode,
    required this.onModeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).tr('mode_label'),
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ModeOption(
                label: AppLocalizations.of(context).tr('mode_take_your_time'),
                mode: "take_your_time",
                icon: Icons.schedule,
                isSelected: selectedMode == "take_your_time",
                onTap: () => onModeChanged("take_your_time"),
              ),
              const SizedBox(width: 8),
              _ModeOption(
                label: AppLocalizations.of(context).tr('mode_timed'),
                mode: "timed",
                icon: Icons.timer,
                isSelected: selectedMode == "timed",
                onTap: () => onModeChanged("timed"),
              ),
              const SizedBox(width: 8),
              _ModeOption(
                label: AppLocalizations.of(context).tr('mode_limited_count'),
                mode: "limited_count",
                icon: Icons.format_list_numbered,
                isSelected: selectedMode == "limited_count",
                onTap: () => onModeChanged("limited_count"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeOption extends StatelessWidget {
  final String label;
  final String mode;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeOption({
    required this.label,
    required this.mode,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

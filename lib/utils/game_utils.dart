/// Utilidades y funciones auxiliares para el juego
class GameUtils {
  /// Formatea una duración en formato legible
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${seconds}s";
    }
  }

  /// Convierte milisegundos a duración
  static Duration msToDuration(int milliseconds) {
    return Duration(milliseconds: milliseconds);
  }

  /// Calcula el porcentaje de completitud
  static double calculateProgress(int completed, int total) {
    if (total == 0) return 0;
    return (completed / total).clamp(0, 1);
  }

  /// Genera un identificador único
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Verifica si todos los dígitos son válidos (0-9)
  static bool areValidDigits(List<int> digits) {
    return digits.every((digit) => digit >= 0 && digit <= 9);
  }

  /// Cuenta los dígitos únicos en una lista
  static int countUniqueDigits(List<int> digits) {
    return digits.toSet().length;
  }

  /// Calcula la dificultad relativa del nivel (retorna clave de traducción)
  static String getDifficultyLabelKey(int digits) {
    if (digits <= 2) return 'difficulty_easy';
    if (digits <= 3) return 'difficulty_medium';
    if (digits <= 4) return 'difficulty_hard';
    return 'difficulty_very_hard';
  }

  /// DEPRECATED: Use getDifficultyLabelKey() instead
  @Deprecated('Use getDifficultyLabelKey()')
  static String getDifficultyLabel(int digits) {
    if (digits <= 2) return 'Fácil';
    if (digits <= 3) return 'Medio';
    if (digits <= 4) return 'Difícil';
    return 'Muy difícil';
  }

  /// Obtiene un emoji basado en el desempeño
  static String getPerformanceEmoji(int attempts, int minimum) {
    final ratio = attempts / minimum;
    if (ratio <= 1.2) return '🌟';
    if (ratio <= 1.5) return '⭐';
    if (ratio <= 2.0) return '👍';
    if (ratio <= 3.0) return '✓';
    return '•';
  }

  /// Formatea un número con separadores
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

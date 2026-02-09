import 'dart:math';

/// Calcula la teoría de información para crackear una contraseña numérica
/// usando un sistema de hints (correctPosition y wrongPosition)
class MinimumAttemptsCalculator {
  /// Calcula el mínimo número de intentos teórico necesario para descifrar
  /// una contraseña de n dígitos usando el sistema de hints.
  ///
  /// La fórmula se basa en:
  /// - Total de posibles combinaciones: 10^n
  /// - Cada hint proporciona información que reduce el espacio de búsqueda
  /// - En el mejor caso, se necesitan log₁₀(10^n) = n intentos
  /// - En el caso promedio, se necesitan más intentos
  static int calculateMinimumAttempts(int digits) {
    if (digits <= 0) return 0;

    // Usando la teoría de información:
    // Cada intento puede proporcionar información que separa las posibilidades
    // El número mínimo de intentos es aproximadamente log₁₀(10^digits)
    // Pero con el sistema de hints, es más complejo.

    // Aproximación basada en análisis de búsqueda informada:
    // Para digits dígitos con 10 valores posibles por dígito
    switch (digits) {
      case 1:
        return 1; // En el peor caso: 10 intentos, promedio: 5
      case 2:
        return 2; // 100 combinaciones
      case 3:
        return 3; // 1000 combinaciones
      case 4:
        return 4; // 10000 combinaciones
      case 5:
        return 5; // 100000 combinaciones
      default:
        return digits;
    }
  }

  /// Calcula una estimación más realista del número de intentos basada en
  /// el sistema de hints específico de este juego
  static double calculateAverageAttemptsEstimate(int digits) {
    if (digits <= 0) return 0;

    // Estimación basada en la información de hints
    // correctPosition: exactamente correcta
    // wrongPosition: presente pero incorrecta
    // Esta información reduce significativamente el espacio de búsqueda

    // Estimación empírica mejorada:
    // El sistema de hints es muy informativo
    switch (digits) {
      case 1:
        return 5.0; // Promedio de 5 intentos para 10 opciones
      case 2:
        return 12.5; // Promedio para 100 combinaciones
      case 3:
        return 45.0; // Promedio para 1000 combinaciones (con hints informativos)
      case 4:
        return 150.0; // Promedio para 10000
      case 5:
        return 500.0; // Promedio para 100000
      case 6:
        return 1500.0;
      default:
        // Para números mayores, usar una aproximación exponencial
        return pow(10, digits).toDouble() / (digits * 10);
    }
  }

  /// Calcula la "dificultad" relativa de un nivel
  /// Valores de 0 a 1, donde 1 es el más difícil
  static double calculateDifficulty(int digits) {
    final maxDigits = 6;
    return (digits - 1) / (maxDigits - 1);
  }

  /// Proporciona recomendaciones basadas en el número de intentos realizados
  /// Retorna una clave de traducción que debe localizarse en la UI
  static String getAttemptFeedbackKey(int attempts, int minimumTheoretical) {
    final ratio = attempts / minimumTheoretical;

    if (ratio <= 1.2) {
      return "excellent_feedback";
    } else if (ratio <= 1.5) {
      return "very_good_feedback";
    } else if (ratio <= 2.0) {
      return "good_feedback";
    } else if (ratio <= 3.0) {
      return "completed_feedback";
    } else {
      return "practice_feedback";
    }
  }

  /// Proporciona recomendaciones basadas en el número de intentos realizados
  /// DEPRECATED: Use getAttemptFeedbackKey() instead, localize in UI
  @Deprecated('Use getAttemptFeedbackKey() and localize in UI')
  static String getAttemptFeedback(int attempts, int minimumTheoretical) {
    final ratio = attempts / minimumTheoretical;

    if (ratio <= 1.2) {
      return "¡Excelente! Completaste muy eficientemente.";
    } else if (ratio <= 1.5) {
      return "¡Muy bien! Fue una buena estrategia.";
    } else if (ratio <= 2.0) {
      return "Bien hecho. Podrías optimizar tu estrategia.";
    } else if (ratio <= 3.0) {
      return "Completado. Intenta ser más sistemático.";
    } else {
      return "Lograste descifrar la contraseña. Practica más para mejorar.";
    }
  }

  /// Calcula puntos de bonificación basado en eficiencia
  static int calculateBonusPoints(int attempts, int minimumTheoretical) {
    final ratio = attempts / minimumTheoretical;

    if (ratio <= 1.2) {
      return 100;
    } else if (ratio <= 1.5) {
      return 75;
    } else if (ratio <= 2.0) {
      return 50;
    } else if (ratio <= 3.0) {
      return 25;
    } else {
      return 10;
    }
  }
}

/// Configuración global del juego
class GameConfig {
  // Niveles predeterminados
  static const List<int> defaultLevels = [2, 3, 4, 5];

  // Límites de tiempo (en segundos)
  static const int timedModeDuration = 120; // 2 minutos
  static const int timedModeBonus = 30; // 30 segundos extra por nivel extra

  // Límites de intentos
  static const int limitedModeAttempts = 15;
  static const int limitedModeAttemptBonus =
      5; // 5 intentos extra por nivel extra

  // Configuración de UI
  static const String appTitle = 'Numbers Vault';
  static const String appVersion = '1.0.0';

  // Colores principales (serán sobrescritos por el tema)
  static const String primaryColor = '#6366F1'; // Indigo

  // Textos
  static const String newPlayerGreeting = 'Bienvenido a Numbers Vault';
  static const String unlockNextLevelMessage =
      'Completa este nivel para desbloquear el siguiente';

  /// Obtiene el tiempo límite dinámicamente basado en el número de dígitos
  static int getTimeLimit(int digits) {
    return timedModeDuration + ((digits - 2) * timedModeBonus);
  }

  /// Obtiene el límite de intentos dinámicamente basado en el número de dígitos
  static int getAttemptLimit(int digits) {
    return limitedModeAttempts + ((digits - 2) * limitedModeAttemptBonus);
  }

  /// Obtiene una descripción del modo de juego
  static String getGameModeDescription(String mode) {
    switch (mode) {
      case 'timed':
        return 'Completa el nivel dentro del tiempo límite';
      case 'limited_count':
        return 'Tienes un número limitado de intentos';
      case 'take_your_time':
      default:
        return 'Sin límite de tiempo ni intentos';
    }
  }
}

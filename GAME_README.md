# Numbers Vault - Juego de Adivinanza de Números

## Descripción General

**Numbers Vault** es un juego moderno y desafiante donde el jugador debe descifrar una contraseña numérica usando un sistema inteligente de pistas (hints). El juego incluye múltiples niveles, modos de juego y un sistema de estadísticas para rastrear tu progreso.

## Características Principales

### 🎮 Modos de Juego
- **Sin límite**: Juega sin restricciones de tiempo ni intentos
- **Con tiempo**: Completa el nivel dentro del límite de tiempo establecido
- **Intentos limitados**: Tienes un número máximo de intentos para descifrar la contraseña

### 📊 Sistema de Niveles
- Niveles disponibles del 2 al 5+ dígitos
- Sistema de desbloqueo progresivo (debes completar el nivel anterior)
- Estadísticas por nivel: mejor puntuación y tiempo promedio

### 🧮 Sistema de Hints Inteligente
Después de cada intento, recibirás dos tipos de información:
- **✓ Posición Correcta**: Dígitos que están en la posición exacta
- **~ Posición Incorrecta**: Dígitos que existen pero en posición equivocada

### 📈 Seguimiento de Estadísticas
- Total de contraseñas descifradas
- Tiempo promedio de resolución
- Progreso por nivel
- Historial de intentos detallado

### 🎨 Interfaz Moderna
- Diseño limpio y minimalista
- Tema visual coherente con colores contrastantes
- Animaciones suaves y feedback visual
- Interfaz responsiva

## Cómo Jugar

### Inicio
1. La aplicación cargará tu perfil automáticamente
2. Verás un resumen de tus estadísticas generales
3. Tendrás acceso a los niveles desbloqueados

### Durante el Juego
1. Selecciona un modo de juego (Sin límite, Con tiempo o Intentos limitados)
2. Si elegiste "Con tiempo", verás un contador regresivo
3. Ingresa los dígitos en los campos correspondientes
4. Presiona "Validar" para verificar tu intento
5. Lee cuidadosamente los hints y ajusta tu estrategia
6. Repite hasta descifrar la contraseña

### Desbloqueo de Niveles
- El primer nivel (2 dígitos) está desbloqueado automáticamente
- Completa un nivel para desbloquear el siguiente
- Puedes agregar nuevos niveles usando el botón "+1" en la pantalla de inicio

## Lógica Matemática

### Teoría de Mínimos Intentos
El juego calcula el mínimo número teórico de intentos necesarios basado en:
- Número de dígitos de la contraseña
- Sistema de información (hints) utilizado

**Estimaciones por nivel:**
- 2 dígitos: ~13 intentos promedio (mínimo teórico: 2)
- 3 dígitos: ~45 intentos promedio (mínimo teórico: 3)
- 4 dígitos: ~150 intentos promedio (mínimo teórico: 4)
- 5 dígitos: ~500 intentos promedio (mínimo teórico: 5)

### Puntos de Eficiencia
Se otorgan puntos bonus basados en tu desempeño:
- **100 puntos**: ≤20% sobre el mínimo teórico
- **75 puntos**: ≤50% sobre el mínimo
- **50 puntos**: ≤100% sobre el mínimo
- **25 puntos**: ≤200% sobre el mínimo
- **10 puntos**: Completado

## Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada de la aplicación
├── models/
│   └── models.dart                    # Modelos de datos (PlayerData, Level, etc.)
├── logic/
│   ├── game_logic.dart               # Lógica central del juego (RandomNumberStore)
│   └── minimum_attempts_calculator.dart # Cálculos matemáticos
├── services/
│   └── player_data_service.dart      # Persistencia de datos con SharedPreferences
├── screens/
│   ├── home_screen.dart              # Pantalla principal con estadísticas y niveles
│   └── game_screen.dart              # Pantalla de juego
└── widgets/
    └── reusable_widgets.dart         # Componentes reutilizables
```

## Instalación y Ejecución

### Requisitos
- Flutter SDK 3.10.8 o superior
- Dart SDK

### Pasos
1. Clona el repositorio o descomprime el proyecto
2. Ejecuta `flutter pub get` para instalar dependencias
3. Ejecuta `flutter run` para iniciar la aplicación

```bash
flutter pub get
flutter run
```

## Dependencias

- **shared_preferences**: Para almacenamiento local seguro de datos del jugador

## Controles y Navegación

- **Teclado numérico**: Ingresa dígitos
- **Tab/Shift+Tab**: Navega entre campos
- **Botón Validar**: Verifica tu intento
- **Botón Volver**: Regresa a la pantalla anterior

## Consejos para Jugar

1. **Analiza los hints cuidadosamente** - Cada pista te proporciona información valiosa
2. **Usa primero la posición correcta** - Fija los dígitos que están en la posición exacta
3. **Prueba nuevos dígitos** - Si ninguno está en posición correcta, intenta con dígitos diferentes
4. **Sé sistemático** - Desarrolla una estrategia consistente
5. **Practica** - El sistema se vuelve más fácil con la experiencia

## Almacenamiento de Datos

Todos tus datos se guardan localmente en el dispositivo mediante `SharedPreferences`:
- Progreso de niveles
- Historial de partidas
- Estadísticas generales
- Datos del jugador

Los datos se actualizan automáticamente después de cada partida completada.

## Futuras Mejoras

- Modo multijugador competitivo
- Logros y insignias
- Tablas de clasificación global
- Diferentes temas visuales
- Sonidos y efectos de audio
- Análisis estadístico más detallado

## Licencia

Este proyecto es de uso personal y educativo.

---

¡Que disfrutes descubriendo las contraseñas secretas en Numbers Vault! 🔐

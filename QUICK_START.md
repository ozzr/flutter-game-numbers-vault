# 🚀 Quick Start Guide - Numbers Vault

## Inicio Rápido en 3 Pasos

### 1. Instalar Dependencias
```bash
cd d:\Workbench\flutter\numbers_vault
flutter pub get
```

### 2. Ejecutar la Aplicación
```bash
flutter run
```

### 3. ¡Jugar!
La aplicación se abrirá mostrando la pantalla principal con estadísticas y niveles.

---

## 📱 Primera Experiencia

1. **Pantalla de Inicio**
   - Verás tus estadísticas
   - El nivel de 2 dígitos está desbloqueado
   - Los niveles 3, 4, 5 estarán bloqueados

2. **Seleccionar un Nivel**
   - Toca cualquier nivel desbloqueado
   - Se abrirá la pantalla de juego

3. **Jugar**
   - Elige un modo de juego:
     - **Sin límite**: Relájate, sin presión
     - **Con tiempo**: Contrarreloj
     - **Intentos limitados**: Sé cuidadoso
   - Ingresa dígitos en los campos
   - Analiza los hints
   - ¡Descifra la contraseña!

4. **Ver Resultado**
   - Se mostrarán tus estadísticas
   - Tu puntuación y eficiencia
   - Vuelve al inicio para ver el progreso

---

## 🎮 Sistema de Juego Rápido

### ¿Cómo Funcionan los Hints?
```
Contraseña secreta: 5-2-8-1

Tu intento: 1-2-3-4
Resultado: ✓ 1 (el 2 está en posición correcta)
         ~ 1 (el 1 existe pero en otra posición)

Tu intento: 5-2-9-0
Resultado: ✓ 2 (los 5 y 2 están en posición correcta)
         ~ 0 (ningún otro dígito existe)
```

### Estrategia Ganadora
1. Prueba combinaciones aleatorias al principio
2. Fija los dígitos que están en posición correcta
3. Busca nuevos dígitos si ninguno es correcto
4. Usa los hints para refinaria cada intento

---

## 📊 Comprender las Estadísticas

### En la Pantalla de Inicio
- **Contraseñas crackeadas**: Total de niveles completados
- **Tiempo promedio**: Promedio de tiempo en todas las partidas

### En Cada Tarjeta de Nivel
- **Mejor**: Tu mejor puntuación (menos intentos)
- **Partidas**: Total de sesiones jugadas en ese nivel

### Al Terminar una Partida
- **Intentos realizados**: Cuántos intentos necesitaste
- **Tiempo total**: Cuánto tiempo tardaste
- **Mínimo teórico**: El mejor posible basado en matemáticas
- **Eficiencia**: Cuán bien lo hiciste
- **Puntos**: Bonus basado en desempeño

---

## 🔐 Sistema de Desbloqueo

```
Nivel 2 dígitos
    ↓ (Completa)
Nivel 3 dígitos
    ↓ (Completa)
Nivel 4 dígitos
    ↓ (Completa)
Nivel 5 dígitos
    ↓ (Completa o usa +1)
Nivel 6 dígitos (nuevo)
```

**Botón +1**: Agrrega un nuevo nivel con más dígitos

---

## 🎯 Consejos Pro

1. **Aprende los Patrones**
   - Los hints son muy informativos
   - Dos dígitos en posición correcta es gran progreso

2. **Sé Sistemático**
   - No adivines al azar
   - Usa la información de cada intento

3. **Practica en Sin Límite**
   - Sin presión de tiempo
   - Aprende las estrategias

4. **Desafíate**
   - Prueba modo "Timed" cuando te sientas seguro
   - El modo "Intentos limitados" es lo máximo

5. **Desbloquea Nuevos Niveles**
   - Cada nivel desbloqueado es más desafiante
   - Pero también más satisfactorio

---

## 🐛 Solución de Problemas

### "El juego no inicia"
```bash
flutter clean
flutter pub get
flutter run
```

### "Mis datos desaparecieron"
- Los datos se guardan automáticamente
- Revisa que la app tenga permisos de almacenamiento

### "Los campos numéricos no responden"
- Asegúrate de tener el teclado visible
- Prueba tocando directamente en el campo

---

## 📁 Archivos Importantes

```
lib/
├── main.dart              ← Punto de inicio
├── screens/
│   ├── home_screen.dart   ← Pantalla principal
│   └── game_screen.dart   ← Pantalla de juego
├── services/
│   └── player_data_service.dart ← Guarda tus datos
└── logic/
    ├── game_logic.dart    ← Motor del juego
    └── minimum_attempts_calculator.dart ← Cálculos
```

---

## 📖 Documentación Completa

Para información más detallada, lee:
- **GAME_README.md** - Manual del jugador completo
- **PROJECT_SUMMARY.md** - Visión general técnica
- **IMPLEMENTATION_SUMMARY.md** - Detalles de implementación

---

## ✨ Características Destacadas

✅ Persistencia de datos automática  
✅ Múltiples modos de juego  
✅ Sistema de desbloqueo progresivo  
✅ Estadísticas detalladas  
✅ Interfaz moderna y responsiva  
✅ Cálculos matemáticos avanzados  
✅ Tema personalizado  
✅ Sin conexión a internet (100% local)  

---

## 🎮 ¿Listo para Jugar?

1. `flutter run`
2. Selecciona un nivel
3. ¡Que comience el juego!

**¡Que disfrutes descubriendo las contraseñas en Numbers Vault! 🔐**

---

*Última actualización: 2026*  
*Versión: 1.0.0*

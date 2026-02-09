# 🎨 Guía de Diseño Visual - Numbers Vault

## Paleta de Colores

### Colores Principales
```
🟣 Índigo Primario    #6366F1  - Botones, encabezados
🔵 Azul Secundario    #3B82F6  - Información, hints positivos
🟢 Verde Éxito        #10B981  - Contraseña correcta, posición correcta
🟠 Naranja Advertencia #F59E0B - Posición incorrecta, tiempo bajo
🔴 Rojo Error         #EF4444  - Errores, tiempo agotado
🩶 Gris Neutral       #9CA3AF  - Texto secundario, bordes
```

### Variantes
```
Primario claro:    #E0E7FF (fondo de botones)
Gris claro:        #F3F4F6 (fondos de campos)
Gris oscuro:       #374151 (texto principal)
```

---

## 📐 Elementos de UI

### Botones
```
┌─────────────────────────┐
│  Validar                │  ← ElevatedButton
│                         │     padding: 32x16
│                         │     borderRadius: 12
└─────────────────────────┘

Colores:
├─ Normal:     Índigo (#6366F1)
├─ Hover:      Índigo oscuro
├─ Disabled:   Gris (#D1D5DB)
└─ Loading:    Spinner blanco
```

### Campos de Entrada
```
┌────┐
│ 3  │  ← TextFormField
└────┘
size: 60x60
border: 2px gris-claro
focus: 2px índigo
```

### Cards
```
┌──────────────────────────┐
│  Contenido               │
│                          │
└──────────────────────────┘
borderRadius: 16
elevation: 2-4
backgroundColor: blanco/gris-claro
```

---

## 📱 Layouts por Pantalla

### Pantalla Home
```
┌─────────────────────────────┐
│ [≡] Numbers Vault           │  ← AppBar
├─────────────────────────────┤
│ Bienvenido, Player          │  ← Saludo personalizado
├─────────────────────────────┤
│ Estadísticas Generales      │  ← Título
│ ┌───────────┬──────────┐    │
│ │ Contraseña│  Tiempo  │    │  ← StatCard (2 columnas)
│ │ crackeadas│  promedio│    │
│ └───────────┴──────────┘    │
├─────────────────────────────┤
│ Niveles disponibles      [+1]│  ← Título con botón
│ ┌───────────┬──────────┐    │
│ │ 2 dígitos │ 3 dígitos│    │  ← LevelCard (2 columnas)
│ │ ✓ Desbloq │ ✓ Desbloq│    │
│ └───────────┴──────────┘    │
│ ┌───────────┬──────────┐    │
│ │ 4 dígitos │ 5 dígitos│    │
│ │ 🔒 Bloq   │ 🔒 Bloq  │    │
│ └───────────┴──────────┘    │
├─────────────────────────────┤
│ 💡 Consejos                 │  ← Card informativo
│ • Analiza los hints...      │
│ • Usa primero pos. exacta.. │
└─────────────────────────────┘
```

### Pantalla de Juego
```
┌─────────────────────────────┐
│ [←] Nivel 4 dígitos         │  ← AppBar con atrás
├─────────────────────────────┤
│ Modo de juego               │  ← GameModeSelector
│ [Sin límite] [Tiempo] [Lim.]│
├─────────────────────────────┤
│ ⏱️  Tiempo: 1:45            │  ← Timer (si Timed)
├─────────────────────────────┤
│ Ingresa la contraseña:      │  ← Instrucción
│ [_] [_] [_] [_]             │  ← DigitInputField x4
│         [Validar]           │  ← Botón
├─────────────────────────────┤
│ Historial de intentos       │  ← Título
│ #1  5-2-3-1  ✓2  ~0         │  ← AttemptHistoryCard
│ #2  1-9-8-7  ✓1  ~1         │
└─────────────────────────────┘
```

---

## 🎨 Componentes Visuales

### StatCard
```
  📈 Icono (32px)
     Contraseñas
     crackeadas
     
        5
```
- Centrado
- Icono de color
- Título pequeño gris
- Número grande y bold

### LevelCard
```
┌──────────────┐
│  2 dígitos   │
│  ✓ Desbloq   │
│  Mejor: 5    │
│  Partidas: 3 │
└──────────────┘
```
- Background: índigo claro (desbloqueado) o gris (bloqueado)
- Lock icon si está bloqueado
- Info detallada en texto pequeño

### AttemptHistoryCard
```
#2  5-2-3-1  [✓2]  [~0]
```
- Número círculo (izquierda)
- Guess en el centro
- Hints en badges (derecha)
- Colores: verde para correcto, naranja para incorrecto

---

## 🎬 Animaciones

### Al Validar Combinación
```
Campos de entrada
  ↓ (glow effect 200ms)
Hint aparece en pantalla
  ↓ (slide in animation 300ms)
```

### Al Completar Nivel
```
Resultado dialog
  ↓ (scale animation 500ms)
Transición a siguiente pantalla
  ↓ (fade transition 300ms)
```

### Botón Con Clic
```
Presion
  ↓
Ripple effect
  ↓ (200ms)
```

---

## 📐 Espaciado (Padding/Margin)

```
Padding estándar:    16px
Padding interno:     12px
Padding pequeño:     8px
Margen entre cards:  12px
Margen secciones:    24px
```

---

## 🔤 Tipografía

```
Títulos grandes:      Headline Small (24px, bold)
Títulos medianos:     Title Medium (18px, bold)
Subtítulos:           Body Medium (16px)
Texto normal:         Body Small (14px)
Etiquetas:            Label Small (12px)
```

Fuente: Material Design default (Roboto en Android, SF Pro en iOS)

---

## 🌓 Tema Oscuro

### Colores Adaptados
```
Fondo:           #121212 → Card: #1E1E1E
Texto principal: #FFFFFF → Gris claro en modo oscuro
Índigo:          #6366F1 → Más brillante (#818CF8)
Gris:            #9CA3AF → Más claro en oscuro
```

---

## ✨ Efectos Especiales

### Loading Spinner
```
Tipo: CircularProgressIndicator
Color: Índigo
Tamaño: 20px
Ubicación: Centro del botón
```

### Feedback Visual
```
Éxito:  Ícono ✓ + Flash verde
Error:  Ícono ✗ + Flash rojo
Info:   Ícono ℹ + Flash azul
```

### Bordes Redondeados
```
Cards:     16px
Botones:   12px
Campos:    12px
Chips:     8px
```

---

## 📱 Responsive Design

### Breakpoints
```
Mobile:     < 600px
Tablet:     600px - 900px
Desktop:    > 900px
```

### Adaptaciones
```
Mobile:   1 columna
Tablet:   2 columnas
Desktop:  2-3 columnas
```

---

## 🎯 Principios de Diseño

1. **Limpieza**: Mucho espacio en blanco
2. **Contraste**: Colores claros y oscuros bien definidos
3. **Jerarquía**: Títulos grandes, detalles pequeños
4. **Consistencia**: Mismo estilo en todas las pantallas
5. **Accesibilidad**: Colores contrastantes, textos legibles
6. **Feedback**: Respuesta visual inmediata a acciones
7. **Modernidad**: Material Design 3, bordes redondeados

---

## 🔍 Verificación de Diseño

✓ Botones claros y accesibles  
✓ Campos visibles y diferenciados  
✓ Información bien organizada  
✓ Colores consistentes  
✓ Sin aglomeración  
✓ Espaciado adecuado  
✓ Textos legibles  
✓ Responsive en diferentes tamaños  

---

*Guía de diseño visual para Numbers Vault*  
*Última actualización: 2026*

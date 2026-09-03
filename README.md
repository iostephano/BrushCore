# BrushCore — Motor de pincel arcoíris para dibujo en iOS

BrushCore es un Swift Package que dibuja trazos con forma de arcoíris: cada trazo son
cuatro bandas de color paralelas (rojo, amarillo, verde y azul) renderizadas con Core
Graphics. El paquete no depende de UIKit ni de nada externo; solo necesita un
`CGContext`. Junto al paquete va una app demo mínima (`BrushCoreDemoApp`) que lo usa
como dependencia local para pintar sobre un lienzo con el dedo. Existe como proyecto de
portafolio para mostrar una librería reutilizable, con su lógica de geometría separada
y verificada por pruebas, más una app que la consume.

<img width="1390" height="695" alt="BrushCore" src="https://github.com/user-attachments/assets/51d63463-5502-432f-86fe-782692c0d591" />

---

## Tecnologías usadas

- Swift 6 (modo de lenguaje 6, con verificación estricta de concurrencia)
- Swift Package Manager (librería `BrushCore`, sin dependencias)
- Core Graphics para el render de las bandas (`CGContext`, `CGColor`)
- UIKit solo en la app demo (`UIView` por código, sin Storyboards)
- Swift Testing para las pruebas del paquete
- Integración continua con GitHub Actions (corre los tests del paquete y compila la demo)
- Cero dependencias externas

---

## Cómo está organizado el proyecto

```
BrushCore/
├── Package.swift
├── Sources/BrushCore/
│   ├── Brush.swift              # Parámetros del trazo: grosor total y opacidad
│   ├── Stroke.swift             # Puntos del trazo + su Brush
│   └── BrushRenderer.swift      # Geometría de las 4 bandas y su dibujo en un CGContext
├── Tests/BrushCoreTests/
│   └── BrushRendererTests.swift
└── BrushCoreDemoApp/
    ├── BrushCoreDemoApp.xcodeproj   # Referencia a "../" como paquete local
    └── BrushCoreDemoApp/
        ├── AppDelegate.swift / SceneDelegate.swift
        ├── ViewController.swift     # Aloja el lienzo a pantalla completa
        └── CanvasView.swift         # Captura el toque y llama a BrushRenderer
```

El paquete no importa UIKit: `BrushRenderer` trabaja solo con `CGContext`. La geometría
de las bandas (`BrushRenderer.bands(forThickness:)`) es una función pura, y es lo que
cubren las pruebas.

---

## Cómo funciona / flujo principal

1. En la demo, `CanvasView` guarda los puntos por los que pasa el dedo entre
   `touchesBegan` y `touchesEnded`.
2. Al terminar el trazo, crea un `Stroke` con esos puntos y el `Brush` actual y lo
   añade a la lista de trazos.
3. En `draw(_:)`, `CanvasView` recorre todos los trazos (más el que se está pintando)
   y llama a `BrushRenderer.drawStroke(_:in:)` con el `CGContext` de la vista.
4. `BrushRenderer` pide a `bands(forThickness:)` el reparto del grosor total del
   `Brush` entre las cuatro bandas: todas del mismo grosor (algo más anchas que su
   porción exacta, para que se solapen y no queden huecos) y con los centros
   distribuidos de forma simétrica respecto al eje del trazo.
5. Para cada banda, desplaza todos los puntos del trazo en vertical según el offset de
   la banda y traza la polilínea con su color y una opacidad global.

---

## Funcionalidades / qué demuestra

- Una librería Swift Package reutilizable, sin dependencias y sin UIKit.
- Consumo de un paquete local desde una app (`XCLocalSwiftPackageReference` a `..`).
- Geometría de las bandas derivada de un único parámetro (`Brush.size` = grosor total),
  con constantes con nombre en lugar de números mágicos.
- Trazado de polilíneas con Core Graphics: extremos y uniones redondeados, opacidad por
  contexto.
- Lógica de render separada de UIKit y cubierta por pruebas que la ejercen tanto de
  forma directa (la geometría) como dibujando en un bitmap en memoria.

---

## Pruebas

`BrushCoreTests` (Swift Testing) cubre `BrushRenderer`:

- **`bands(forThickness:)`**: siempre hay una banda por color; todas comparten grosor
  (una fracción fija del total); los centros son simétricos respecto al eje y van
  ordenados de arriba a abajo; los bordes exteriores de las bandas extremas abarcan
  exactamente el grosor pedido; la geometría escala de forma lineal con el grosor; un
  grosor de 0 colapsa todas las bandas al eje.
- **`drawStroke(_:in:)`**: un trazo de dos o más puntos deja píxeles pintados en un
  `CGContext` de bitmap; un trazo de un solo punto no pinta nada; un pincel con
  opacidad 0 no pinta nada visible.

Correr los tests:

```bash
swift test
```

---

## Cómo correr el proyecto

1. Clona el repo:
   ```bash
   git clone https://github.com/iostephano/BrushCore.git
   ```
2. Para la librería: abre `Package.swift` con **Xcode 26** (ver `.xcode-version`) o
   corre `swift test` desde la raíz.
3. Para la demo: abre `BrushCoreDemoApp/BrushCoreDemoApp.xcodeproj`, elige un simulador
   de iPhone (objetivo mínimo iOS 26) y ejecuta (Cmd-R). Arrastra el dedo sobre el
   lienzo blanco para pintar.

---

## Cosas pendientes o limitadas (a propósito)

- **El desplazamiento de las bandas es siempre vertical**, no perpendicular a la
  dirección del trazo. Un trazo horizontal se ve como un arcoíris limpio; uno vertical
  solapa los cuatro colores. Hacerlo perpendicular exigiría calcular la normal en cada
  segmento; queda fuera del alcance de la demo.
- **El color no es configurable.** BrushCore es un pincel arcoíris fijo; `Brush` solo
  expone grosor y opacidad.
- **La demo redibuja todos los trazos en cada frame** y los acumula sin límite. No hay
  cacheo en un bitmap ni forma de borrar o deshacer.
- **Un solo toque.** El primer dedo manda; no hay multitáctil ni presión del Pencil.
- **Sin controles en pantalla**: el `Brush` de la demo es fijo (`Brush.default`); no hay
  UI para cambiar grosor u opacidad, aunque `CanvasView.brush` es público para ello.

---

## Autor

Stephano Portella

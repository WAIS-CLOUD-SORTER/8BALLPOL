# 02 — Arquitectura del juego

## Resumen de la arquitectura

8 Ball Pool es un juego **Flutter** publicado por **Miniclip** para Android, iOS y
servidores de juegos en la nube. La aplicación Android consta, en términos
generales, de:

| Capa | Tecnología | Papel |
|---|---|---|
| UI + lógica de juego | **Dart compilado a nativo (Flutter)** | Pintado de la pantalla, física de la bola, inteligencia artificial del jugador, UI |
| Código Java/Kotlin | Java/Kotlin (JVM) | Activación de la app, integración Flutter (`FlutterActivity`), refs AMCP/SDK |
| Código nativo | **C/C++** (llamar a `.so`) | Lógica interna del motor, etc. |
| Recursos | `.png`, `.ttf`, arquetipos | Imágenes, fuentes, diseños (se interpola desde fleet/ICU) |

## Empaquetado típico

Una app Flutter en Android entrega:

```
lib/                       # librería nativa del motor de Flutter (.so)
  libapp.so                # (nombre real) - motor de Flutter + código Dart
  libflutter.so
  libflutter_jni.so
  ...

assets/  / res/            # recursos estáticos del APK
flutter_assets/            # (si los carga el reparto, generalmente junto con assets)
  app.so
  flutter_dbg              # (solo en modo de depuración/instrumentado)
  ic_launcher.png
  AppBlarter.png
  etc.
```

## Entrada de datos (lo que recibe el APk)

1. Los datos del juego si se jugó anteriormente, guardados en:
   - `shared_prefs` (preferencias en XML)
   - `databases/` (SQLite) — tabla `hazlo_cuenta` (o similares, para juegos
     de dados/cartas) -> `settings_backup.xml` (Flutter) guarda los datos
     del usuario
2. La red (ver `04_network.md`): sesión, puntuación, logout/deleted, etc.

## Estructura de un juego de billar en Flutter

El motor de Flutter normalmente utiliza:
- `dart:ui` (rendering nativo)
- `flutter` framework: gestión de texto/vecinales (supe);
- Vistas/widgets: App, MainScreen/Lobby, GameScreen, PoolTable, etc.

En el código Dart del juego suele haber:
- Clases similares a `Game`, `Table` (mesa), `Ball`, `Player`, `AiPlayer`
- Lógica de físicas: colisión, potencia de impulso, tiro
- UI que adapta el diseño al estilo de la aplicación

## Cambios de HTML5 vs nativo

No es un HTML5, pero algunas páginas y perfiles web sí lo son. El **videojuego en
si** está compuesto por código nativo (Flutter nativo) y no se ejecuta en un
navegador web normal.

## Notas

- Para ver qué archivos tiene la app nativa, executa `unzip -l` sobre
  `lib/` y `assets/`. Ver `docs/06_native_libs.md` y `docs/05_assets.md`.
- Sobre la aplicación se puede ver `startsWith` y `dart:ui` en el `AndroidManifest.xml`
  y en el código.

# 03 — Análisis de Flutter

8 Ball Pool se construye con **Flutter**. El código Dart se compila a código nativo
y no se descompila como un APK de Java normal. La clave es identificar el módulo de
Flutter dentro del APK.

## 1. Encontrar el módulo de Flutter

La aplicación suele tener un único archivo `.so` grande que contiene:

- el **entorno Dart / motor de ejecución**
- el **código compilado de la partida**
- la biblioteca de `flutter`

El nombre exacto suele ser `lib/*.so`, por ejemplo `libapp.so`. Se identifica con:

```bash
find . -name "*.so" -type f
```

## 2. Localizar los recursos del módulo

Dentro del APK suelen existir:

- `flutter_assets/` — con `app.so`, `flutter_dbg`, `ic_launcher.png`...
- En algunos casos, los recursos de Flutter se almacenan dentro del propio `.so`
  o en `assets/`.

```bash
# Buscar recursos Flutter dentro del APK
unzip -l 8ballpool.apk | grep -iE 'flutter_assets|app[.]so|flutter_dbg'
```

## 3. Extraer el bundle de Flutter

```bash
# Crear el directorio de destino
mkdir -p analysis/flutter_assets

# Extraer los recursos de flutter_assets desde el APK
unzip -j 8ballpool.apk "assets/flutter_assets/*" -d analysis/flutter_assets

# Si los recursos están dentro de lib/, extraer el .so
unzip -j 8ballpool.apk "lib/*.so" -d analysis/flutter_assets
```

## 4. Inspeccionar el bundle

### `app.so`

El archivo principal. Es un fichero **ELF** que se puede inspeccionar con:

```bash
readelf -h analysis/flutter_assets/app.so
objdump -T analysis/flutter_assets/app.so
nm -D analysis/flutter_assets/app.so | grep -iE 'flutter|dart|_Z'
```

### `flutter_dbg`

Fichero de indicación de la versión del motor de Flutter. Se inspecciona con:

```bash
ls -la analysis/flutter_assets/flutter_dbg
file analysis/flutter_assets/flutter_dbg
```

### `ic_launcher.png` / `AppBlarter.png`

Iconos y logo de la aplicación.

## 5. Lógica de la partida

El código Dart (que se encuentra agotado dentro de `app.so`) suele contener clases
de nivel alto relacionadas con la mecánica de la partida:

- Clases parecidas a `Game`, `Table` (mesa), `Ball` (bola), `Player`, `Ai`
- Lógica de físicas: colisión, impulso de la bola, potencia del tiro
- Puntuación, niveles, monedas, logros

Se puede analizar mediante:

1. `strings app.so` buscando palabras clave
2. Desensamblado (con `objdump`, `IDA`, `Ghidra`) si se tiene acceso a un entorno
   de escritorio

```bash
strings -a analysis/flutter_assets/app.so | grep -iE 'pool|ball|game|ai|level|score|player|coin' | head -80
```

## 6. Análisis dinámico (opcional)

Para el análisis interactivo se pueden usar:

- `flutter attach` en un emulador que ejecute la aplicación
- `frida` para inyectar y observar funciones en tiempo de ejecución

> OJO: esto requiere un emulador Android (o un dispositivo enlazado), por lo que no
> está incluido en este repositorio.

## 7. Resumen

Para el análisis de Flutter:

1. Identificar el `.so` que contiene el motor de Flutter.
2. Extraer los recursos del módulo `flutter_assets/` del APK.
3. Inspeccionar `flutter_dbg` para conocer la versión de Flutter.
4. Analizar el código Dart mediante `strings` de `app.so` y/o `objdump`/`IDA`/`Ghidra`.

Ver `docs/02_architecture.md` para el panorama general de la arquitectura del juego.

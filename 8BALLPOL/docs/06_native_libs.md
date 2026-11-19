# 06 — Análisis de librerías nativas (`.so`)

El juego 8 Ball Pool incluye código nativo en los ficheros `.so` de Android bajo
`lib/<ABI>/`. El análisis de estas librerías es útil para identificar la lógica
del motor, las APIs de mercado, el protocolo de red y las partes críticas de la
partida.

## 1. Localizar y verificar los `.so`

```bash
# Verificar ficheros nativos
find analysis/ -name "*.so" -type f -print -exec ls -la {} +
```

## 2. Inspección básica

Para cada `.so`, ejecutar:

```bash
readelf -h lib/<abi>/lib<name>.so | grep -E 'Type|Machine|Entry'
readelf -d lib/<abi>/lib<name>.so | grep -E 'NEEDED|RPATH|RUNPATH'
```

Esto indica:
- ¿Es una biblioteca compartida de código nativo?
- ¿Qué dependencias (`NEEDED`) tiene?
- Enlace con rutas de carga (`RUNPATH`/`RPATH`)

## 3. Resolución de funciones

```bash
# Funciones exportadas
nm -D lib/<abi>/lib<name>.so | grep -iE 'game|pool|_|_ZN' | head -60

# Funciones con símbolos dinámicos
objdump -T lib/<abi>/lib<name>.so | grep -iE 'game|pool|ball|score|network'
```

## 4. Análisis de cadenas

```bash
strings -a lib/<abi>/lib<name>.so | grep -iE 'http|api|coin|level|achievement|account|login|pool|ball|miniclip' | head -100
```

Esto puede revelar:
- URLs de red
- Prefijos de peticiones
- Nombres de constantes
- Métodos de comunicación (ej. `https://...`, `wss://...`)

## 5. Integración con Flutter

Si la librería nativa combina el motor de Flutter con el código Dart:
1. Buscar en el `.so` las funciones de cargado de `libflutter` y `dart_*`.
2. Buscar el `flutter_assets/` (se describe en `05_assets.md`).
3. Si el `.so` es el mecanismo nativo de la aplicación, es el único punto de
   partida para ver toda la lógica (incluidas las partes que vería el código Dart).

## 6. Herramientas

- `readelf`, `objdump`, `nm`, `strings` (del paquete `binutils`)
- `gdb`, `strace` (para análisis dinámico con un emulador)
- IDB / Ghidra / radare2 (si se tiene acceso local)
- `frida` (para inyectar y interceptar funciones en tiempo de ejecución)

## 7. Limitaciones

- El análisis de código nativo es el paso más costoso y puede requerir
  herramientas de escritorio.
- Los módulos nativos se actualizan en cada versión; la firma de las funciones
  puede cambiar, lo que hará que los nombres sean distintos.
- En caso de no contar con el APK (bloqueado por HTTP 403 en los servidores
  públicos), no se puede acceder a las librerías sin descargarlo.

## 8. Resumen

El archivo `.so` es el principal objeto de análisis. El contenido típico es:
- binario nativo
- dependencias, funciones exportadas, cadenas
- lógica de juego embebida
- posiblemente el bloque de Flutter (`app.so`, etc.)

Verificar siempre la sesión y la licencia antes de trabajar en este apartado.

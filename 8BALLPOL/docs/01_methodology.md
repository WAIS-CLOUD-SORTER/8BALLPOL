# 01 — Metodología de ingeniería inversa

Objetivo: entender cómo funciona el juego **8 Ball Pool** desde el APK Android sin contar con el código fuente original.

El flujo de trabajo recomendado es, en orden:

```
1. Obtener el APK en forma legal (Google Play / APKMirror / el clon oficial)
2. Listar el contenido del APK               -> unzip -l / aapt (si está disponible)
3. Extraer el AndroidManifest.xml            -> descomprimir y leerlo
4. Descompilar java/kotlin                   -> jadx (v1.5.x) sobre classes.dex
5. Inventariar assets del cliente            -> flutter_assets/ y drawable/
6. Analizar librerías nativas (.so)          -> readelf / objdump / strings
7. (opcional) análisis dinámico             -> frida/strace sobre un emulador
8. Documentar cada hallazgo en un fichero
```

## 1. Obtención del APK

Más legítimo: descargarlo con un clon oficial (Google Play / APKMirror / el clon
oficial que gestiona el proyecto responsable).

La descarga automática con `curl` suele ser bloqueada por estas pages (HTTP 403),
por lo que se recomienda descargarla manualmente y copiarla a `analysis/`.

La aplicación tiene el **package name**:

```
com.miniclip.eightballpool
```

## 2. Listado del contenido del APK

```bash
# Si hay aapt disponible
aapt dump badging 8ballpool.apk
unzip -l 8ballpool.apk > analysis/apk_inventory.txt
```

Si no hay `aapt`, extraer los ficheros es siempre posible con `unzip`. El fichero
`AndroidManifest.xml` suele estar a nivel raíz del APK y, en general, descomprimido.
Los directorios típicos dentro de un APK Android son:

```
AndroidManifest.xml
lib/                      # librerías nativas (.so)
res/                      # recursos compilados
assets/                   # assets (si los carga el código nativo)
META-INF/                 # firmaturas
```

## 3. Extracción y lectura del manifest

```bash
unzip -p 8ballpool.apk AndroidManifest.xml > analysis/manifest.xml
```

El fichero contiene, entre otras cosas:
- `package`: `com.miniclip.eightballpool`
- `components`: actividades, servicios, receptores
- `permissions`: permisos declarados
- `uses-feature`: características soportadas (camara, gps, sensor aceleración, etc.)

## 4. Descompilación de java/Kotlin

```bash
export JAVA_HOME=/workspace/8BALLPOL/.work/tools/jdk_extract/jdk-17.0.21.1+2
export PATH="$JAVA_HOME/bin:$PATH"

jadx -d analysis/source -ds analysis/res -r -j 2 8ballpool.apk
```

Esto produce:
- `analysis/source/.../*.java` o `.kt` — código (con o sin nombres originales)
- `analysis/res/` — recursos descodificados

El juego **8 Ball Pool** suele estar implementado en **Flutter**; por lo tanto hay
que vigilar dos capas:
1. El código nativo/Java-Kotlin que rodea a Flutter.
2. El **código Dart**, que aparecerá como un bloque nativo (código `app.so`)
   dentro del archivo `.so` del flutter o en `flutter_assets/`.

## 5. Análisis de assets

```bash
# Buscar imágenes y cuadros dentro del APK
unzip -l 8ballpool.apk | grep -iE 'flutter_assets|assets|images|drawable' | head -40

# Extraer un .png o .ttf a revision para inspección visual
unzip -o 8ballpool.apk -d analysis/assets/ "lib/**" "assets/**" "res/**"
```

## 6. Análisis de librerías nativas

```bash
# Enumerate all .so files
find analysis/ -name '*.so' -type f

# For each .so:
readelf -h  lib/x86_64/lib<name>.so | grep -E 'Type|Machine'
readelf -d  lib/x86_64/lib<name>.so | grep -E 'NEEDED|RPATH|RUNPATH'
objdump -T  lib/x86_64/lib<name>.so | grep -iE 'game|pool|miniclip|_ZN'
strings -a   lib/x86_64/lib<name>.so | grep -iE 'http|api|coin|level|achievement' | head -60
```

Si el juego es Flutter, lo más relevante suele ser un archivo `.so` que
contiene el **entorno Dart** y la **lógica de la partida**:

- `lib/app.so` (o similar)
- `lib/flutter` subdirectorios
- el fichero `flutter_assets/` con `app.so`, `flutter_dbg`, `ic_launcher.png`

## 7. Análisis dinámico (opcional, requiere emulador Android)

```bash
# Con frida instalado y un emulador en ejecución:
frida -U -l scripts/inject.js -f com.miniclip.eightballpool
```

Lo que suele ser útil:
- Interceptar peticiones de red (Burp / objection)
- Interceptar logcat para ver mensajes de diagnóstico
- Revisar las llamadas nativas con `strace` o `frida`

## 8. Registro de hallazgos

Cada fichero en `docs/` debe terminar con un resumen de hallazgos y, si aplica,
los comandos exactos que produjeron la referencia.

```bash
ls -la analysis/
```

> Importante: este repositorio no es de distribución de tools. Se suben únicamente
> ficheros de información y documentación generados.

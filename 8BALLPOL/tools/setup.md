# Guía de instalación del entorno de análisis

Este trabajo se realiza en un entorno Debian 12 (bookworm). No se requiere `sudo`
ni instalación de paquetes del sistema. Todo el material de trabajo está localizado
en el repositorio y en el directorio `.work`.

## 1. Herramientas ya preparadas (dentro de `.work/`)

| Herramienta | Ubicación | Comando de prueba |
|---|---|---|
| JDK 17 (Temurin) | `.work/tools/jdk_extract/jdk-17.0.21.1+2` | `java -version` |
| jadx 1.5.7 | `.work/tools/jadx_extract/bin/jadx` | `jadx -h` |

### Uso

```bash
export JAVA_HOME=/workspace/8BALLPOL/.work/tools/jdk_extract/jdk-17.0.21.1+2
export PATH="$JAVA_HOME/bin:$PATH"

/workspace/8BALLPOL/.work/tools/jadx_extract/bin/jadx -version
# Eso no es estable; se puede usar:
/workspace/8BALLPOL/.work/tools/jadx_extract/bin/jadx -h > /dev/null 2>&1 && echo jadxOK
```

## 2. Herramientas del sistema necesarias

Faltan herramientas senciales, se puede instalar con apt (requiere permisos de
root) o usar python para algunas tareas:

```bash
sudo apt update
sudo apt install -y unzip zip file binutils zipinfo aapt
```

Si no se tiene acceso a `sudo`, se puede usar `apt-get` como usuario residual, pero
en un entorno limitado. La forma recomendada es pedir al administrador del equipo
que instale el paquete `aapt`, o descargar la herramienta `aapt` en el
directorio `analysis/` (por ejemplo, `aapt` de Android SDK Command-line Tools).

## 3. Flujo de trabajo típico

### 3.1 Descargar el APK

Esto **no se puede hacer automáticamente** desde los servidores públicos (típicos
HTTP 403). Se recomienda descargarlo manualmente desde:

- Google Play (anclado oficial)
- APKMirror / APKCombo
- El clon oficial del proyecto (con el mismo source del creador)

Copiar el APK a `analysis/8ballpool.apk`.

### 3.2 Listar y descomprimir

```bash
cd analysis
cp /ruta/al/apk.apk .
unzip -l 8ballpool.apk > apk_inventory.txt
unzip -p 8ballpool.apk AndroidManifest.xml > manifest.xml
unzip -o 8ballpool.apk -d . "lib/**" "assets/**" "res/**"
```

### 3.3 Descompilar java/kotlin

```bash
export JAVA_HOME=/workspace/8BALLPOL/.work/tools/jdk_extract/jdk-17.0.21.1+2
export PATH="$JAVA_HOME/bin:$PATH"

jadx -d source -ds res -r -j 2 8ballpool.apk
# Salida: source/, res/
```

### 3.4 Analizar archivos nativos

```bash
find . -name "*.so" -type f -exec sh -c 'echo "== $1"; readelf -h "$1" | grep -E "Type|Machine"; readelf -d "$1" | grep -E "NEEDED|RPATH|RUNPATH"' _ {} \;
find . -name "*.so" -type f -exec sh -c 'echo "== $1"; strings -a "$1" | grep -iE "http|api|pool|ball|score|level|achievement|login|miniclip" | head -40' _ {} \;
```

## 4. Código de arranque de una tarea típica

Se recomienda crear un script como `scripts/analyze.sh` con los pasos anteriores,
para reproducir el análisis de forma rápida.

### Ejemplo de `scripts/analyze.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

JAVA_HOME="$(pwd)/.work/tools/jdk_extract/jdk-17.0.21.1+2"
export PATH="$JAVA_HOME/bin:$PATH"

APK="${1:-analysis/8ballpool.apk}"
OUT="analysis/output"

mkdir -p "$OUT"
jadx -d "$OUT/source" -ds "$OUT/res" -r -j 2 "$APK"
find "$OUT" -name "*.so" -type f > "$OUT/.so_list"
echo "Haz hecho: $OUT"
```

Esto ayuda a asegurar la reproducibilidad.

## 5. Nota importante

- No subir el APK a este repositorio (es de derechos de autor).
- Solo subir la información extraída/añadida a `analysis/` para revisión.
- El directorio `.work/` se ignora en los commits (ver `tools/.gitignore` y
  `analysis/.gitignore`).

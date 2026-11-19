# 8 Ball Pool — Android Reverse Engineering Workspace

Espacio de trabajo (in English / README principal) para el análisis de ingeniería inversa del juego Android **8 Ball Pool** (`com.miniclip.eightballpool`, editado por Miniclip).

> Este repositorio no alberga un juego modificado ni herramientas de "cheats". Solo contiene documentación, fichas de análisis y datos extraídos de forma legítima. El APK nativo (código de Miniclip) no se incluye por motivos de derechos de autor.

## Contenido

- `docs/` — análisis de ingeniería inversa:
  - `01_methodology.md` — método de análisis
  - `02_architecture.md` — arquitectura del juego
  - `03_flutter_analysis.md` — análisis específico de Flutter
  - `04_network.md` — endpoints y red
  - `05_assets.md` — inventario de assets
  - `06_native_libs.md` — librerías nativas (`.so`)
  - `07_permissions.md` — permisos del `AndroidManifest.xml`
  - `08_versions.md` — historia de versiones y fingerprinting
  - `09_legal.md` — notas legales y éticas
- `analysis/` — resultados parciales del análisis (pendientes de completar)
- `tools/` — guía de instalación y configuración del entorno de trabajo
- `references/` — referencias de cadenas de texto y clases, si las extraemos
- `tools/` (alternativo apuntado por algunos) — guía de instalación

## Acceso rápido al análisis

Para descompilar el `.apk` con `jadx` (requiere Java 17, que ya tenemos empaquetado):

```bash
export JAVA_HOME=/workspace/8BALLPOL/.work/tools/jdk_extract/jdk-17.0.21.1+2
export PATH="$JAVA_HOME/bin:$PATH"

# jadx ya descompila en un solo paso
/workspace/8BALLPOL/.work/tools/jadx_extract/bin/jadx -d analysis/source \
  -ds analysis/res -r -j 2 /ruta/al/apk/8ballpool.apk
```

## Nota legal y ética

- El análisis es puramente de propósito académico/descriptivo.
- No se distribuye el APK original (propiedad de Miniclip), ni se genera un juego modificado, cargador o cheat.
- Para descargar el APK en forma legítima se recomienda un clon oficial (Google Play / APKMirror) que el responsable del proyecto pueda descargar y analizar en su propio entorno.

## Estructura del repositorio

```
8BALLPOL/
├── README.md
├── docs/               # documentos de ingeniería inversa
├── analysis/           # resultados del análisis (añade aquí los ficheros generados)
└── tools/              # guía de instalación
```

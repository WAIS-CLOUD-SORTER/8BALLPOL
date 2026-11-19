# Índice de documentación — Análisis de 8 Ball Pool

Este directorio contiene la guía de ingeniería inversa del juego Android **8 Ball Pool**
(`com.miniclip.eightballpool`, Miniclip).

| Fichero | Contenido |
|---|---|
| [01_methodology.md](01_methodology.md) | Metodología general de análisis (orden de los pasos) |
| [02_architecture.md](02_architecture.md) | Arquitectura del juego (capas, diseño) |
| [03_flutter_analysis.md](03_flutter_analysis.md) | Análisis específico de Flutter (`app.so`, `flutter_assets`) |
| [04_network.md](04_network.md) | Endpoints de red y autenticación |
| [05_assets.md](05_assets.md) | Inventario de assets y recursos extraídos |
| [06_native_libs.md](06_native_libs.md) | Análisis de librerías nativas `.so` |
| [07_permissions.md](07_permissions.md) | Permisos y características del `AndroidManifest.xml` |
| [08_versions.md](08_versions.md) | Versiones, fingerprinting y hash del APK |
| [09_legal.md](09_legal.md) | Notas legales y éticas |

## Flujo recomendado

```
1. Descargar el APK (manual, desde Play / APKMirror / clon oficial)
2. Listar contenido y extraer `AndroidManifest.xml`
3. Descompilar java/kotlin con `jadx`
4. Inventariar assets
5. Analizar librerías nativas `.so`
6. (opcional) Análisis dinámico con emulador
7. Documentar en este directorio
```

## Acceso rápido al análisis

```bash
export JAVA_HOME=/workspace/8BALLPOL/.work/tools/jdk_extract/jdk-17.0.21.1+2
export PATH="$JAVA_HOME/bin:$PATH"
/workspace/8BALLPOL/.work/tools/jadx_extract/bin/jadx -d analysis/source -ds analysis/res -r -j 2 8ballpool.apk
```

## Notas

- El APK original (propiedad de Miniclip) no se incluye en este repositorio.
- Solo se almacenan ficheros de análisis generados por este workspace.

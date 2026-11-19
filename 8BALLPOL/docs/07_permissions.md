# 07 — Permisos del AndroidManifest.xml

El fichero `AndroidManifest.xml` (en raíz del APK) declara los permisos,
características y componentes de la aplicación. Es una fuente de información
relevante para el análisis de la aplicación.

## 1. Extraer el manifiesto

```bash
unzip -p 8ballpool.apk AndroidManifest.xml > analysis/manifest.xml
```

## 2. Lo que encontrarás

### Permisos (`<uses-permission>`)

| Permiso | Posible uso |
|---|---|
| `INTERNET` | Conexión a los servidores de juegos |
| `ACCESS_NETWORK_STATE` | Estado de la red |
| `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE` | Acceso a ficheros |
| `CAMERA` | Si la app usa imágenes/cámara (menos habitual en billar) |
| `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` | Ubicación (menos habitual en este juego) |

> El juego 8 Ball Pool no suele requerir muchos permisos; la presencia de
> `INTERNET` es la más relevante.

### Características (`<uses-feature>`)

```xml
<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-feature android:name="android.hardware.location.gps" android:required="false" />
```

### Componentes (`<activity>`, `<service>`, `<receiver>`)

- `android.app.FlutterActivity` (o similar) que arranca la app Flutter.
- Servicios de fondo, receptores de notificaciones, etc.

## 3. Resumen

| Concepto | Valor típico |
|---|---|
| Package | `com.miniclip.eightballpool` |
| Activitat principal | `FlutterActivity` (o similar) |
| Permisos clave | `INTERNET`, `ACCESS_NETWORK_STATE` |
| Característica | `android.hardware.camera` requerida o opcional según versión |

Ver también `docs/04_network.md` sobre los endpoints que requieren conexión.

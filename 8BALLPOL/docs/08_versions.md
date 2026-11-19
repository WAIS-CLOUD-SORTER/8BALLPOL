# 08 — Historia de versiones y fingerprinting

El APK se actualiza con el tiempo. Para los análisis es útil registrar:

- **Versión del paquete** (`versionCode`, `versionName` en el manifest).
- **Firma de la app** (SHA-256 / MD5 de la clave de firma).
- **Tamaño del APK**.
- **Fecha de publicación** (bajo licencia, no siempre fiable).
- **Hash de los recursos clave** (`flutter_assets/app.so`, `ic_launcher.png`, etc.).

## 1. Extraer versiones desde el manifiesto

```bash
unzip -p 8ballpool.apk AndroidManifest.xml | grep -E 'versionCode|versionName|package'
```

## 2. Verificar firma

```bash
keytool -printcert -jarfile 8ballpool.apk | grep -E 'MD5|Digest'
```

Nota: `keytool` puede estar disponible en el JDK (en `<jdk>/bin/keytool`).

## 3. Registrar un hash del bloque de Flutter

```bash
md5sum analysis/flutter_assets/app.so >> analysis/fingerprint.txt
```

## 4. Uso de los datos

- Para detectar cambios de versión entre dos APKs.
- Para verificar si un APK recién descargado es el mismo que se analizó.
- Para diferenciar versiones maliciosas (el 8 Ball Pool tampoco identifica de
  forma fiable un APK modificado).

## 5. Nota importante

Los datos de la propiedad intelectual (logo, iconos, código) pertenecen a Miniclip.
El análisis aquí es solo descriptivo, y el fichero `fingerprint.txt` sirve para
reproducir la línea de trabajo.

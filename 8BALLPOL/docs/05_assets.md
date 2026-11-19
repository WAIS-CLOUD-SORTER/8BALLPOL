# 05 — Inventario de assets

El juego almacena recursos estáticos (imágenes, sonidos, fuentes, diseños, y
compatibilidad con operaciones de letras) dentro del APK. El objetivo de este
fichero es dar un método para listar y clasificar dichos recursos.

## 1. Localizar los directorios

```bash
# Listar objetos con extensiones típicas:
unzip -l 8ballpool.apk | grep -iE '\.(png|jpg|jpeg|webp|ttf|otf|mp3|wav|json|txt|html|css|js)$' | head -80
```

Los directorios donde pueden estar los assets:

| Directorio | Descripción |
|---|---|
| `assets/` | Assets estáticos accesibles desde el código nativo o Dart |
| `flutter_assets/` | Contiene `app.so`, `flutter_dbg`, iconos, etc. |
| `res/` | Recursos compilados (imágenes legibles, layouts) |
| `lib/` | Librerías nativas, a veces con recursos embebidos |

## 2. Extraer sin perder el árbol

```bash
mkdir -p analysis/assets
unzip -o 8ballpool.apk -d analysis/assets "lib/**" "assets/**" "res/**"
```

## 3. Inventariar los ficheros

```bash
# Total de ficheros
find analysis/assets -type f | wc -l

# Extensiones y conteo
find analysis/assets -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn

# Path y tamaños
find analysis/assets -type f -printf '%P %s bytes\n' | sort
```

## 4. Identificar recursos clave

Buscar ficheros con nombre que sugiera:
- Tablero de billar / bolas: `pool`, `table`, `ball`, `8ball`, `table_*.png`
- Iconos/UI: `ic_launcher`, `logo`, `menu`, `btn`
- Fuentes: `*.ttf`, `*.otf`
- Compatibilidad con letras: `fonts/`, `fnt/`, `ttf/`

## 5. Verificar integridad

```bash
find analysis/assets -type f -exec md5sum {} + > analysis/assets.md5
```

## 6. Notas importantes

- No se incluyen aquí las imágenes originales de las bolas ni la tabla de billar
  por derechos de autor.
- Los recursos extraídos son únicamente para análisis y estudio.
- Si se genera un reporte de recursos de salida (código, imágenes descodificadas),
  se guarda en `analysis/res/` y se documenta en este fichero.

## 7. Referencias

- Ver `docs/01_methodology.md` paso 5 sobre análisis de assets.
- Ver `docs/06_native_libs.md` para recursos ligados a librerías nativas.

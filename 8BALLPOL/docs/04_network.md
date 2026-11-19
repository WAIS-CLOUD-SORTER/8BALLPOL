# 04 — Endpoints y red

El juego, al ser una aplicación de servicios en la nube, necesita una conexión a
Internet para jugar, sincronizar puntuaciones y descargar recursos. Esto implica
inicio de sesión de la app (AMCP/oAuth) y comunicación con los servidores de
Miniclip.

## 1. ¿Qué datos se intercambian?

- **Inicio de sesión**: cuenta de usuario (nombre de usuario, cifrado de
  contraseña, token de acceso).
- **Cache de sesión**: ID de sesión, token de API, cookies de navegación (ej:
  `ASP.NET_SessionId`).
- **Información de juego**: puntuación, nivel, monedas, partida actual, historial
  de juegos, etc.
- **Descarga de contenido**: imágenes, niveles, emotes, etc.

## 2. Dominios típicos

De la descripción de la app (SDK) y de las publicaciones de la comunidad se
recomienda revisar en el código y en los libros:
- **Miniclip** — `*miniclip.com` (por ejemplo: `api.miniclip.com`, `account.miniclip.com`).
- **Servicios de juegos en la nube** — dependiendo de la versión, se usan endpoints
  como `/api/...`, `/web/...` y `/chat/...` para la partida.

## 3. Autenticación

La app suele usar:
- **Token JWT** o **clave de sesión** (AMCP) para autenticar al cliente.
- **Cifrado** de los datos como password y datos de sesión (es probable que
  se aplique algo de cifrado con un socket personalizado).

> Nota: analizar la red es una de las partes más sensibles del estudio. Se
> recomienda usar un entorno aislado y, siempre, sin descargar ni reproducir
> contenido protegido por derechos de autor.

## 4. Herramientas recomendadas (solo en el local de análisis de la red)

- **Burp Suite / OWASP ZAP** — interceptar tráfico HTTP/S
- **mitmproxy** — reescritura de peticiones
- **adb logcat** — mensajes de la app (si se ejecuta en un emulador/dispositivo)

## 5. Resumen

| Tipo | Elementos |
|---|---|
| Inicio de sesión | nombre de usuario, cifrado de contraseña, token |
| Sesión | token, cookies, ID de sesión |
| Partida | puntuación, nivel, monedas, partida actual |
| Red | `miniclip.com` (obsoleto) y endpoints de juegos sin conexión |

Recordar consultar `docs/07_permissions.md` sobre los permisos necesarios para la
conexión (red, internet, etc.). Ver también `docs/01_methodology.md` sobre cómo
adjuntar los endpoints una vez descubiertos.


# App Radio (Flutter)

App de radio con Flutter usando `just_audio` y `just_audio_background`, con:
- Lista de estaciones
- Canales por estación
- Reproductor con portada, título y estado de buffering
- Favoritos (local con `shared_preferences`)
- Fetch remoto opcional (Laravel API) con _fallback_ a `assets/stations.json`

## Requisitos
- Flutter 3.22+
- Android SDK 21+ / iOS 12+

## Configuración rápida
1. `flutter pub get`
2. Android: abrir `android/app/src/main/AndroidManifest.xml` y verifica los permisos (ya incluidos).
3. iOS: el `Info.plist` ya incluye Audio Background y ATS (HTTP).

## Correr
```bash
flutter run
```

## API Remota (opcional)
En `lib/services/api_service.dart` cambia `baseUrl` por tu endpoint de Laravel. Si la API falla, se usa el JSON local en `assets/stations.json`.

## Estructura
- `lib/models/` -> `Station`, `Channel`
- `lib/services/` -> `ApiService`, `RadioPlayerService`, `FavoritesService`
- `lib/pages/` -> `HomePage`, `RadioPlayerPage`
- `lib/widgets/` -> componentes UI

## Nota
`assets/images/logo.png` es un placeholder. Reemplázalo por tu logo.

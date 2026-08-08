# Favourite Menu Wireframe

A functional Material 3 wireframe for a Flutter UI design workshop. The app
keeps the complete interaction model while intentionally using generic content,
standard Flutter components, and grey image placeholders.

## Requirements

- Flutter 3.44.4
- Dart 3.12.2
- Xcode 26.6 for the iOS simulator

## Run on web

```bash
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

## Run on iOS

```bash
open -a Simulator
flutter run -d "iPhone 16 Pro"
```

## Verify

```bash
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter build web
flutter build ios --simulator --debug
flutter test integration_test/menu_journey_test.dart -d "iPhone 16 Pro"
```

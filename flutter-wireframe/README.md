# Favourite Menu

An iPhone-first Flutter prototype for turning photos of memorable restaurant dishes into a polished, price-free menu organized by Breakfast, Lunch, and Dinner.

## Requirements

- Flutter 3.44.4
- Dart 3.12.2
- Xcode 26.6
- An iPhone simulator or physical iPhone

The app uses deterministic local mock analysis. It requires no backend, account, API key, or network connection at runtime.

## Run

```bash
flutter pub get
open -a Simulator
flutter run -d "iPhone 16 Pro"
```

On the Add Dish tab, choose **Try a sample dish** for the fastest demo. Review the suggested name, restaurant, description, and meal section, then select **Add to menu**. The finalized dish appears immediately on the My Menu tab.

Camera and photo-library actions use the native iOS pickers. The permission purpose strings are configured in `ios/Runner/Info.plist`.

## Print or save

Add at least one dish, open My Menu, select Editorial, Modern, or Bistro, and tap **Print menu**. The native iOS print preview can print or save/share the generated A4 PDF. Empty meal sections are omitted from the PDF.

## Verify

```bash
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/menu_journey_test.dart -d "iPhone 16 Pro"
flutter build ios --simulator --debug
```

The sample food photographs were generated specifically for this prototype with OpenAI image generation. The bundled Noto fonts are distributed under the SIL Open Font License through the Google Fonts project.

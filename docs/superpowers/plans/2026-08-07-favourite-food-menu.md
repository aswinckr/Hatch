# Favourite Food Menu Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a polished iPhone-only Flutter prototype that turns a food photo into an editable dish and adds it to a live, categorized, printable personal menu.

**Architecture:** Use a feature-first Flutter structure with immutable domain models, a single `MenuController` as observable application state, repository interfaces for persistence and analysis, and small platform adapters for image intake and PDF sharing. All intelligence is deterministic and local; the live preview and PDF renderer consume the same menu snapshot.

**Tech Stack:** Flutter 3.44.4, Dart 3.12.2, Cupertino/Material widgets, `shared_preferences`, `image_picker`, `pdf`, `printing`, `flutter_test`, and `integration_test`.

## Global Constraints

- Target iPhone only; do not configure or test Android, web, iPad, macOS, Windows, or Linux deliverables.
- Require no backend, account, network connection, API key, or external service at runtime.
- Store the menu and preferences locally on device.
- Keep the printable menu price-free and group dishes only into Breakfast, Lunch, and Dinner.
- Keep all mock-analysis output editable before finalization.
- Respect safe areas, Dynamic Type, reduced motion, semantic labels, and accessible contrast.
- Empty sections appear in the live builder but are omitted from the PDF.
- Use portrait orientation and common iPhone screen sizes as the layout target.

## File map

```text
lib/
  main.dart                              # app bootstrap and dependency wiring
  app/hatch_app.dart                     # Cupertino app and global theme
  app/app_shell.dart                     # Add Dish / My Menu tab state
  core/design/app_colors.dart            # shared palette tokens
  core/design/app_typography.dart        # text styles with Dynamic Type support
  features/menu/domain/dish.dart         # Dish and MealSection models
  features/menu/domain/menu_style.dart   # Editorial, Modern, Bistro definitions
  features/menu/data/menu_repository.dart
  features/menu/data/preferences_menu_repository.dart
  features/menu/application/menu_controller.dart
  features/add_dish/domain/dish_analysis.dart
  features/add_dish/data/mock_dish_analyzer.dart
  features/add_dish/presentation/add_dish_screen.dart
  features/add_dish/presentation/dish_review_form.dart
  features/menu/presentation/menu_screen.dart
  features/menu/presentation/menu_page.dart
  features/menu/presentation/dish_editor_sheet.dart
  features/export/menu_pdf_renderer.dart
  features/export/menu_export_service.dart
assets/demo/                               # bundled food images
test/                                     # unit and widget tests mirroring lib
integration_test/menu_journey_test.dart   # primary end-to-end journey
ios/Runner/Info.plist                     # camera/photo permission copy
README.md                                 # setup, launch, demo, and verification
```

---

### Task 1: Scaffold the iPhone Flutter app and domain foundation

**Files:**
- Create: `pubspec.yaml`
- Create: `lib/main.dart`
- Create: `lib/app/hatch_app.dart`
- Create: `lib/core/design/app_colors.dart`
- Create: `lib/core/design/app_typography.dart`
- Create: `lib/features/menu/domain/dish.dart`
- Create: `lib/features/menu/domain/menu_style.dart`
- Create: `test/features/menu/domain/dish_test.dart`
- Modify: `ios/Runner/Info.plist`

**Interfaces:**
- Produces: `enum MealSection`, immutable `Dish`, `enum MenuStyle`, and `HatchApp`.
- Produces: `Dish.copyWith(...)`, `Dish.toJson()`, and `Dish.fromJson(Map<String, Object?>)`.

- [ ] **Step 1: Generate the project and declare dependencies**

Run:

```bash
flutter create --platforms=ios --org com.example --project-name hatch_menu .
flutter pub add shared_preferences image_picker pdf printing
```

Set the description in `pubspec.yaml` to `A personal menu of favourite restaurant dishes.` and add `assets/demo/` beneath `flutter/assets`.

- [ ] **Step 2: Write the failing domain test**

```dart
test('dish round-trips through JSON and copyWith changes only one field', () {
  final dish = Dish(
    id: 'dish-1', imagePath: '/tmp/eggs.jpg', name: 'Truffle Eggs',
    restaurant: 'Morgenrot', description: 'Brioche and hollandaise',
    mealSection: MealSection.breakfast,
    createdAt: DateTime.utc(2026, 8, 7), updatedAt: DateTime.utc(2026, 8, 7),
  );
  expect(Dish.fromJson(dish.toJson()), dish);
  expect(dish.copyWith(name: 'Truffle Eggs Benedict').restaurant, 'Morgenrot');
});
```

- [ ] **Step 3: Run the test and verify the expected failure**

Run: `flutter test test/features/menu/domain/dish_test.dart`

Expected: compilation fails because `Dish` and `MealSection` do not exist.

- [ ] **Step 4: Implement the domain types and app shell**

Define:

```dart
enum MealSection { breakfast, lunch, dinner }

class Dish {
  const Dish({required this.id, required this.imagePath, required this.name,
    required this.restaurant, required this.description,
    required this.mealSection, required this.createdAt, required this.updatedAt});
  final String id, imagePath, name, restaurant, description;
  final MealSection mealSection;
  final DateTime createdAt, updatedAt;
  Dish copyWith({String? imagePath, String? name, String? restaurant,
    String? description, MealSection? mealSection, DateTime? updatedAt});
  Map<String, Object?> toJson();
  factory Dish.fromJson(Map<String, Object?> json);
}

enum MenuStyle { editorial, modern, bistro }
```

Implement value equality using `operator ==` and `hashCode`. Create `HatchApp` as a `CupertinoApp` with `debugShowCheckedModeBanner: false`, warm cream/espresso/terracotta design tokens, and a temporary `CupertinoPageScaffold` home. Lock `main()` to portrait with `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` before `runApp`.

Add these iOS permission strings:

```xml
<key>NSCameraUsageDescription</key>
<string>Photograph a favourite dish to add it to your menu.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Choose a food photo to add it to your menu.</string>
```

- [ ] **Step 5: Verify the foundation**

Run: `dart format lib test && flutter analyze && flutter test test/features/menu/domain/dish_test.dart`

Expected: analyzer has no issues and the domain test passes.

- [ ] **Step 6: Commit**

```bash
git add pubspec.yaml pubspec.lock lib ios test
git commit -m "feat: scaffold iPhone menu app"
```

### Task 2: Add local persistence and observable menu state

**Files:**
- Create: `lib/features/menu/data/menu_repository.dart`
- Create: `lib/features/menu/data/preferences_menu_repository.dart`
- Create: `lib/features/menu/application/menu_controller.dart`
- Create: `test/features/menu/application/menu_controller_test.dart`

**Interfaces:**
- Consumes: `Dish`, `MealSection`, and `MenuStyle` from Task 1.
- Produces: `MenuRepository.load()`, `MenuRepository.save(...)`, `PreferencesMenuRepository`, and `MenuController`.
- Produces: `MenuController.initialize()`, `addDish`, `updateDish`, `removeDish`, `setStyle`, and `dishesFor`.

- [ ] **Step 1: Write controller tests with an in-memory repository**

```dart
test('add, categorize, update, remove, and style changes persist', () async {
  final repository = MemoryMenuRepository();
  final controller = MenuController(repository);
  await controller.initialize();
  await controller.addDish(breakfastDish);
  expect(controller.dishesFor(MealSection.breakfast), [breakfastDish]);
  await controller.updateDish(breakfastDish.copyWith(name: 'New name'));
  expect(controller.dishes.single.name, 'New name');
  await controller.setStyle(MenuStyle.bistro);
  expect(controller.style, MenuStyle.bistro);
  await controller.removeDish(breakfastDish.id);
  expect(controller.dishes, isEmpty);
  expect(repository.saveCount, 4);
});
```

Also test that `initialize()` restores serialized dishes and the selected style.

- [ ] **Step 2: Run tests and confirm they fail**

Run: `flutter test test/features/menu/application/menu_controller_test.dart`

Expected: compilation fails because repository and controller types are absent.

- [ ] **Step 3: Implement persistence and controller**

```dart
abstract interface class MenuRepository {
  Future<MenuSnapshot> load();
  Future<void> save(MenuSnapshot snapshot);
}

class MenuSnapshot {
  const MenuSnapshot({required this.dishes, required this.style});
  final List<Dish> dishes;
  final MenuStyle style;
}

class MenuController extends ChangeNotifier {
  MenuController(this._repository);
  final MenuRepository _repository;
  List<Dish> get dishes => List.unmodifiable(_dishes);
  MenuStyle get style => _style;
  List<Dish> dishesFor(MealSection section) =>
      _dishes.where((dish) => dish.mealSection == section).toList(growable: false);
  Future<void> initialize();
  Future<void> addDish(Dish dish);
  Future<void> updateDish(Dish dish);
  Future<void> removeDish(String id);
  Future<void> setStyle(MenuStyle style);
}
```

Encode one JSON object containing `version`, `dishes`, and `style` into the `hatch.menu.snapshot.v1` SharedPreferences key. On malformed data, return an empty Editorial snapshot rather than crashing.

- [ ] **Step 4: Run controller tests**

Run: `dart format lib test && flutter test test/features/menu/application/menu_controller_test.dart`

Expected: all controller and persistence tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/features/menu test/features/menu
git commit -m "feat: persist menu collection locally"
```

### Task 3: Implement deterministic mock analysis and demo assets

**Files:**
- Create: `lib/features/add_dish/domain/dish_analysis.dart`
- Create: `lib/features/add_dish/data/mock_dish_analyzer.dart`
- Create: `assets/demo/truffle_eggs.jpg`
- Create: `assets/demo/miso_cod.jpg`
- Create: `assets/demo/tiramisu.jpg`
- Create: `test/features/add_dish/data/mock_dish_analyzer_test.dart`

**Interfaces:**
- Consumes: `MealSection`.
- Produces: `DishAnalyzer.analyze(String imagePath)` and `MockDishAnalyzer`.
- Produces: `DishAnalysis(name, restaurant, description, mealSection)`.

- [ ] **Step 1: Write the failing deterministic-analysis test**

```dart
test('same demo image always returns the same editable suggestion', () async {
  final analyzer = MockDishAnalyzer(delay: Duration.zero);
  final first = await analyzer.analyze('assets/demo/truffle_eggs.jpg');
  final second = await analyzer.analyze('assets/demo/truffle_eggs.jpg');
  expect(first, second);
  expect(first.name, 'Truffle Eggs Benedict');
  expect(first.mealSection, MealSection.breakfast);
});
```

Add a test that an unknown filename still produces a complete generic suggestion.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/features/add_dish/data/mock_dish_analyzer_test.dart`

Expected: compilation fails because `MockDishAnalyzer` is absent.

- [ ] **Step 3: Implement the analyzer contract and scenarios**

```dart
abstract interface class DishAnalyzer {
  Future<DishAnalysis> analyze(String imagePath);
}

class MockDishAnalyzer implements DishAnalyzer {
  MockDishAnalyzer({this.delay = const Duration(milliseconds: 1100)});
  final Duration delay;
  @override
  Future<DishAnalysis> analyze(String imagePath) async {
    await Future<void>.delayed(delay);
    for (final entry in scenarios.entries) {
      if (imagePath.contains(entry.key)) return entry.value;
    }
    return genericSuggestion;
  }
}
```

Use three royalty-free or original bundled food images. Add exact credits to `README.md` if any asset license requires attribution. Scenario descriptions must be concise and price-free.

- [ ] **Step 4: Verify analyzer and asset declaration**

Run: `flutter test test/features/add_dish/data/mock_dish_analyzer_test.dart && flutter analyze`

Expected: tests pass and all declared assets resolve.

- [ ] **Step 5: Commit**

```bash
git add assets lib/features/add_dish test/features/add_dish pubspec.yaml README.md
git commit -m "feat: add local dish analysis scenarios"
```

### Task 4: Build the Add Dish guided workflow

**Files:**
- Create: `lib/features/add_dish/presentation/add_dish_screen.dart`
- Create: `lib/features/add_dish/presentation/dish_review_form.dart`
- Create: `lib/app/app_shell.dart`
- Modify: `lib/main.dart`
- Modify: `lib/app/hatch_app.dart`
- Create: `test/features/add_dish/presentation/add_dish_screen_test.dart`

**Interfaces:**
- Consumes: `DishAnalyzer` and `MenuController.addDish(Dish)`.
- Produces: `AddDishScreen`, `DishReviewForm`, and `AppShell` with tab indices `0` Add Dish and `1` My Menu.
- Callback: `Future<void> onDishFinalized(Dish dish)`.

- [ ] **Step 1: Write widget tests for the complete guided state machine**

```dart
testWidgets('sample photo becomes editable dish and finalizes', (tester) async {
  final analyzer = FakeDishAnalyzer(truffleAnalysis);
  Dish? finalized;
  await tester.pumpWidget(testApp(AddDishScreen(
    analyzer: analyzer,
    onDishFinalized: (dish) async => finalized = dish,
  )));
  await tester.tap(find.text('Try a sample dish'));
  await tester.pumpAndSettle();
  expect(find.text('Review your dish'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('dish-name')), 'My Eggs');
  await tester.tap(find.text('Add to menu'));
  await tester.pumpAndSettle();
  expect(finalized?.name, 'My Eggs');
});
```

Add tests for required-field validation, manual fallback after analyzer failure, and camera/photo-library action availability.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/features/add_dish/presentation/add_dish_screen_test.dart`

Expected: compilation fails because presentation widgets do not exist.

- [ ] **Step 3: Implement the guided workflow**

Use a private state enum:

```dart
enum AddDishStage { choosePhoto, analyzing, review, complete }
```

`choosePhoto` shows a large camera action, photo-library action, and `Try a sample dish`. `analyzing` shows the image with a restrained progress treatment and semantic status. `review` uses labeled fields for dish, restaurant, description, and a three-option `CupertinoSlidingSegmentedControl<MealSection>`. `complete` announces success and resets to `choosePhoto` after the menu tab is notified.

Generate IDs without another dependency:

```dart
final id = '${DateTime.now().microsecondsSinceEpoch}-${imagePath.hashCode.abs()}';
```

Use `ImagePicker.pickImage(source: ...)`. On `PlatformException`, show permission guidance with `CupertinoAlertDialog` and retain the sample-dish escape hatch.

- [ ] **Step 4: Wire the controller and tabs**

Construct repository, controller, analyzer, and export service once during bootstrap. `AppShell` owns a `CupertinoTabScaffold`; after finalization it calls `controller.addDish`, sets the menu tab badge, and leaves the user on Add Dish so they can continue. Selecting My Menu clears the badge.

- [ ] **Step 5: Verify workflow tests**

Run: `dart format lib test && flutter analyze && flutter test test/features/add_dish/presentation/add_dish_screen_test.dart`

Expected: all Add Dish tests pass with no analyzer issues.

- [ ] **Step 6: Commit**

```bash
git add lib test ios
git commit -m "feat: build guided dish capture flow"
```

### Task 5: Build the live categorized menu

**Files:**
- Create: `lib/features/menu/presentation/menu_screen.dart`
- Create: `lib/features/menu/presentation/menu_page.dart`
- Modify: `lib/app/app_shell.dart`
- Create: `test/features/menu/presentation/menu_screen_test.dart`

**Interfaces:**
- Consumes: `MenuController`, `MenuStyle`, and `MealSection`.
- Produces: `MenuScreen(controller, onExport)` and reusable `MenuPage(snapshot, showEmptySections)`.

- [ ] **Step 1: Write live-menu widget tests**

```dart
testWidgets('empty builder shows all sections and finalized dish appears', (tester) async {
  final controller = MenuController(MemoryMenuRepository());
  await controller.initialize();
  await tester.pumpWidget(testApp(MenuScreen(controller: controller, onExport: (_) async {})));
  expect(find.text('BREAKFAST'), findsOneWidget);
  expect(find.text('LUNCH'), findsOneWidget);
  expect(find.text('DINNER'), findsOneWidget);
  await controller.addDish(breakfastDish);
  await tester.pump();
  expect(find.text(breakfastDish.name), findsOneWidget);
  expect(find.text(breakfastDish.restaurant), findsOneWidget);
});
```

Add tests that section prompts disappear when populated, entries are sorted by `createdAt`, and an empty collection disables `Print menu`.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/features/menu/presentation/menu_screen_test.dart`

Expected: compilation fails because menu presentation widgets are absent.

- [ ] **Step 3: Implement the menu builder**

`MenuScreen` listens to the controller with `AnimatedBuilder`. `MenuPage` renders a centered menu title, ornamental divider, and each `MealSection.values` section. For live mode, pass `showEmptySections: true` and render copy such as `Your breakfast favourites will appear here.`

Each populated entry renders:

```dart
Column(children: [
  Text(dish.name, style: theme.dishName),
  if (dish.description.trim().isNotEmpty) Text(dish.description),
  Text(dish.restaurant, style: theme.restaurant),
]);
```

Wrap insertion in `AnimatedSize` and disable animation when `MediaQuery.disableAnimationsOf(context)` is true.

- [ ] **Step 4: Verify live updates and narrow layouts**

Run: `flutter test test/features/menu/presentation/menu_screen_test.dart && flutter test --coverage`

Expected: menu tests pass; no overflow exceptions at a 375×667 logical-pixel surface.

- [ ] **Step 5: Commit**

```bash
git add lib/features/menu/presentation lib/app test/features/menu/presentation
git commit -m "feat: add live categorized menu"
```

### Task 6: Add dish editing, removal, and menu themes

**Files:**
- Create: `lib/features/menu/presentation/dish_editor_sheet.dart`
- Modify: `lib/features/menu/presentation/menu_screen.dart`
- Modify: `lib/features/menu/presentation/menu_page.dart`
- Modify: `lib/features/menu/domain/menu_style.dart`
- Create: `test/features/menu/presentation/menu_editing_test.dart`

**Interfaces:**
- Consumes: `MenuController.updateDish`, `removeDish`, and `setStyle`.
- Produces: `DishEditorSheet(dish, onSave, onDelete)` and complete visual tokens for all three `MenuStyle` values.

- [ ] **Step 1: Write editing and theme tests**

```dart
testWidgets('edits category, confirms deletion, and changes style', (tester) async {
  final controller = seededController(breakfastDish);
  await tester.pumpWidget(testApp(MenuScreen(controller: controller, onExport: (_) async {})));
  await tester.tap(find.text(breakfastDish.name));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Lunch'));
  await tester.tap(find.text('Save changes'));
  await tester.pumpAndSettle();
  expect(controller.dishes.single.mealSection, MealSection.lunch);
  await tester.tap(find.byKey(const Key('theme-bistro')));
  expect(controller.style, MenuStyle.bistro);
});
```

Add a separate test that tapping Delete shows confirmation and cancellation preserves the dish.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/features/menu/presentation/menu_editing_test.dart`

Expected: widget lookup or compilation fails because editing controls are absent.

- [ ] **Step 3: Implement editor and three theme definitions**

Open `DishEditorSheet` from a dish tap using `showCupertinoModalPopup`. Reuse the validation rules from `DishReviewForm`, save an updated timestamp, and require confirmation before `removeDish`.

Map each `MenuStyle` to a `MenuVisualTheme`:

```dart
class MenuVisualTheme {
  const MenuVisualTheme({required this.paper, required this.ink,
    required this.accent, required this.titleFamily, required this.bodyFamily});
  final Color paper, ink, accent;
  final String titleFamily, bodyFamily;
}
```

Editorial uses cream/espresso/terracotta, Modern uses off-white/near-black/cobalt, and Bistro uses parchment/burgundy/forest. Keep body contrast at or above WCAG AA.

- [ ] **Step 4: Verify mutation and theme behavior**

Run: `dart format lib test && flutter analyze && flutter test test/features/menu/presentation/menu_editing_test.dart`

Expected: tests pass and state persists after every mutation.

- [ ] **Step 5: Commit**

```bash
git add lib/features/menu test/features/menu
git commit -m "feat: edit dishes and select menu themes"
```

### Task 7: Generate, preview, share, and print the PDF

**Files:**
- Create: `lib/features/export/menu_pdf_renderer.dart`
- Create: `lib/features/export/menu_export_service.dart`
- Modify: `lib/features/menu/presentation/menu_screen.dart`
- Create: `test/features/export/menu_pdf_renderer_test.dart`

**Interfaces:**
- Consumes: immutable `MenuSnapshot` and `MenuVisualTheme`.
- Produces: `Future<Uint8List> MenuPdfRenderer.render(MenuSnapshot snapshot)`.
- Produces: `MenuExportService.preview(MenuSnapshot)` and `share(MenuSnapshot)`.

- [ ] **Step 1: Write renderer tests**

```dart
test('PDF contains populated sections and omits empty ones', () async {
  final bytes = await MenuPdfRenderer().render(MenuSnapshot(
    dishes: [breakfastDish], style: MenuStyle.editorial,
  ));
  expect(bytes.take(4), orderedEquals('%PDF'.codeUnits));
  final text = await extractPdfText(bytes);
  expect(text, contains('BREAKFAST'));
  expect(text, contains(breakfastDish.name));
  expect(text, isNot(contains('LUNCH')));
  expect(text, isNot(contains('DINNER')));
});
```

Implement `extractPdfText` in the test using a small byte-string scan for uncompressed test output; configure the renderer with `compress: false` in tests. Also test a long description produces a non-empty multi-page PDF without throwing.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/features/export/menu_pdf_renderer_test.dart`

Expected: compilation fails because the renderer is absent.

- [ ] **Step 3: Implement deterministic PDF rendering**

Use `package:pdf/widgets.dart` with A4 pages, the package's offline Times/Helvetica fonts, 18 mm margins, and `MultiPage`. Iterate `MealSection.values`, filter empty groups, and render the same title/name/description/restaurant hierarchy as `MenuPage`. Never include image paths, timestamps, prices, or empty headings.

```dart
Future<Uint8List> render(MenuSnapshot snapshot) async {
  if (snapshot.dishes.isEmpty) throw const EmptyMenuException();
  final document = pw.Document();
  document.addPage(pw.MultiPage(build: (_) => buildMenu(snapshot)));
  return document.save();
}
```

- [ ] **Step 4: Implement native preview and share adapters**

Use:

```dart
Future<void> preview(MenuSnapshot snapshot) => Printing.layoutPdf(
  name: 'My Favourite Menu.pdf', onLayout: (_) => renderer.render(snapshot));

Future<void> share(MenuSnapshot snapshot) async => Printing.sharePdf(
  bytes: await renderer.render(snapshot), filename: 'my-favourite-menu.pdf');
```

On `MenuScreen`, keep export disabled for an empty menu. For renderer or printing failures, show a Cupertino alert with Retry and Cancel; never mutate menu state.

- [ ] **Step 5: Verify PDF behavior**

Run: `dart format lib test && flutter analyze && flutter test test/features/export/menu_pdf_renderer_test.dart`

Expected: PDF tests pass, including empty-section omission and long-content pagination.

- [ ] **Step 6: Commit**

```bash
git add lib/features/export lib/features/menu/presentation test/features/export
git commit -m "feat: export menu as printable PDF"
```

### Task 8: Complete accessibility, integration coverage, and handoff docs

**Files:**
- Create: `integration_test/menu_journey_test.dart`
- Create: `test/accessibility_test.dart`
- Modify: `lib/app/app_shell.dart`
- Modify: `lib/features/add_dish/presentation/add_dish_screen.dart`
- Modify: `lib/features/menu/presentation/menu_screen.dart`
- Modify: `README.md`

**Interfaces:**
- Consumes: the complete application.
- Produces: a verified iPhone build and reproducible setup instructions.

- [ ] **Step 1: Write the end-to-end integration test**

```dart
testWidgets('sample dish flows from capture to live menu', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  await tester.tap(find.text('Try a sample dish'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('dish-name')), 'Sunday Benedict');
  await tester.tap(find.text('Add to menu'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('My Menu'));
  await tester.pumpAndSettle();
  expect(find.text('Sunday Benedict'), findsOneWidget);
  expect(find.text('BREAKFAST'), findsOneWidget);
});
```

- [ ] **Step 2: Add accessibility and layout tests**

Pump both tabs at 320×568, 375×667, 390×844, and 430×932 logical pixels. Repeat the core screens with `textScaler: const TextScaler.linear(2.0)` and assert `tester.takeException()` is null. Use `meetsGuideline(textContrastGuideline)` and semantic labels for camera, library, tab badge, theme selectors, edit, delete, preview, and share.

- [ ] **Step 3: Run tests and fix only concrete failures**

Run:

```bash
dart format --output=none --set-exit-if-changed lib test integration_test
flutter analyze
flutter test
flutter test integration_test/menu_journey_test.dart -d "iPhone 16 Pro"
```

Expected: formatting is unchanged, analyzer has no issues, all unit/widget tests pass, and the integration journey passes on the simulator.

- [ ] **Step 4: Verify the iOS build**

Run: `flutter build ios --simulator --debug`

Expected: `build/ios/iphonesimulator/Runner.app` is produced successfully.

- [ ] **Step 5: Perform manual visual and platform QA**

Launch with `flutter run -d "iPhone 16 Pro"` and verify: empty menu prompts; sample, camera, and library entry points; editable mock result; immediate menu insertion and badge; relaunch persistence; edit/remove confirmation; all themes; reduced-motion behavior; 2× Dynamic Type; PDF preview; native share sheet; and clean A4 pagination. Record any reproducible defect as a failing test before fixing it.

- [ ] **Step 6: Finish README**

Document prerequisites (Flutter 3.44.4, Dart 3.12.2, Xcode 26.6), `flutter pub get`, simulator launch, test commands, the no-network mock behavior, sample-dish path, iOS permission purpose strings, and PDF preview/share instructions.

- [ ] **Step 7: Run final verification**

Run:

```bash
flutter analyze
flutter test
flutter build ios --simulator --debug
git status --short
```

Expected: analyzer and tests succeed, simulator build succeeds, and only intended README or verification edits remain.

- [ ] **Step 8: Commit**

```bash
git add README.md lib test integration_test ios
git commit -m "test: verify complete iPhone menu journey"
```

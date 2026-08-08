import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_wireframe/features/add_dish/domain/photo_picker.dart';
import 'package:hatch_wireframe/features/add_dish/presentation/add_dish_screen.dart';
import 'package:hatch_wireframe/features/add_dish/presentation/dish_feed.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('feed uses generic text and never renders an image', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 8, 8, 12);
    final dishes = List.generate(
      4,
      (index) => Dish(
        id: 'seed-$index',
        imagePath: 'wireframe://seed/$index',
        name: 'Dish name',
        restaurant: 'Restaurant name',
        description: 'Short dish description',
        mealSection: MealSection.values[index % MealSection.values.length],
        createdAt: now.subtract(Duration(minutes: index)),
        updatedAt: now.subtract(Duration(minutes: index)),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: DishFeed(dishes: dishes)),
      ),
    );

    expect(find.byType(Card), findsNWidgets(4));
    expect(find.text('Dish name'), findsNWidgets(4));
    expect(find.text('Restaurant name'), findsNWidgets(4));
    expect(find.byType(Image), findsNothing);
    expect(find.byKey(const Key('wireframe-image-seed-0')), findsOneWidget);
  });

  testWidgets('camera source analyzes and opens generic editable review', (
    tester,
  ) async {
    final key = GlobalKey<AddDishScreenState>();
    final picker = FakePhotoPicker('/tmp/selected.jpg');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddDishScreen(
            key: key,
            analyzer: FakeDishAnalyzer(),
            photoPicker: picker,
            onDishFinalized: (_) async {},
          ),
        ),
      ),
    );

    key.currentState!.choosePhotoSource();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(picker.lastSource, ImageSource.camera);
    expect(find.text('Review your dish'), findsOneWidget);
    expect(find.byKey(const Key('dish-name')), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byKey(const Key('selected-image-placeholder')), findsOneWidget);
  });

  testWidgets('required fields block submission and entered content persists', (
    tester,
  ) async {
    Dish? submitted;
    final key = GlobalKey<AddDishScreenState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddDishScreen(
            key: key,
            analyzer: FakeDishAnalyzer(),
            photoPicker: FakePhotoPicker('/tmp/selected.jpg'),
            onDishFinalized: (dish) async => submitted = dish,
          ),
        ),
      ),
    );

    key.currentState!.choosePhotoSource();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Photo library'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dish-name')), '');
    await tester.enterText(find.byKey(const Key('restaurant-name')), '');
    await tester.ensureVisible(find.byKey(const Key('add-to-menu')));
    await tester.tap(find.byKey(const Key('add-to-menu')));
    await tester.pump();
    expect(find.text('Enter a dish name'), findsOneWidget);
    expect(find.text('Enter a restaurant name'), findsOneWidget);
    expect(submitted, isNull);

    await tester.enterText(find.byKey(const Key('dish-name')), 'Workshop dish');
    await tester.enterText(
      find.byKey(const Key('restaurant-name')),
      'Workshop restaurant',
    );
    await tester.ensureVisible(find.byKey(const Key('add-to-menu')));
    await tester.tap(find.byKey(const Key('add-to-menu')));
    await tester.pumpAndSettle();
    expect(submitted?.name, 'Workshop dish');
    expect(find.text('Added to your menu'), findsOneWidget);
  });

  testWidgets('picker cancellation returns to the populated feed', (
    tester,
  ) async {
    final key = GlobalKey<AddDishScreenState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddDishScreen(
            key: key,
            analyzer: FakeDishAnalyzer(),
            photoPicker: FakePhotoPicker(null),
            capturedDishes: const <Dish>[],
            onDishFinalized: (_) async {},
          ),
        ),
      ),
    );

    key.currentState!.choosePhotoSource();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(find.byType(DishFeed), findsOneWidget);
    expect(find.text('Review your dish'), findsNothing);
  });

  testWidgets('picker permission failure shows a recoverable Material dialog', (
    tester,
  ) async {
    final key = GlobalKey<AddDishScreenState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddDishScreen(
            key: key,
            analyzer: FakeDishAnalyzer(),
            photoPicker: FakePhotoPicker(
              null,
              error: PlatformException(code: 'permission-denied'),
            ),
            onDishFinalized: (_) async {},
          ),
        ),
      ),
    );

    key.currentState!.choosePhotoSource();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Photo library'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Photo access needed'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(DishFeed), findsOneWidget);
  });

  testWidgets('analyzer failure opens an empty manual review state', (
    tester,
  ) async {
    final key = GlobalKey<AddDishScreenState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddDishScreen(
            key: key,
            analyzer: FailingDishAnalyzer(),
            photoPicker: FakePhotoPicker('/tmp/selected.jpg'),
            onDishFinalized: (_) async {},
          ),
        ),
      ),
    );

    key.currentState!.choosePhotoSource();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(
      find.text("We couldn't analyze this photo. Enter the details manually."),
      findsOneWidget,
    );
    expect(find.byKey(const Key('dish-name')), findsOneWidget);
  });
}

class FakePhotoPicker implements PhotoPicker {
  FakePhotoPicker(this.path, {this.error});

  final String? path;
  final PlatformException? error;
  ImageSource? lastSource;

  @override
  Future<String?> pick(ImageSource source) async {
    lastSource = source;
    if (error != null) throw error!;
    return path;
  }
}

class FakeDishAnalyzer implements DishAnalyzer {
  @override
  Future<DishAnalysis> analyze(String imagePath) async => const DishAnalysis(
    name: 'Dish name',
    restaurant: 'Restaurant name',
    description: 'Short dish description',
    mealSection: MealSection.dinner,
  );
}

class FailingDishAnalyzer implements DishAnalyzer {
  @override
  Future<DishAnalysis> analyze(String imagePath) =>
      Future<DishAnalysis>.error(StateError('analysis failed'));
}

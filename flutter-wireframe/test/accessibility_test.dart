import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/app/hatch_app.dart';
import 'package:hatch_wireframe/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_wireframe/features/add_dish/domain/photo_picker.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('navigation, capture action, and placeholders expose semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(await buildTestApp());

    expect(find.bySemanticsLabel('Add a dish photo'), findsOneWidget);
    expect(find.bySemanticsLabel('Dish image placeholder'), findsWidgets);
    expect(find.text('Dishes'), findsOneWidget);
    expect(find.text('My Menu'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('review fields use visible labels and announce validation', (
    tester,
  ) async {
    await tester.pumpWidget(await buildTestApp(photoPath: '/tmp/photo.jpg'));
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Photo library'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dish-name')), '');
    await tester.enterText(find.byKey(const Key('restaurant-name')), '');
    await tester.ensureVisible(find.byKey(const Key('add-to-menu')));
    await tester.tap(find.byKey(const Key('add-to-menu')));
    await tester.pump();

    expect(find.text('Dish name'), findsOneWidget);
    expect(find.text('Restaurant name'), findsOneWidget);
    expect(find.text('Enter a dish name'), findsOneWidget);
    expect(find.text('Enter a restaurant name'), findsOneWidget);
  });

  testWidgets(
    'feed and menu avoid overflow on narrow screens with large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final app = await buildTestApp();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: app,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('My Menu'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

Future<Widget> buildTestApp({String? photoPath}) async {
  final controller = app_menu.MenuController(MemoryRepository());
  await controller.initialize();
  return HatchApp(
    controller: controller,
    analyzer: FakeAnalyzer(),
    photoPicker: FakePicker(photoPath),
  );
}

class MemoryRepository implements MenuRepository {
  MemoryRepository()
    : value = MenuSnapshot(
        dishes: List.generate(4, (index) {
          final createdAt = DateTime.utc(
            2026,
            8,
            8,
            12,
          ).subtract(Duration(minutes: index));
          return Dish(
            id: 'seed-$index',
            imagePath: 'wireframe://seed/$index',
            name: 'Dish name',
            restaurant: 'Restaurant name',
            description: 'Short dish description',
            mealSection: MealSection.values[index % 3],
            createdAt: createdAt,
            updatedAt: createdAt,
          );
        }),
      );

  MenuSnapshot value;

  @override
  Future<MenuSnapshot> load() async => value;

  @override
  Future<void> save(MenuSnapshot snapshot) async => value = snapshot;
}

class FakeAnalyzer implements DishAnalyzer {
  @override
  Future<DishAnalysis> analyze(String imagePath) async => const DishAnalysis(
    name: 'Dish name',
    restaurant: 'Restaurant name',
    description: 'Short dish description',
    mealSection: MealSection.dinner,
  );
}

class FakePicker implements PhotoPicker {
  FakePicker(this.path);

  final String? path;

  @override
  Future<String?> pick(ImageSource source) async => path;
}

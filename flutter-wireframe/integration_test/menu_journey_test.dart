import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hatch_wireframe/app/hatch_app.dart';
import 'package:hatch_wireframe/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_wireframe/features/add_dish/domain/photo_picker.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture journey adds a fifth generic wireframe dish', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      HatchApp(
        controller: controller,
        analyzer: FakeAnalyzer(),
        photoPicker: FakePicker('/tmp/workshop-photo.jpg'),
      ),
    );

    expect(find.byKey(const Key('feed-post-seed-0')), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dish-name')), 'Workshop dish');
    await tester.enterText(
      find.byKey(const Key('restaurant-name')),
      'Workshop restaurant',
    );
    await tester.ensureVisible(find.byKey(const Key('add-to-menu')));
    await tester.tap(find.byKey(const Key('add-to-menu')));
    await tester.pumpAndSettle();
    expect(find.text('Added to your menu'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    await tester.tap(find.text('Add another dish'));
    await tester.pumpAndSettle();
    expect(find.text('Workshop dish'), findsOneWidget);
    await tester.tap(find.text('My Menu'));
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
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

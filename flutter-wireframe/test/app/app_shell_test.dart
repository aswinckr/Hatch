import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/app/app_shell.dart';
import 'package:hatch_wireframe/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_wireframe/features/add_dish/domain/photo_picker.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('shell uses Material navigation, app bar, and capture action', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      MaterialApp(
        home: AppShell(
          controller: controller,
          analyzer: FakeAnalyzer(),
          photoPicker: FakePicker(),
        ),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Your dishes'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.runtimeType.toString() ==
            'Backdrop'
                'Filter',
      ),
      findsNothing,
    );
    expect(find.text('Dishes'), findsOneWidget);
    expect(find.text('My Menu'), findsOneWidget);
  });

  testWidgets('adding a dish marks My Menu until the destination opens', (
    tester,
  ) async {
    final repository = MemoryRepository();
    final controller = app_menu.MenuController(repository);
    await controller.initialize();
    await tester.pumpWidget(
      MaterialApp(
        home: AppShell(
          controller: controller,
          analyzer: FakeAnalyzer(),
          photoPicker: FakePicker('/tmp/photo.jpg'),
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('add-to-menu')));
    await tester.tap(find.byKey(const Key('add-to-menu')));
    await tester.pumpAndSettle();

    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isTrue);
    await tester.tap(find.text('My Menu'));
    await tester.pumpAndSettle();
    expect(tester.widget<Badge>(find.byType(Badge)).isLabelVisible, isFalse);
    expect(find.text('1 / 5'), findsOneWidget);
  });
}

class MemoryRepository implements MenuRepository {
  MemoryRepository()
    : value = MenuSnapshot(
        dishes: List.generate(4, (index) {
          final time = DateTime.utc(
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
            createdAt: time,
            updatedAt: time,
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
  FakePicker([this.path]);

  final String? path;

  @override
  Future<String?> pick(ImageSource source) async => path;
}

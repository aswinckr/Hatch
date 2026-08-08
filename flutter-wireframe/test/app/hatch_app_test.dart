import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  testWidgets('application uses the default Material theme', (tester) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      HatchApp(
        controller: controller,
        analyzer: FakeAnalyzer(),
        photoPicker: FakePicker(),
      ),
    );

    final context = tester.element(find.byType(Scaffold).first);
    final theme = Theme.of(context);
    expect(theme.useMaterial3, isTrue);
    expect(theme.textTheme.bodyMedium?.fontFamily, isNot('Outfit'));
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(CupertinoApp), findsNothing);
  });
}

class MemoryRepository implements MenuRepository {
  MenuSnapshot value = const MenuSnapshot(dishes: []);

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
  @override
  Future<String?> pick(ImageSource source) async => null;
}

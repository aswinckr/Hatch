import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';
import 'package:hatch_menu/features/menu/presentation/menu_screen.dart';

void main() {
  testWidgets('empty menu shows all sections with no style or print controls', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    expect(find.text('BREAKFAST'), findsOneWidget);
    expect(find.text('LUNCH'), findsOneWidget);
    expect(find.text('DINNER'), findsOneWidget);
    expect(find.text('Print menu'), findsNothing);
    expect(find.text('Editorial'), findsNothing);
    expect(find.text('Modern'), findsNothing);
    expect(find.text('Bistro'), findsNothing);
  });

  testWidgets('controller update places dish in its meal section', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    await controller.addDish(breakfastDish);
    await tester.pumpAndSettle();
    expect(find.text('Truffle Eggs'), findsOneWidget);
    expect(find.text('Café Morgenrot'), findsOneWidget);
    expect(
      find.text('Your breakfast favourites will appear here.'),
      findsNothing,
    );
  });
}

final breakfastDish = Dish(
  id: 'one',
  imagePath: 'eggs.jpg',
  name: 'Truffle Eggs',
  restaurant: 'Café Morgenrot',
  description: 'Brioche and hollandaise',
  mealSection: MealSection.breakfast,
  createdAt: DateTime.utc(2026, 8, 7),
  updatedAt: DateTime.utc(2026, 8, 7),
);

class MemoryRepository implements MenuRepository {
  MenuSnapshot value = const MenuSnapshot(
    dishes: [],
    style: MenuStyle.editorial,
  );
  @override
  Future<MenuSnapshot> load() async => value;
  @override
  Future<void> save(MenuSnapshot snapshot) async => value = snapshot;
}

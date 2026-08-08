import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';
import 'package:hatch_menu/features/menu/presentation/menu_screen.dart';

void main() {
  testWidgets('dish can move section', (tester) async {
    final controller = app_menu.MenuController(MemoryRepository(seed));
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('menu-poster')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lunch'));
    await tester.ensureVisible(find.text('Save changes'));
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(controller.dishes.single.mealSection, MealSection.lunch);
  });

  testWidgets('canceling delete confirmation preserves dish', (tester) async {
    final controller = app_menu.MenuController(MemoryRepository(seed));
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('menu-poster')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Delete dish'));
    await tester.tap(find.text('Delete dish'));
    await tester.pumpAndSettle();
    expect(find.text('Remove this dish?'), findsOneWidget);
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(controller.dishes, hasLength(1));
  });
}

final dish = Dish(
  id: 'one',
  imagePath: 'eggs.jpg',
  name: 'Truffle Eggs',
  restaurant: 'Café Morgenrot',
  description: 'Brioche and hollandaise',
  mealSection: MealSection.breakfast,
  createdAt: DateTime.utc(2026, 8, 7),
  updatedAt: DateTime.utc(2026, 8, 7),
);
final seed = MenuSnapshot(dishes: [dish], style: MenuStyle.editorial);

class MemoryRepository implements MenuRepository {
  MemoryRepository(this.value);
  MenuSnapshot value;
  @override
  Future<MenuSnapshot> load() async => value;
  @override
  Future<void> save(MenuSnapshot snapshot) async => value = snapshot;
}

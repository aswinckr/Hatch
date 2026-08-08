import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';
import 'package:hatch_menu/features/menu/presentation/menu_screen.dart';

void main() {
  testWidgets('tapping a menu poster does not open the review sheet', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository(seed));
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    await tester.tap(find.byKey(const Key('menu-poster')));
    await tester.pumpAndSettle();
    expect(find.text('Review your dish'), findsNothing);
  });
}

final dish = Dish(
  id: 'one',
  imagePath: 'assets/demo/truffle_eggs.png',
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

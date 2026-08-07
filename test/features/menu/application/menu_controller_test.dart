import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/menu/application/menu_controller.dart';
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/data/preferences_menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final breakfastDish = Dish(
    id: 'one',
    imagePath: 'eggs.jpg',
    name: 'Truffle Eggs',
    restaurant: 'Morgenrot',
    description: 'Brioche and hollandaise',
    mealSection: MealSection.breakfast,
    createdAt: DateTime.utc(2026, 8, 7),
    updatedAt: DateTime.utc(2026, 8, 7),
  );

  test(
    'mutations update state, categorize dishes, and persist snapshots',
    () async {
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
    },
  );

  test('initialize restores saved dishes and style', () async {
    final repository = MemoryMenuRepository(
      MenuSnapshot(dishes: [breakfastDish], style: MenuStyle.modern),
    );
    final controller = MenuController(repository);
    await controller.initialize();
    expect(controller.dishes, [breakfastDish]);
    expect(controller.style, MenuStyle.modern);
  });

  test(
    'preferences repository saves data and recovers from malformed JSON',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = PreferencesMenuRepository(preferences);
      final snapshot = MenuSnapshot(
        dishes: [breakfastDish],
        style: MenuStyle.modern,
      );
      await repository.save(snapshot);
      expect((await repository.load()).dishes, [breakfastDish]);
      await preferences.setString('hatch.menu.snapshot.v1', '{broken');
      final recovered = await repository.load();
      expect(recovered.dishes, isEmpty);
      expect(recovered.style, MenuStyle.editorial);
    },
  );
}

class MemoryMenuRepository implements MenuRepository {
  MemoryMenuRepository([
    this.snapshot = const MenuSnapshot(dishes: [], style: MenuStyle.editorial),
  ]);
  MenuSnapshot snapshot;
  int saveCount = 0;
  @override
  Future<MenuSnapshot> load() async => snapshot;
  @override
  Future<void> save(MenuSnapshot next) async {
    snapshot = next;
    saveCount++;
  }
}

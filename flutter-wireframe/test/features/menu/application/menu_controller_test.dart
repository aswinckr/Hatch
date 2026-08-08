import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart';
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/data/preferences_menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:hatch_wireframe/features/menu/domain/menu_style.dart';
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
      await controller.removeDish(breakfastDish.id);
      expect(controller.dishes, isEmpty);
      expect(repository.saveCount, 3);
    },
  );

  test('initialize restores saved dishes in the single style', () async {
    final repository = MemoryMenuRepository(
      MenuSnapshot(dishes: [breakfastDish], style: MenuStyle.editorial),
    );
    final controller = MenuController(repository);
    await controller.initialize();
    expect(controller.dishes, [breakfastDish]);
    expect(controller.style, MenuStyle.editorial);
  });

  test(
    'preferences repository saves data and recovers from malformed JSON',
    () async {
      SharedPreferences.setMockInitialValues({
        'hatch.menu.demo-feed-seeded.v1': true,
      });
      final preferences = await SharedPreferences.getInstance();
      final repository = PreferencesMenuRepository(preferences);
      final snapshot = MenuSnapshot(
        dishes: [breakfastDish],
        style: MenuStyle.editorial,
      );
      await repository.save(snapshot);
      expect((await repository.load()).dishes, [breakfastDish]);
      await preferences.setString('hatch.menu.snapshot.v1', '{broken');
      final recovered = await repository.load();
      expect(recovered.dishes, isEmpty);
      expect(recovered.style, MenuStyle.editorial);
    },
  );

  test(
    'preferences repository starts a new install with all demo dishes',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      final snapshot = await PreferencesMenuRepository(preferences).load();

      expect(snapshot.dishes, hasLength(4));
      expect(
        snapshot.dishes.map((dish) => dish.imagePath).toSet(),
        hasLength(4),
      );
    },
  );

  test(
    'preferences repository varies repeated built-in sample dishes',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final repository = PreferencesMenuRepository(preferences);
      final sample = breakfastDish.copyWith(
        imagePath: 'assets/demo/truffle_eggs.png',
      );
      final duplicate = Dish(
        id: 'two',
        imagePath: sample.imagePath,
        name: sample.name,
        restaurant: sample.restaurant,
        description: sample.description,
        mealSection: sample.mealSection,
        createdAt: sample.createdAt,
        updatedAt: sample.updatedAt,
      );
      await repository.save(
        MenuSnapshot(dishes: [sample, duplicate], style: MenuStyle.editorial),
      );

      final restored = await repository.load();

      expect(
        restored.dishes.map((dish) => dish.imagePath).toSet(),
        hasLength(4),
      );
      expect(restored.dishes[1].name, 'Shoyu Ramen');
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

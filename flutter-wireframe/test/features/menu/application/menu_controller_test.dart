import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart';
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/data/preferences_menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('clean storage is seeded with four generic records', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = PreferencesMenuRepository(
      preferences,
      now: () => DateTime.utc(2026, 8, 8, 12),
    );

    final snapshot = await repository.load();

    expect(snapshot.dishes, hasLength(4));
    expect(snapshot.dishes.map((dish) => dish.name).toSet(), {'Dish name'});
    expect(snapshot.dishes.map((dish) => dish.restaurant).toSet(), {
      'Restaurant name',
    });
    expect(snapshot.dishes.map((dish) => dish.description).toSet(), {
      'Short dish description',
    });
    expect(
      snapshot.dishes.every(
        (dish) => dish.imagePath.startsWith('wireframe://seed/'),
      ),
      isTrue,
    );
  });

  test('malformed storage recovers to the four generic records', () async {
    SharedPreferences.setMockInitialValues({
      'hatch.wireframe.menu.snapshot.v1': '{broken',
    });
    final preferences = await SharedPreferences.getInstance();

    final snapshot = await PreferencesMenuRepository(preferences).load();

    expect(snapshot.dishes, hasLength(4));
    expect(snapshot.dishes.every((dish) => dish.name == 'Dish name'), isTrue);
  });

  test('controller persists user additions and groups meal sections', () async {
    final repository = MemoryMenuRepository();
    final controller = MenuController(repository);
    await controller.initialize();
    final dish = Dish(
      id: 'user-1',
      imagePath: '/tmp/photo.jpg',
      name: 'Workshop entry',
      restaurant: 'Workshop venue',
      description: 'Entered during the exercise',
      mealSection: MealSection.lunch,
      createdAt: DateTime.utc(2026, 8, 8),
      updatedAt: DateTime.utc(2026, 8, 8),
    );

    await controller.addDish(dish);

    expect(controller.dishesFor(MealSection.lunch), [dish]);
    expect(repository.value.dishes, [dish]);
  });
}

class MemoryMenuRepository implements MenuRepository {
  MemoryMenuRepository([this.value = const MenuSnapshot(dishes: <Dish>[])]);

  MenuSnapshot value;

  @override
  Future<MenuSnapshot> load() async => value;

  @override
  Future<void> save(MenuSnapshot snapshot) async => value = snapshot;
}

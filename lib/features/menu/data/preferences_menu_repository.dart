import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/dish.dart';
import '../domain/menu_style.dart';
import 'menu_repository.dart';

class PreferencesMenuRepository implements MenuRepository {
  PreferencesMenuRepository(this._preferences);
  static const _key = 'hatch.menu.snapshot.v1';
  final SharedPreferences _preferences;

  @override
  Future<MenuSnapshot> load() async {
    try {
      final source = _preferences.getString(_key);
      if (source == null) return _empty;
      final json = jsonDecode(source) as Map<String, Object?>;
      final dishes = (json['dishes']! as List<Object?>)
          .map((item) => Dish.fromJson((item! as Map).cast<String, Object?>()))
          .toList(growable: false);
      final variedDishes = _varyRepeatedDemoDishes(dishes);
      final snapshot = MenuSnapshot(
        dishes: variedDishes,
        style: MenuStyle.editorial,
      );
      if (!_sameDishes(dishes, variedDishes)) await save(snapshot);
      return snapshot;
    } catch (_) {
      return _empty;
    }
  }

  static const _empty = MenuSnapshot(dishes: [], style: MenuStyle.editorial);

  @override
  Future<void> save(MenuSnapshot snapshot) async {
    await _preferences.setString(
      _key,
      jsonEncode({
        'version': 1,
        'dishes': snapshot.dishes.map((dish) => dish.toJson()).toList(),
        'style': snapshot.style.name,
      }),
    );
  }

  List<Dish> _varyRepeatedDemoDishes(List<Dish> dishes) {
    final usedPaths = <String>{};
    return dishes
        .map((dish) {
          if (!_demoDishes.any(
                (sample) => sample.imagePath == dish.imagePath,
              ) ||
              usedPaths.add(dish.imagePath)) {
            return dish;
          }
          final alternative = _demoDishes
              .where((sample) => !usedPaths.contains(sample.imagePath))
              .firstOrNull;
          if (alternative == null) return dish;
          usedPaths.add(alternative.imagePath);
          return dish.copyWith(
            imagePath: alternative.imagePath,
            name: alternative.name,
            restaurant: alternative.restaurant,
            description: alternative.description,
            mealSection: alternative.mealSection,
          );
        })
        .toList(growable: false);
  }

  bool _sameDishes(List<Dish> first, List<Dish> second) =>
      first.length == second.length &&
      Iterable.generate(
        first.length,
      ).every((index) => first[index] == second[index]);
}

class _DemoDish {
  const _DemoDish({
    required this.imagePath,
    required this.name,
    required this.restaurant,
    required this.description,
    required this.mealSection,
  });

  final String imagePath, name, restaurant, description;
  final MealSection mealSection;
}

const _demoDishes = [
  _DemoDish(
    imagePath: 'assets/demo/truffle_eggs.png',
    name: 'Truffle Eggs Benedict',
    restaurant: 'Café Morgenrot',
    description: 'Poached eggs, toasted brioche and truffle hollandaise',
    mealSection: MealSection.breakfast,
  ),
  _DemoDish(
    imagePath: 'assets/demo/miso_cod.png',
    name: 'Shoyu Ramen',
    restaurant: 'Menya Kōji',
    description: 'Soy broth, chashu pork, soft egg, scallions and nori',
    mealSection: MealSection.lunch,
  ),
  _DemoDish(
    imagePath: 'assets/demo/tiramisu.png',
    name: 'Pistachio Tiramisu',
    restaurant: 'Luna',
    description: 'Espresso-soaked sponge, mascarpone and pistachio',
    mealSection: MealSection.dinner,
  ),
  _DemoDish(
    imagePath: 'assets/demo/mushroom_pasta.png',
    name: 'Wild Mushroom Tagliatelle',
    restaurant: 'Osteria Bruno',
    description: 'Handmade pasta, roasted mushrooms and parmesan',
    mealSection: MealSection.dinner,
  ),
];

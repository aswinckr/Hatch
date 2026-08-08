import 'package:flutter/foundation.dart';
import '../data/menu_repository.dart';
import '../domain/dish.dart';

class MenuController extends ChangeNotifier {
  MenuController(this._repository);
  final MenuRepository _repository;
  final List<Dish> _dishes = [];

  List<Dish> get dishes => List.unmodifiable(_dishes);
  MenuSnapshot get snapshot => MenuSnapshot(dishes: dishes);

  List<Dish> dishesFor(MealSection section) =>
      _dishes
          .where((dish) => dish.mealSection == section)
          .toList(growable: false)
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Future<void> initialize() async {
    final loaded = await _repository.load();
    _dishes
      ..clear()
      ..addAll(loaded.dishes);
    notifyListeners();
  }

  Future<void> addDish(Dish dish) async {
    _dishes.add(dish);
    await _persist();
  }

  Future<void> updateDish(Dish dish) async {
    final index = _dishes.indexWhere((current) => current.id == dish.id);
    if (index < 0) return;
    _dishes[index] = dish;
    await _persist();
  }

  Future<void> removeDish(String id) async {
    _dishes.removeWhere((dish) => dish.id == id);
    await _persist();
  }

  Future<void> _persist() async {
    await _repository.save(snapshot);
    notifyListeners();
  }
}

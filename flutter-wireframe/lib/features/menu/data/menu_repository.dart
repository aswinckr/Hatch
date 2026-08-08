import '../domain/dish.dart';

class MenuSnapshot {
  const MenuSnapshot({required this.dishes});

  final List<Dish> dishes;
}

abstract interface class MenuRepository {
  Future<MenuSnapshot> load();
  Future<void> save(MenuSnapshot snapshot);
}

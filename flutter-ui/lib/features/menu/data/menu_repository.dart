import '../domain/dish.dart';
import '../domain/menu_style.dart';

class MenuSnapshot {
  const MenuSnapshot({required this.dishes, required this.style});
  final List<Dish> dishes;
  final MenuStyle style;
}

abstract interface class MenuRepository {
  Future<MenuSnapshot> load();
  Future<void> save(MenuSnapshot snapshot);
}

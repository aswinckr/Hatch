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
      return MenuSnapshot(dishes: dishes, style: MenuStyle.editorial);
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
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/dish.dart';
import 'menu_repository.dart';
import 'wireframe_seed.dart';

class PreferencesMenuRepository implements MenuRepository {
  PreferencesMenuRepository(this._preferences, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const storageKey = 'hatch.wireframe.menu.snapshot.v1';

  final SharedPreferences _preferences;
  final DateTime Function() _now;

  @override
  Future<MenuSnapshot> load() async {
    final source = _preferences.getString(storageKey);
    if (source == null) return _seedAndSave();
    try {
      final decoded = jsonDecode(source) as Map<String, Object?>;
      final dishes = (decoded['dishes']! as List<Object?>)
          .map((item) => Dish.fromJson((item! as Map).cast<String, Object?>()))
          .toList(growable: false);
      return MenuSnapshot(dishes: dishes);
    } catch (_) {
      return _seedAndSave();
    }
  }

  Future<MenuSnapshot> _seedAndSave() async {
    final snapshot = MenuSnapshot(dishes: buildWireframeSeed(_now()));
    await save(snapshot);
    return snapshot;
  }

  @override
  Future<void> save(MenuSnapshot snapshot) async {
    await _preferences.setString(
      storageKey,
      jsonEncode({
        'version': 1,
        'dishes': snapshot.dishes.map((dish) => dish.toJson()).toList(),
      }),
    );
  }
}

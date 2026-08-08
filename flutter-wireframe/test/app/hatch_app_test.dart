import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/app/hatch_app.dart';
import 'package:hatch_wireframe/features/add_dish/data/mock_dish_analyzer.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/menu_style.dart';

void main() {
  testWidgets('editorial interface stays light when system prefers dark mode', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      HatchApp(
        controller: controller,
        analyzer: MockDishAnalyzer(delay: Duration.zero),
      ),
    );
    final context = tester.element(find.text('Your dishes'));
    expect(CupertinoTheme.of(context).brightness, Brightness.light);
  });
}

class MemoryRepository implements MenuRepository {
  MenuSnapshot value = const MenuSnapshot(
    dishes: [],
    style: MenuStyle.editorial,
  );
  @override
  Future<MenuSnapshot> load() async => value;
  @override
  Future<void> save(MenuSnapshot snapshot) async => value = snapshot;
}

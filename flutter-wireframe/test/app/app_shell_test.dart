import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/app/app_shell.dart';
import 'package:hatch_wireframe/features/add_dish/data/mock_dish_analyzer.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:hatch_wireframe/features/menu/domain/menu_style.dart';

void main() {
  testWidgets('app shell keeps one white surface behind floating navigation', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(
        home: AppShell(
          controller: controller,
          analyzer: MockDishAnalyzer(delay: Duration.zero),
        ),
      ),
    );

    final background = tester.widget<ColoredBox>(
      find.byKey(const Key('app-background')),
    );
    expect(background.color, CupertinoColors.white);

    final navRect = tester.getRect(find.byKey(const Key('floating-tab-bar')));
    final cameraRect = tester.getRect(
      find.byKey(const Key('floating-camera-button')),
    );
    expect(cameraRect.right, tester.getSize(find.byType(AppShell)).width - 20);
    expect(navRect.top - cameraRect.bottom, 48);
  });

  testWidgets('menu tab renders the persistent menu poster', (tester) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await controller.addDish(
      Dish(
        id: 'eggs',
        imagePath: 'assets/demo/truffle_eggs.png',
        name: 'Truffle Eggs Benedict',
        restaurant: 'Café Morgenrot',
        description: 'Poached eggs and truffle hollandaise',
        mealSection: MealSection.breakfast,
        createdAt: DateTime.utc(2026, 8, 7),
        updatedAt: DateTime.utc(2026, 8, 7),
      ),
    );
    await tester.pumpWidget(
      CupertinoApp(
        home: AppShell(
          controller: controller,
          analyzer: MockDishAnalyzer(delay: Duration.zero),
        ),
      ),
    );
    await tester.tap(find.text('My Menu'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-poster')), findsOneWidget);
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

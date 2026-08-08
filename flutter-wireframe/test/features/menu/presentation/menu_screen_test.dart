import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/core/design/app_colors.dart';
import 'package:hatch_wireframe/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';
import 'package:hatch_wireframe/features/menu/domain/menu_style.dart';
import 'package:hatch_wireframe/features/menu/presentation/menu_page.dart';
import 'package:hatch_wireframe/features/menu/presentation/menu_screen.dart';

void main() {
  testWidgets('empty menu shows all sections with no style or print controls', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    expect(find.text('BREAKFAST'), findsOneWidget);
    expect(find.text('LUNCH'), findsOneWidget);
    expect(find.text('DINNER'), findsOneWidget);
    expect(find.text('Print menu'), findsNothing);
    expect(find.text('Editorial'), findsNothing);
    expect(find.text('Modern'), findsNothing);
    expect(find.text('Bistro'), findsNothing);
    expect(find.byType(CupertinoNavigationBar), findsNothing);
    final page = tester.widget<CupertinoPageScaffold>(
      find.byType(CupertinoPageScaffold),
    );
    expect(page.backgroundColor, AppColors.cream);
    expect(
      tester.getSize(find.byType(MenuPage)).width,
      tester.getSize(find.byType(MenuScreen)).width,
    );
  });

  testWidgets('controller update places dish in its meal section', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );
    await controller.addDish(breakfastDish);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-poster')), findsOneWidget);
    expect(
      find.text('Your breakfast favourites will appear here.'),
      findsNothing,
    );
  });

  testWidgets('menu pages through a poster for every saved dish', (
    tester,
  ) async {
    final controller = app_menu.MenuController(
      MemoryRepository()
        ..value = MenuSnapshot(
          dishes: [
            breakfastDish.copyWith(imagePath: 'assets/demo/truffle_eggs.png'),
            breakfastDish.copyWith(imagePath: 'assets/demo/miso_cod.png'),
          ],
          style: MenuStyle.editorial,
        ),
    );
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(home: MenuScreen(controller: controller)),
    );

    expect(find.byKey(const Key('menu-poster')), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('menu-poster')),
      const Offset(-1000, 0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('menu-poster-1')), findsOneWidget);
  });
}

final breakfastDish = Dish(
  id: 'one',
  imagePath: 'assets/demo/truffle_eggs.png',
  name: 'Truffle Eggs',
  restaurant: 'Café Morgenrot',
  description: 'Brioche and hollandaise',
  mealSection: MealSection.breakfast,
  createdAt: DateTime.utc(2026, 8, 7),
  updatedAt: DateTime.utc(2026, 8, 7),
);

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

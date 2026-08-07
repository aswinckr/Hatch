import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/app/app_shell.dart';
import 'package:hatch_menu/features/add_dish/data/mock_dish_analyzer.dart';
import 'package:hatch_menu/features/menu/application/menu_controller.dart'
    as app_menu;
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';

void main() {
  testWidgets('finalized dish appears on persistent My Menu tab', (
    tester,
  ) async {
    final controller = app_menu.MenuController(MemoryRepository());
    await controller.initialize();
    await tester.pumpWidget(
      CupertinoApp(
        home: AppShell(
          controller: controller,
          analyzer: MockDishAnalyzer(delay: Duration.zero),
          onExport: (_) async {},
        ),
      ),
    );
    await tester.tap(find.text('Try a sample dish'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to menu'));
    await tester.tap(find.text('Add to menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Menu'));
    await tester.pumpAndSettle();
    expect(find.text('Truffle Eggs Benedict'), findsOneWidget);
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

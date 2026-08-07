import 'package:flutter/cupertino.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/add_dish/presentation/add_dish_screen.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import '../features/menu/data/menu_repository.dart';
import '../features/menu/domain/dish.dart';
import '../features/menu/presentation/menu_screen.dart';
import 'floating_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.controller,
    required this.analyzer,
    required this.onExport,
  });
  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  final Future<void> Function(MenuSnapshot snapshot) onExport;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  bool hasNewDish = false;

  Future<void> _addDish(Dish dish) async {
    await widget.controller.addDish(dish);
    if (mounted) setState(() => hasNewDish = true);
  }

  void _select(int index) => setState(() {
    selectedIndex = index;
    if (index == 1) hasNewDish = false;
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    key: const Key('app-background'),
    color: CupertinoColors.white,
    child: Stack(
      children: [
        IndexedStack(
          index: selectedIndex,
          children: [
            AddDishScreen(
              analyzer: widget.analyzer,
              onDishFinalized: _addDish,
              capturedDishes: widget.controller.dishes,
            ),
            MenuScreen(
              controller: widget.controller,
              onExport: widget.onExport,
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: 12),
            child: Center(
              child: FloatingTabBar(
                selectedIndex: selectedIndex,
                hasNewMenuItem: hasNewDish,
                onSelected: _select,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/cupertino.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/add_dish/presentation/add_dish_screen.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import '../features/menu/data/menu_repository.dart';
import '../features/menu/domain/dish.dart';
import '../features/menu/presentation/menu_screen.dart';

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
  final tabController = CupertinoTabController();
  bool hasNewDish = false;
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> _addDish(Dish dish) async {
    await widget.controller.addDish(dish);
    if (mounted) setState(() => hasNewDish = true);
  }

  @override
  Widget build(BuildContext context) => CupertinoTabScaffold(
    controller: tabController,
    tabBar: CupertinoTabBar(
      onTap: (index) {
        if (index == 1) setState(() => hasNewDish = false);
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.camera),
          label: 'Add Dish',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(CupertinoIcons.doc_text),
              if (hasNewDish)
                Positioned(
                  right: -5,
                  top: -3,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          label: 'My Menu',
        ),
      ],
    ),
    tabBuilder: (context, index) => CupertinoTabView(
      builder: (_) => index == 0
          ? AddDishScreen(analyzer: widget.analyzer, onDishFinalized: _addDish)
          : MenuScreen(
              controller: widget.controller,
              onExport: widget.onExport,
            ),
    ),
  );
}

import 'package:flutter/cupertino.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/add_dish/presentation/add_dish_screen.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import '../features/menu/domain/dish.dart';
import '../features/menu/presentation/menu_screen.dart';
import 'floating_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller, required this.analyzer});
  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final addDishKey = GlobalKey<AddDishScreenState>();
  int selectedIndex = 0;
  bool hasNewDish = false;
  bool showCaptureAction = true;

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
      fit: StackFit.expand,
      children: [
        IndexedStack(
          index: selectedIndex,
          children: [
            AddDishScreen(
              key: addDishKey,
              analyzer: widget.analyzer,
              onDishFinalized: _addDish,
              capturedDishes: widget.controller.dishes,
              showEmbeddedCameraAction: false,
              onHomeStageChanged: (visible) {
                if (mounted && showCaptureAction != visible) {
                  setState(() => showCaptureAction = visible);
                }
              },
            ),
            MenuScreen(controller: widget.controller),
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
                key: const Key('floating-tab-bar'),
                selectedIndex: selectedIndex,
                hasNewMenuItem: hasNewDish,
                onSelected: _select,
              ),
            ),
          ),
        ),
        if (selectedIndex == 0 && showCaptureAction)
          Positioned(
            right: 20,
            bottom: MediaQuery.paddingOf(context).bottom + 132,
            child: FloatingCameraButton(
              onPressed: () => addDishKey.currentState?.takePhoto(),
            ),
          ),
      ],
    ),
  );
}

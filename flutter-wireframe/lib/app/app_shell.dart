import 'package:flutter/material.dart';

import '../features/add_dish/data/image_picker_photo_picker.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/add_dish/domain/photo_picker.dart';
import '../features/add_dish/presentation/add_dish_screen.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import '../features/menu/domain/dish.dart';
import '../features/menu/presentation/menu_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.controller,
    required this.analyzer,
    this.photoPicker,
  });

  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  final PhotoPicker? photoPicker;

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
  Widget build(BuildContext context) => Scaffold(
    appBar: selectedIndex == 0
        ? AppBar(title: const Text('Your dishes'))
        : null,
    body: IndexedStack(
      index: selectedIndex,
      children: [
        AddDishScreen(
          key: addDishKey,
          analyzer: widget.analyzer,
          photoPicker: widget.photoPicker ?? ImagePickerPhotoPicker(),
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
    floatingActionButton: selectedIndex == 0 && showCaptureAction
        ? FloatingActionButton(
            key: const Key('capture-dish'),
            tooltip: 'Add a dish photo',
            onPressed: () => addDishKey.currentState?.choosePhotoSource(),
            child: const Icon(Icons.add_a_photo_outlined),
          )
        : null,
    bottomNavigationBar: NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: _select,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.ramen_dining_outlined),
          selectedIcon: Icon(Icons.ramen_dining),
          label: 'Dishes',
        ),
        NavigationDestination(
          icon: Badge(
            isLabelVisible: hasNewDish,
            child: const Icon(Icons.description_outlined),
          ),
          label: 'My Menu',
        ),
      ],
    ),
  );
}

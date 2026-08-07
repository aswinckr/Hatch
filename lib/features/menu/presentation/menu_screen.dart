import 'package:flutter/cupertino.dart';
import '../application/menu_controller.dart' as app_menu;
import '../domain/dish.dart';
import 'dish_editor_sheet.dart';
import 'menu_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.controller});
  final app_menu.MenuController controller;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: const CupertinoNavigationBar(middle: Text('My Menu')),
    child: SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 112),
          child: MenuPage(
            snapshot: controller.snapshot,
            onDishTap: (dish) => _edit(context, dish),
          ),
        ),
      ),
    ),
  );

  Future<void> _edit(BuildContext context, Dish dish) =>
      showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => DishEditorSheet(
          dish: dish,
          onSave: controller.updateDish,
          onDelete: () => controller.removeDish(dish.id),
        ),
      );
}

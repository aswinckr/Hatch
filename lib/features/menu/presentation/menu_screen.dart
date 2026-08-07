import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../application/menu_controller.dart' as app_menu;
import '../domain/dish.dart';
import 'dish_editor_sheet.dart';
import 'menu_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.controller});
  final app_menu.MenuController controller;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    backgroundColor: AppColors.cream,
    child: ColoredBox(
      color: AppColors.cream,
      child: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: MenuPage(
                  snapshot: controller.snapshot,
                  bottomPadding: 140,
                  onDishTap: (dish) => _edit(context, dish),
                ),
              ),
            ),
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

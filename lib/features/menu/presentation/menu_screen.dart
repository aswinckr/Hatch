import 'package:flutter/cupertino.dart';
import '../../../core/design/app_shapes.dart';
import '../application/menu_controller.dart' as app_menu;
import '../data/menu_repository.dart';
import '../domain/dish.dart';
import '../domain/menu_style.dart';
import 'dish_editor_sheet.dart';
import 'menu_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.controller,
    required this.onExport,
  });
  final app_menu.MenuController controller;
  final Future<void> Function(MenuSnapshot snapshot) onExport;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: const CupertinoNavigationBar(middle: Text('My Menu')),
    child: SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => Column(
          children: [
            _StylePicker(
              style: controller.style,
              onChanged: controller.setStyle,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: MenuPage(
                  snapshot: controller.snapshot,
                  onDishTap: (dish) => _edit(context, dish),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 102),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: AppShapes.pill,
                  onPressed: controller.dishes.isEmpty
                      ? null
                      : () => onExport(controller.snapshot),
                  child: const Text('Print menu'),
                ),
              ),
            ),
          ],
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

class _StylePicker extends StatelessWidget {
  const _StylePicker({required this.style, required this.onChanged});
  final MenuStyle style;
  final ValueChanged<MenuStyle> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    color: CupertinoColors.systemBackground,
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
    child: Row(
      children: [
        for (final value in MenuStyle.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: CupertinoButton(
                borderRadius: AppShapes.pill,
                key: Key('theme-${value.name}'),
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: value == style
                    ? CupertinoColors.activeOrange
                    : CupertinoColors.systemGrey5,
                onPressed: () => onChanged(value),
                child: Text(
                  _label(value),
                  style: TextStyle(
                    fontSize: 12,
                    color: value == style
                        ? CupertinoColors.white
                        : CupertinoColors.label,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
  String _label(MenuStyle style) => switch (style) {
    MenuStyle.editorial => 'Editorial',
    MenuStyle.modern => 'Modern',
    MenuStyle.bistro => 'Bistro',
  };
}

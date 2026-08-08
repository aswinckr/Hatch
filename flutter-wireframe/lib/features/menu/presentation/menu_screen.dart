import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../application/menu_controller.dart' as app_menu;
import 'menu_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.controller});
  final app_menu.MenuController controller;

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    backgroundColor: AppColors.cream,
    child: ColoredBox(
      color: AppColors.cream,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) =>
            MenuPage(snapshot: controller.snapshot, bottomPadding: 140),
      ),
    ),
  );
}

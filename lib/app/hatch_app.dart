import 'package:flutter/cupertino.dart';
import '../core/design/app_colors.dart';
import '../core/design/app_typography.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import 'app_shell.dart';

class HatchApp extends StatelessWidget {
  const HatchApp({super.key, required this.controller, required this.analyzer});
  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  @override
  Widget build(BuildContext context) => CupertinoApp(
    title: 'Favourite Menu',
    debugShowCheckedModeBanner: false,
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.forestGreen,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: AppTypography.cupertino,
    ),
    home: AppShell(controller: controller, analyzer: analyzer),
  );
}

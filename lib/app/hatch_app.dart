import 'package:flutter/cupertino.dart';
import '../core/design/app_colors.dart';
import '../core/design/app_typography.dart';
import '../features/add_dish/domain/dish_analysis.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import '../features/menu/data/menu_repository.dart';
import 'app_shell.dart';

class HatchApp extends StatelessWidget {
  const HatchApp({
    super.key,
    required this.controller,
    required this.analyzer,
    required this.onExport,
  });
  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  final Future<void> Function(MenuSnapshot snapshot) onExport;
  @override
  Widget build(BuildContext context) => CupertinoApp(
    title: 'Favourite Menu',
    debugShowCheckedModeBanner: false,
    theme: const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.terracotta,
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: CupertinoTextThemeData(textStyle: AppTypography.body),
    ),
    home: AppShell(
      controller: controller,
      analyzer: analyzer,
      onExport: onExport,
    ),
  );
}

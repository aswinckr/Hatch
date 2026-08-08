import 'package:flutter/material.dart';

import '../features/add_dish/domain/dish_analysis.dart';
import '../features/add_dish/domain/photo_picker.dart';
import '../features/menu/application/menu_controller.dart' as app_menu;
import 'app_scroll_behavior.dart';
import 'app_shell.dart';

class HatchApp extends StatelessWidget {
  const HatchApp({
    super.key,
    required this.controller,
    required this.analyzer,
    this.photoPicker,
  });

  final app_menu.MenuController controller;
  final DishAnalyzer analyzer;
  final PhotoPicker? photoPicker;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Favourite Menu Wireframe',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    scrollBehavior: const AppScrollBehavior(),
    home: AppShell(
      controller: controller,
      analyzer: analyzer,
      photoPicker: photoPicker,
    ),
  );
}

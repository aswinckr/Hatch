import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/hatch_app.dart';
import 'features/add_dish/data/mock_dish_analyzer.dart';
import 'features/menu/application/menu_controller.dart' as app_menu;
import 'features/menu/data/preferences_menu_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final preferences = await SharedPreferences.getInstance();
  final controller = app_menu.MenuController(
    PreferencesMenuRepository(preferences),
  );
  await controller.initialize();
  runApp(HatchApp(controller: controller, analyzer: MockDishAnalyzer()));
}

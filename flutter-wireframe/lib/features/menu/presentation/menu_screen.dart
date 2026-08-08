import 'package:flutter/material.dart';

import '../application/menu_controller.dart';
import 'menu_page.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.controller});

  final MenuController controller;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => MenuPage(snapshot: controller.snapshot),
  );
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../data/menu_repository.dart';
import '../domain/dish.dart';

class MenuVisualTheme {
  const MenuVisualTheme({
    required this.paper,
    required this.ink,
    required this.accent,
  });
  final Color paper, ink, accent;
  static const standard = MenuVisualTheme(
    paper: AppColors.cream,
    ink: AppColors.espresso,
    accent: AppColors.forestGreen,
  );
}

class MenuPage extends StatelessWidget {
  const MenuPage({
    super.key,
    required this.snapshot,
    this.showEmptySections = true,
    this.bottomPadding = 48,
    this.onDishTap,
  });
  final MenuSnapshot snapshot;
  final bool showEmptySections;
  final double bottomPadding;
  final ValueChanged<Dish>? onDishTap;

  @override
  Widget build(BuildContext context) {
    const visual = MenuVisualTheme.standard;
    if (snapshot.dishes.isEmpty) {
      return _EmptyMenu(
        showEmptySections: showEmptySections,
        bottomPadding: bottomPadding,
        visual: visual,
      );
    }
    return Container(
      width: double.infinity,
      color: visual.paper,
      child: PageView.builder(
        itemCount: snapshot.dishes.length,
        itemBuilder: (context, index) => _MenuPosterPage(
          key: index == 0
              ? const Key('menu-poster')
              : Key('menu-poster-$index'),
          dish: snapshot.dishes[index],
          onTap: onDishTap,
        ),
      ),
    );
  }
}

class _MenuPosterPage extends StatelessWidget {
  const _MenuPosterPage({super.key, required this.dish, this.onTap});
  final Dish dish;
  final ValueChanged<Dish>? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: 'Menu poster featuring ${dish.name}',
    child: GestureDetector(
      onTap: () => onTap?.call(dish),
      child: _MenuPosterImage(dish: dish),
    ),
  );
}

class _MenuPosterImage extends StatelessWidget {
  const _MenuPosterImage({required this.dish});
  final Dish dish;

  @override
  Widget build(BuildContext context) {
    final posterPath = switch (dish.imagePath) {
      final path when path.contains('truffle_eggs') =>
        'assets/menu/truffle_eggs_menu_poster.png',
      final path when path.contains('miso_cod') =>
        'assets/menu/shoyu_ramen_menu_poster.png',
      final path when path.contains('tiramisu') =>
        'assets/menu/pistachio_tiramisu_menu_poster.png',
      final path when path.contains('mushroom_pasta') =>
        'assets/menu/mushroom_tagliatelle_menu_poster.png',
      _ => null,
    };
    return SizedBox.expand(
      child: posterPath != null
          ? Image.asset(posterPath, fit: BoxFit.cover)
          : dish.imagePath.startsWith('assets/')
          ? Image.asset(dish.imagePath, fit: BoxFit.cover)
          : Image.file(File(dish.imagePath), fit: BoxFit.cover),
    );
  }
}

class _EmptyMenu extends StatelessWidget {
  const _EmptyMenu({
    required this.showEmptySections,
    required this.bottomPadding,
    required this.visual,
  });
  final bool showEmptySections;
  final double bottomPadding;
  final MenuVisualTheme visual;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Container(
      width: double.infinity,
      color: visual.paper,
      padding: EdgeInsets.fromLTRB(24, 30, 24, bottomPadding),
      child: Column(
        children: [
          Text(
            'FAVOURITE PLACES',
            style: TextStyle(
              fontFamily: 'Outfit',
              letterSpacing: 3,
              fontSize: 12,
              color: visual.accent,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'The Menu',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: visual.ink,
            ),
          ),
          const SizedBox(height: 34),
          if (showEmptySections)
            for (final section in MealSection.values) ...[
              Text(
                section.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.4,
                  color: visual.accent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your ${section.label.toLowerCase()} favourites will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: visual.ink.withValues(alpha: .52),
                ),
              ),
              const SizedBox(height: 28),
            ],
        ],
      ),
    ),
  );
}

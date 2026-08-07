import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../data/menu_repository.dart';
import '../domain/dish.dart';
import '../domain/menu_style.dart';

class MenuVisualTheme {
  const MenuVisualTheme({
    required this.paper,
    required this.ink,
    required this.accent,
  });
  final Color paper, ink, accent;
  static MenuVisualTheme forStyle(MenuStyle style) => switch (style) {
    MenuStyle.editorial => const MenuVisualTheme(
      paper: AppColors.cream,
      ink: AppColors.espresso,
      accent: AppColors.terracotta,
    ),
    MenuStyle.modern => const MenuVisualTheme(
      paper: Color(0xFFF7F7F4),
      ink: Color(0xFF171717),
      accent: Color(0xFF2855D9),
    ),
    MenuStyle.bistro => const MenuVisualTheme(
      paper: Color(0xFFF3E7D0),
      ink: Color(0xFF3E191D),
      accent: Color(0xFF1F5547),
    ),
  };
}

class MenuPage extends StatelessWidget {
  const MenuPage({
    super.key,
    required this.snapshot,
    this.showEmptySections = true,
    this.onDishTap,
  });
  final MenuSnapshot snapshot;
  final bool showEmptySections;
  final ValueChanged<Dish>? onDishTap;

  @override
  Widget build(BuildContext context) {
    final visual = MenuVisualTheme.forStyle(snapshot.style);
    return Container(
      color: visual.paper,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 48),
      child: Column(
        children: [
          Text(
            'FAVOURITE PLACES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'NotoSerif',
              letterSpacing: 3,
              fontSize: 12,
              color: visual.accent,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'The Menu',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 36,
              fontStyle: FontStyle.italic,
              color: visual.ink,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 44,
            height: 1,
            color: visual.accent,
          ),
          for (final section in MealSection.values)
            if (showEmptySections || _dishesFor(section).isNotEmpty)
              _Section(
                section: section,
                dishes: _dishesFor(section),
                visual: visual,
                onDishTap: onDishTap,
              ),
        ],
      ),
    );
  }

  List<Dish> _dishesFor(MealSection section) {
    final dishes = snapshot.dishes
        .where((dish) => dish.mealSection == section)
        .toList();
    dishes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return dishes;
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.section,
    required this.dishes,
    required this.visual,
    this.onDishTap,
  });
  final MealSection section;
  final List<Dish> dishes;
  final MenuVisualTheme visual;
  final ValueChanged<Dish>? onDishTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 26),
    child: Column(
      children: [
        Text(
          section.label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.4,
            color: visual.accent,
          ),
        ),
        const SizedBox(height: 12),
        if (dishes.isEmpty)
          Text(
            'Your ${section.label.toLowerCase()} favourites will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: visual.ink.withValues(alpha: .52),
            ),
          )
        else
          for (final dish in dishes)
            GestureDetector(
              onTap: () => onDishTap?.call(dish),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Text(
                      dish.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: visual.ink,
                      ),
                    ),
                    if (dish.description.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          dish.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.35,
                            color: visual.ink,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        dish.restaurant,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: visual.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ],
    ),
  );
}

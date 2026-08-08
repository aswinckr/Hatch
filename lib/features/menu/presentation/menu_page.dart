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
    final firstDish = snapshot.dishes.first;
    return Container(
      width: double.infinity,
      color: visual.paper,
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Semantics(
        button: onDishTap != null,
        label: 'Menu poster featuring ${firstDish.name}',
        child: GestureDetector(
          onTap: () => onDishTap?.call(firstDish),
          child: Image.asset(
            'assets/menu/truffle_eggs_menu_poster.png',
            key: const Key('menu-poster'),
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
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
  Widget build(BuildContext context) => Container(
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
  );
}

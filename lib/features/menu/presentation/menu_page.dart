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
    return Container(
      width: double.infinity,
      color: visual.paper,
      padding: EdgeInsets.fromLTRB(20, 28, 20, bottomPadding),
      child: Column(
        children: [
          Text(
            'FAVOURITE PLACES',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
              fontSize: 11,
              color: visual.accent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Menu',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: visual.ink,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'The dishes worth returning for.',
            style: TextStyle(
              fontSize: 15,
              color: visual.ink.withValues(alpha: .68),
            ),
          ),
          const SizedBox(height: 28),
          for (final section in MealSection.values)
            if (showEmptySections || _dishesFor(section).isNotEmpty)
              _MenuSection(
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

class _MenuSection extends StatelessWidget {
  const _MenuSection({
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
    padding: const EdgeInsets.only(bottom: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 28, height: 2, color: visual.accent),
            const SizedBox(width: 10),
            Text(
              section.label.toUpperCase(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.2,
                color: visual.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (dishes.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Your ${section.label.toLowerCase()} favourites will appear here.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: visual.ink.withValues(alpha: .52),
              ),
            ),
          )
        else
          for (final dish in dishes) ...[
            _DishPoster(dish: dish, onTap: onDishTap),
            const SizedBox(height: 18),
          ],
      ],
    ),
  );
}

class _DishPoster extends StatelessWidget {
  const _DishPoster({required this.dish, this.onTap});
  final Dish dish;
  final ValueChanged<Dish>? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: '${dish.name} from ${dish.restaurant}',
    child: GestureDetector(
      onTap: () => onTap?.call(dish),
      child: Container(
        key: Key('menu-poster-${dish.id}'),
        height: 410,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDDD),
          borderRadius: BorderRadius.circular(30),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final photoSize = constraints.maxWidth * .72;
            return Stack(
              children: [
                Positioned(
                  top: -70,
                  right: -95,
                  child: Transform.rotate(
                    angle: -.32,
                    child: Container(
                      width: constraints.maxWidth * 1.2,
                      height: 265,
                      decoration: const BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.all(Radius.circular(140)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 20,
                  child: _PosterLabel(label: dish.mealSection.label),
                ),
                Positioned(
                  top: 62,
                  right: -photoSize * .13,
                  child: Container(
                    width: photoSize,
                    height: photoSize,
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Color(0xBFFFFFFF),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(child: _DishImage(path: dish.imagePath)),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: _DishDetails(dish: dish),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

class _PosterLabel extends StatelessWidget {
  const _PosterLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xE6F6F0E5),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.5,
        color: AppColors.forestGreen,
      ),
    ),
  );
}

class _DishDetails extends StatelessWidget {
  const _DishDetails({required this.dish});
  final Dish dish;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 15),
    decoration: BoxDecoration(
      color: const Color(0xFDFBF9F2),
      borderRadius: BorderRadius.circular(22),
      boxShadow: const [
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 20,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          dish.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 23,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: AppColors.forestGreen,
          ),
        ),
        if (dish.description.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            dish.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.28,
              color: AppColors.espresso,
            ),
          ),
        ],
        const SizedBox(height: 10),
        Text(
          dish.restaurant,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.forestGreen,
          ),
        ),
      ],
    ),
  );
}

class _DishImage extends StatelessWidget {
  const _DishImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) => path.startsWith('assets/')
      ? Image.asset(path, fit: BoxFit.cover)
      : Image.file(File(path), fit: BoxFit.cover);
}

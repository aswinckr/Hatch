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

class MenuPage extends StatefulWidget {
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
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const visual = MenuVisualTheme.standard;
    if (widget.snapshot.dishes.isEmpty) {
      return _EmptyMenu(
        showEmptySections: widget.showEmptySections,
        bottomPadding: widget.bottomPadding,
        visual: visual,
      );
    }
    final slides = _slides();
    return Container(
      width: double.infinity,
      color: visual.paper,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _MenuPosterPage(
              key: index == 0
                  ? const Key('menu-poster')
                  : Key('menu-poster-$index'),
              slide: slides[index],
              onTap: widget.onDishTap,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 142,
            child: _CarouselIndicator(
              currentPage: _currentPage,
              pageCount: slides.length,
            ),
          ),
        ],
      ),
    );
  }

  List<_PosterSlide> _slides() {
    final savedByImage = {
      for (final dish in widget.snapshot.dishes) dish.imagePath: dish,
    };
    final demoSlides = _demoPosters
        .map(
          (poster) => _PosterSlide(
            imagePath: poster.imagePath,
            posterPath: poster.posterPath,
            label: poster.label,
            dish: savedByImage.remove(poster.imagePath),
          ),
        )
        .toList();
    final uploadedSlides = savedByImage.values
        .map(
          (dish) => _PosterSlide(
            imagePath: dish.imagePath,
            label: dish.name,
            dish: dish,
          ),
        )
        .toList();
    return [...demoSlides, ...uploadedSlides];
  }
}

class _MenuPosterPage extends StatelessWidget {
  const _MenuPosterPage({super.key, required this.slide, this.onTap});
  final _PosterSlide slide;
  final ValueChanged<Dish>? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null && slide.dish != null,
    label: 'Menu poster featuring ${slide.label}',
    child: GestureDetector(
      onTap: slide.dish == null ? null : () => onTap?.call(slide.dish!),
      child: _MenuPosterImage(slide: slide),
    ),
  );
}

class _MenuPosterImage extends StatelessWidget {
  const _MenuPosterImage({required this.slide});
  final _PosterSlide slide;

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: slide.posterPath != null
        ? Image.asset(slide.posterPath!, fit: BoxFit.cover)
        : slide.imagePath.startsWith('assets/')
        ? Image.asset(slide.imagePath, fit: BoxFit.cover)
        : Image.file(File(slide.imagePath), fit: BoxFit.cover),
  );
}

class _CarouselIndicator extends StatelessWidget {
  const _CarouselIndicator({
    required this.currentPage,
    required this.pageCount,
  });
  final int currentPage, pageCount;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xCCF6F0E5),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '${currentPage + 1} of $pageCount',
          style: const TextStyle(
            color: AppColors.forestGreen,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pageCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: index == currentPage ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: index == currentPage
                  ? AppColors.forestGreen
                  : const Color(0x99F6F0E5),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
    ],
  );
}

class _PosterSlide {
  const _PosterSlide({
    required this.imagePath,
    required this.label,
    this.posterPath,
    this.dish,
  });
  final String imagePath, label;
  final String? posterPath;
  final Dish? dish;
}

class _DemoPoster {
  const _DemoPoster({
    required this.imagePath,
    required this.posterPath,
    required this.label,
  });
  final String imagePath, posterPath, label;
}

const _demoPosters = [
  _DemoPoster(
    imagePath: 'assets/demo/truffle_eggs.png',
    posterPath: 'assets/menu/truffle_eggs_menu_poster.png',
    label: 'Truffle Eggs Benedict',
  ),
  _DemoPoster(
    imagePath: 'assets/demo/miso_cod.png',
    posterPath: 'assets/menu/shoyu_ramen_menu_poster.png',
    label: 'Shoyu Ramen',
  ),
  _DemoPoster(
    imagePath: 'assets/demo/tiramisu.png',
    posterPath: 'assets/menu/pistachio_tiramisu_menu_poster.png',
    label: 'Pistachio Tiramisu',
  ),
  _DemoPoster(
    imagePath: 'assets/demo/mushroom_pasta.png',
    posterPath: 'assets/menu/mushroom_tagliatelle_menu_poster.png',
    label: 'Wild Mushroom Tagliatelle',
  ),
];

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

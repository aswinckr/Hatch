import 'package:flutter/material.dart';

import '../../../shared/presentation/wireframe_image_placeholder.dart';
import '../data/menu_repository.dart';
import '../domain/dish.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.snapshot});

  final MenuSnapshot snapshot;

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
    final dishes = widget.snapshot.dishes;
    if (dishes.isEmpty) return const Center(child: Text('No menu pages'));

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: dishes.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            final dish = dishes[index];
            return SingleChildScrollView(
              key: Key('menu-page-$index'),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 88),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (index == 0) ...[
                        Text(
                          'The Menu',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 24),
                      ],
                      AspectRatio(
                        aspectRatio: 4 / 5,
                        child: WireframeImagePlaceholder(
                          key: Key('menu-image-${dish.id}'),
                          semanticLabel: 'Menu dish image placeholder',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        dish.mealSection.label,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dish.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(dish.description),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 16,
          child: Semantics(
            label: 'Menu page ${_currentPage + 1} of ${dishes.length}',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${_currentPage + 1} / ${dishes.length}'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / dishes.length,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

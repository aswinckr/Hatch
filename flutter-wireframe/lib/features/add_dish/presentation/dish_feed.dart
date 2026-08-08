import 'package:flutter/material.dart';

import '../../../shared/presentation/wireframe_image_placeholder.dart';
import '../../menu/domain/dish.dart';

class DishFeed extends StatelessWidget {
  const DishFeed({super.key, required this.dishes});

  final List<Dish> dishes;

  @override
  Widget build(BuildContext context) {
    final feed = List<Dish>.of(dishes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        children: [
          for (final dish in feed) ...[
            Card(
              key: Key('feed-post-${dish.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(dish.restaurant),
                    trailing: Text(
                      postedAt(dish.createdAt),
                      key: Key('posted-time-${dish.id}'),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: WireframeImagePlaceholder(
                      key: Key('wireframe-image-${dish.id}'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(dish.description),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (dish != feed.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

String postedAt(DateTime createdAt, [DateTime? currentTime]) {
  final now = currentTime ?? DateTime.now();
  final difference = now.difference(createdAt);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m';
  if (difference.inHours < 24) return '${difference.inHours}h';
  if (difference.inDays < 7) return '${difference.inDays}d';
  return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
}

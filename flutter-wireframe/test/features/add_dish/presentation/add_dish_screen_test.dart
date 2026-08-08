import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/add_dish/presentation/dish_feed.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';

void main() {
  testWidgets('feed uses generic text and never renders an image', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 8, 8, 12);
    final dishes = List.generate(
      4,
      (index) => Dish(
        id: 'seed-$index',
        imagePath: 'wireframe://seed/$index',
        name: 'Dish name',
        restaurant: 'Restaurant name',
        description: 'Short dish description',
        mealSection: MealSection.values[index % MealSection.values.length],
        createdAt: now.subtract(Duration(minutes: index)),
        updatedAt: now.subtract(Duration(minutes: index)),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: DishFeed(dishes: dishes))),
    );

    expect(find.byType(Card), findsNWidgets(4));
    expect(find.text('Dish name'), findsNWidgets(4));
    expect(find.text('Restaurant name'), findsNWidgets(4));
    expect(find.byType(Image), findsNothing);
    expect(find.byKey(const Key('wireframe-image-seed-0')), findsOneWidget);
  });
}

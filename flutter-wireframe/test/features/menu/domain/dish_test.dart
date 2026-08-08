import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';

void main() {
  test('JSON round-trip preserves a dish and copyWith changes one field', () {
    final dish = Dish(
      id: 'dish-1',
      imagePath: '/tmp/eggs.jpg',
      name: 'Truffle Eggs',
      restaurant: 'Morgenrot',
      description: 'Brioche and hollandaise',
      mealSection: MealSection.breakfast,
      createdAt: DateTime.utc(2026, 8, 7),
      updatedAt: DateTime.utc(2026, 8, 7),
    );

    expect(Dish.fromJson(dish.toJson()), dish);
    final changed = dish.copyWith(name: 'Truffle Eggs Benedict');
    expect(changed.name, 'Truffle Eggs Benedict');
    expect(changed.restaurant, 'Morgenrot');
    expect(changed.mealSection, MealSection.breakfast);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/add_dish/data/mock_dish_analyzer.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';

void main() {
  test('every selected photo receives generic workshop suggestions', () async {
    final analyzer = MockDishAnalyzer(delay: Duration.zero);

    final result = await analyzer.analyze('/photos/anything.jpeg');

    expect(result.name, 'Dish name');
    expect(result.restaurant, 'Restaurant name');
    expect(result.description, 'Short dish description');
    expect(result.mealSection, MealSection.dinner);
  });
}

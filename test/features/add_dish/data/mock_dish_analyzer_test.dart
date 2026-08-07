import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/add_dish/data/mock_dish_analyzer.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';

void main() {
  test('same demo image always returns the same suggestion', () async {
    final analyzer = MockDishAnalyzer(delay: Duration.zero);
    final first = await analyzer.analyze('assets/demo/truffle_eggs.png');
    final second = await analyzer.analyze('assets/demo/truffle_eggs.png');
    expect(first, second);
    expect(first.name, 'Truffle Eggs Benedict');
    expect(first.mealSection, MealSection.breakfast);
  });

  test('unknown image receives a complete generic suggestion', () async {
    final result = await MockDishAnalyzer(
      delay: Duration.zero,
    ).analyze('/photos/unknown.jpeg');
    expect(result.name, isNotEmpty);
    expect(result.restaurant, isNotEmpty);
    expect(result.description, isNotEmpty);
  });
}

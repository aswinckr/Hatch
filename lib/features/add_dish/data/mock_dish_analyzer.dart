import '../../menu/domain/dish.dart';
import '../domain/dish_analysis.dart';

class MockDishAnalyzer implements DishAnalyzer {
  MockDishAnalyzer({this.delay = const Duration(milliseconds: 900)});
  final Duration delay;

  static const _scenarios = <String, DishAnalysis>{
    'truffle_eggs': DishAnalysis(
      name: 'Truffle Eggs Benedict',
      restaurant: 'Café Morgenrot',
      description: 'Poached eggs, toasted brioche and truffle hollandaise',
      mealSection: MealSection.breakfast,
    ),
    'miso_cod': DishAnalysis(
      name: 'Miso Black Cod',
      restaurant: 'Sora',
      description: 'Caramelized miso glaze, pickled cucumber and sesame',
      mealSection: MealSection.lunch,
    ),
    'tiramisu': DishAnalysis(
      name: 'Classic Tiramisu',
      restaurant: 'Luna',
      description: 'Espresso-soaked sponge, mascarpone and dark cocoa',
      mealSection: MealSection.dinner,
    ),
  };

  static const _generic = DishAnalysis(
    name: 'Seasonal House Special',
    restaurant: 'Your favourite restaurant',
    description: 'A memorable dish, prepared with the season in mind',
    mealSection: MealSection.dinner,
  );

  @override
  Future<DishAnalysis> analyze(String imagePath) async {
    await Future<void>.delayed(delay);
    for (final entry in _scenarios.entries) {
      if (imagePath.contains(entry.key)) return entry.value;
    }
    return _generic;
  }
}

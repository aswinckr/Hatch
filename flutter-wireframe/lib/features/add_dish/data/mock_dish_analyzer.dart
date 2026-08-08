import '../../menu/domain/dish.dart';
import '../domain/dish_analysis.dart';

class MockDishAnalyzer implements DishAnalyzer {
  MockDishAnalyzer({this.delay = const Duration(milliseconds: 900)});

  final Duration delay;

  @override
  Future<DishAnalysis> analyze(String imagePath) async {
    await Future<void>.delayed(delay);
    return const DishAnalysis(
      name: 'Dish name',
      restaurant: 'Restaurant name',
      description: 'Short dish description',
      mealSection: MealSection.dinner,
    );
  }
}

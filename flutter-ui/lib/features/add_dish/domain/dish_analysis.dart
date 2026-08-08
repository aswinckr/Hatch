import '../../menu/domain/dish.dart';

class DishAnalysis {
  const DishAnalysis({
    required this.name,
    required this.restaurant,
    required this.description,
    required this.mealSection,
  });
  final String name, restaurant, description;
  final MealSection mealSection;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DishAnalysis &&
          name == other.name &&
          restaurant == other.restaurant &&
          description == other.description &&
          mealSection == other.mealSection;
  @override
  int get hashCode => Object.hash(name, restaurant, description, mealSection);
}

abstract interface class DishAnalyzer {
  Future<DishAnalysis> analyze(String imagePath);
}

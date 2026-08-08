import '../domain/dish.dart';

List<Dish> buildWireframeSeed(DateTime now) => List.generate(4, (index) {
  const sections = <MealSection>[
    MealSection.breakfast,
    MealSection.lunch,
    MealSection.dinner,
    MealSection.dinner,
  ];
  final timestamp = now.subtract(Duration(minutes: 4 - index));
  return Dish(
    id: 'wireframe-seed-${index + 1}',
    imagePath: 'wireframe://seed/${index + 1}',
    name: 'Dish name',
    restaurant: 'Restaurant name',
    description: 'Short dish description',
    mealSection: sections[index],
    createdAt: timestamp,
    updatedAt: timestamp,
  );
});

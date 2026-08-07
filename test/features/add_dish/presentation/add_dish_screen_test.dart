import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_menu/features/add_dish/presentation/add_dish_screen.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';

void main() {
  testWidgets('sample photo becomes an editable finalized dish', (
    tester,
  ) async {
    Dish? finalized;
    await tester.pumpWidget(
      CupertinoApp(
        home: AddDishScreen(
          analyzer: FakeDishAnalyzer(),
          onDishFinalized: (dish) async => finalized = dish,
        ),
      ),
    );
    await tester.tap(find.text('Try a sample dish'));
    await tester.pumpAndSettle();
    expect(find.text('Review your dish'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dish-name')), 'My Eggs');
    await tester.ensureVisible(find.text('Add to menu'));
    await tester.tap(find.text('Add to menu'));
    await tester.pumpAndSettle();
    expect(finalized?.name, 'My Eggs');
    expect(finalized?.mealSection, MealSection.breakfast);
    expect(find.text('Added to your menu'), findsOneWidget);
  });

  testWidgets('dish and restaurant are required', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: AddDishScreen(
          analyzer: FakeDishAnalyzer(),
          onDishFinalized: (_) async {},
        ),
      ),
    );
    await tester.tap(find.text('Try a sample dish'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dish-name')), '');
    await tester.enterText(find.byKey(const Key('restaurant-name')), '');
    await tester.ensureVisible(find.text('Add to menu'));
    await tester.tap(find.text('Add to menu'));
    await tester.pump();
    expect(find.text('Add a dish name and restaurant.'), findsOneWidget);
  });
}

class FakeDishAnalyzer implements DishAnalyzer {
  @override
  Future<DishAnalysis> analyze(String imagePath) async => const DishAnalysis(
    name: 'Truffle Eggs Benedict',
    restaurant: 'Café Morgenrot',
    description: 'Poached eggs and truffle hollandaise',
    mealSection: MealSection.breakfast,
  );
}

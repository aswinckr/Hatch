import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_wireframe/features/add_dish/presentation/add_dish_screen.dart';
import 'package:hatch_wireframe/features/menu/domain/dish.dart';

void main() {
  testWidgets('home starts with a dishes heading and floating camera action', (
    tester,
  ) async {
    await tester.pumpWidget(
      CupertinoApp(
        home: AddDishScreen(
          analyzer: FakeDishAnalyzer(),
          onDishFinalized: (_) async {},
        ),
      ),
    );

    expect(find.text('Your dishes'), findsOneWidget);
    expect(find.text('Try a sample dish'), findsNothing);
    expect(find.text('Home'), findsNothing);
    expect(find.byKey(const Key('floating-camera-button')), findsOneWidget);
    final page = tester.widget<CupertinoPageScaffold>(
      find.byType(CupertinoPageScaffold),
    );
    expect(page.backgroundColor, CupertinoColors.white);
  });

  testWidgets('home gallery displays previously captured dishes', (
    tester,
  ) async {
    final now = DateTime(2026);
    await tester.pumpWidget(
      CupertinoApp(
        home: AddDishScreen(
          analyzer: FakeDishAnalyzer(),
          onDishFinalized: (_) async {},
          capturedDishes: [
            Dish(
              id: 'dish-1',
              imagePath: 'assets/demo/truffle_eggs.png',
              name: 'Truffle Eggs',
              restaurant: 'Café Morgenrot',
              description: 'Poached eggs',
              mealSection: MealSection.breakfast,
              createdAt: now,
              updatedAt: now,
            ),
          ],
        ),
      ),
    );

    expect(find.text('Truffle Eggs'), findsOneWidget);
    expect(find.text('Café Morgenrot'), findsOneWidget);
    expect(find.byKey(const Key('feed-post-dish-1')), findsOneWidget);
    expect(find.byKey(const Key('posted-time-dish-1')), findsOneWidget);
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

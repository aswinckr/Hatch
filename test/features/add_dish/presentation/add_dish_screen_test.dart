import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/add_dish/domain/dish_analysis.dart';
import 'package:hatch_menu/features/add_dish/presentation/add_dish_screen.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/core/design/app_shapes.dart';

void main() {
  testWidgets('home starts with an empty gallery and floating camera action', (
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

    expect(find.text('Your gallery is waiting'), findsOneWidget);
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
    final addButton = tester.widget<CupertinoButton>(
      find.widgetWithText(CupertinoButton, 'Add to menu'),
    );
    expect(addButton.borderRadius, AppShapes.pill);
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

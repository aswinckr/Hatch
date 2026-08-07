import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/features/export/menu_pdf_renderer.dart';
import 'package:hatch_menu/features/menu/data/menu_repository.dart';
import 'package:hatch_menu/features/menu/domain/dish.dart';
import 'package:hatch_menu/features/menu/domain/menu_style.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'render creates a PDF and only includes populated meal sections',
    () async {
      final snapshot = MenuSnapshot(
        dishes: [breakfastDish],
        style: MenuStyle.editorial,
      );
      final renderer = MenuPdfRenderer();
      expect(renderer.includedSections(snapshot), [MealSection.breakfast]);
      final bytes = await renderer.render(snapshot);
      expect(ascii.decode(bytes.take(4).toList()), '%PDF');
      expect(bytes.length, greaterThan(1000));
    },
  );

  test('empty menu cannot be rendered', () async {
    final renderer = MenuPdfRenderer();
    expect(
      () => renderer.render(
        const MenuSnapshot(dishes: [], style: MenuStyle.editorial),
      ),
      throwsA(isA<EmptyMenuException>()),
    );
  });
}

final breakfastDish = Dish(
  id: 'one',
  imagePath: 'eggs.jpg',
  name: 'Truffle Eggs',
  restaurant: 'Café Morgenrot',
  description: 'Brioche and hollandaise',
  mealSection: MealSection.breakfast,
  createdAt: DateTime.utc(2026, 8, 7),
  updatedAt: DateTime.utc(2026, 8, 7),
);

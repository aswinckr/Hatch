import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/data/wireframe_seed.dart';
import 'package:hatch_wireframe/features/menu/presentation/menu_page.dart';

void main() {
  testWidgets('four dishes render four full-screen placeholder pages', (
    tester,
  ) async {
    final dishes = buildWireframeSeed(DateTime.utc(2026, 8, 8, 12));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuPage(snapshot: MenuSnapshot(dishes: dishes)),
        ),
      ),
    );

    expect(find.byKey(const Key('menu-page-0')), findsOneWidget);
    expect(find.text('The Menu'), findsOneWidget);
    expect(find.text('1 / 4'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('menu swipes and only the first page has the menu heading', (
    tester,
  ) async {
    final dishes = buildWireframeSeed(DateTime.utc(2026, 8, 8, 12));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuPage(snapshot: MenuSnapshot(dishes: dishes)),
        ),
      ),
    );

    await tester.drag(
      find.byKey(const Key('menu-page-0')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('menu-page-1')), findsOneWidget);
    expect(find.text('2 / 4'), findsOneWidget);
    expect(find.text('The Menu'), findsNothing);
    expect(find.text('Dish name'), findsOneWidget);
    expect(find.text('Short dish description'), findsOneWidget);
  });
}

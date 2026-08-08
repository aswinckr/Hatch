import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_wireframe/features/menu/data/menu_repository.dart';
import 'package:hatch_wireframe/features/menu/data/wireframe_seed.dart';
import 'package:hatch_wireframe/features/menu/presentation/menu_page.dart';

void main() {
  testWidgets('tapping a wireframe page does not open dish editing', (
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

    await tester.tap(find.byKey(const Key('menu-page-0')));
    await tester.pumpAndSettle();

    expect(find.text('Review your dish'), findsNothing);
  });
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hatch_menu/app/floating_tab_bar.dart';

void main() {
  testWidgets('floating pill shows two destinations and changes selection', (
    tester,
  ) async {
    var selected = 0;
    await tester.pumpWidget(
      CupertinoApp(
        home: StatefulBuilder(
          builder: (context, setState) => CupertinoPageScaffold(
            child: Center(
              child: SizedBox(
                width: 358,
                child: FloatingTabBar(
                  selectedIndex: selected,
                  onSelected: (index) => setState(() => selected = index),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Add Dish'), findsOneWidget);
    expect(find.text('My Menu'), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
    await tester.tap(find.text('My Menu'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('unseen menu item renders a single notification dot', (
    tester,
  ) async {
    await tester.pumpWidget(
      const CupertinoApp(
        home: CupertinoPageScaffold(
          child: Center(
            child: SizedBox(
              width: 358,
              child: FloatingTabBar(
                selectedIndex: 0,
                hasNewMenuItem: true,
                onSelected: _ignore,
              ),
            ),
          ),
        ),
      ),
    );
    final dots = find.byWidgetPredicate(
      (widget) => widget is SizedBox && widget.width == 8 && widget.height == 8,
    );
    expect(dots, findsOneWidget);
  });
}

void _ignore(int _) {}

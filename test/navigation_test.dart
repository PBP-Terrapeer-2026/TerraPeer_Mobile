import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terrapeer_mobile/core/router/app_destinations.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('home lists every module', (tester) async {
    await pumpTerraPeer(tester);

    expect(find.text('Selamat datang di TerraPeer'), findsOneWidget);
    for (final d in moduleDestinations) {
      expect(find.text(d.label), findsOneWidget);
    }
  });

  testWidgets('phone: drawer navigates to every module page', (tester) async {
    await pumpTerraPeer(tester);

    for (final d in moduleDestinations) {
      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(
        of: find.byType(NavigationDrawer),
        matching: find.text(d.label),
      ));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, d.label), findsOneWidget);
      expect(find.text('Halaman ${d.label} sedang dikembangkan.'), findsOneWidget);
    }
  });

  testWidgets('home card opens its module', (tester) async {
    await pumpTerraPeer(tester);

    await tester.tap(find.text('My Plants'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman My Plants sedang dikembangkan.'), findsOneWidget);
  });

  testWidgets('tablet: navigation rail replaces the drawer', (tester) async {
    await pumpTerraPeer(tester, size: tabletSize);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsNothing);

    await tester.tap(find.descendant(
      of: find.byType(NavigationRail),
      matching: find.text('Plant Care'),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Plant Care sedang dikembangkan.'), findsOneWidget);
  });
}

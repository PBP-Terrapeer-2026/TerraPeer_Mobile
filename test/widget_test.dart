import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:terrapeer_mobile/app.dart';
import 'package:terrapeer_mobile/core/router/app_destinations.dart';

void main() {
  void setScreen(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('home lists every module', (tester) async {
    setScreen(tester, const Size(400, 900));
    await tester.pumpWidget(const TerraPeerApp(useGoogleFonts: false));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang di TerraPeer'), findsOneWidget);
    for (final d in moduleDestinations) {
      expect(find.text(d.label), findsOneWidget);
    }
  });

  testWidgets('phone: drawer navigates to every module page', (tester) async {
    setScreen(tester, const Size(400, 900));
    await tester.pumpWidget(const TerraPeerApp(useGoogleFonts: false));
    await tester.pumpAndSettle();

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
    setScreen(tester, const Size(400, 900));
    await tester.pumpWidget(const TerraPeerApp(useGoogleFonts: false));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Plants'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman My Plants sedang dikembangkan.'), findsOneWidget);
  });

  testWidgets('tablet: navigation rail replaces the drawer', (tester) async {
    setScreen(tester, const Size(1200, 900));
    await tester.pumpWidget(const TerraPeerApp(useGoogleFonts: false));
    await tester.pumpAndSettle();

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

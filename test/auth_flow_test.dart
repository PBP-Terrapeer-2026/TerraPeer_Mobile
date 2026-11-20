import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  Finder field(String label) => find.widgetWithText(TextFormField, label);

  testWidgets('guest sees the home page and a login button', (tester) async {
    await pumpTerraPeer(tester, loggedIn: false);

    expect(find.text('Selamat datang di TerraPeer'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);
  });

  testWidgets('guest opening a module is sent to login, then back to that module',
      (tester) async {
    await pumpTerraPeer(tester, loggedIn: false);

    await tester.tap(find.text('My Plants'));
    await tester.pumpAndSettle();
    expect(find.text('Selamat datang kembali'), findsOneWidget);

    await tester.enterText(field('Username'), 'farel');
    await tester.enterText(field('Password'), 'rahasia123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman My Plants sedang dikembangkan.'), findsOneWidget);
  });

  testWidgets('empty form shows validation errors without calling the API', (tester) async {
    final repo = FakeAuthRepository();
    await pumpTerraPeer(tester, repository: repo);
    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Username wajib diisi.'), findsOneWidget);
    expect(find.text('Password wajib diisi.'), findsOneWidget);
    expect(repo.loginCalls, 0);
  });

  testWidgets('wrong password shows an error and stays on login', (tester) async {
    await pumpTerraPeer(tester, loggedIn: false);
    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    await tester.enterText(field('Username'), 'farel');
    await tester.enterText(field('Password'), 'salah');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Username atau password salah.'), findsOneWidget);
    expect(find.text('Selamat datang kembali'), findsOneWidget);
  });

  testWidgets('logout returns to the public home page', (tester) async {
    final auth = await pumpTerraPeer(tester);
    await tester.tap(find.text('My Plants'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Akun'));
    await tester.pumpAndSettle();
    expect(find.text('Masuk sebagai farel'), findsOneWidget);
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();

    expect(auth.isAuthenticated, isFalse);
    expect(find.text('Selamat datang di TerraPeer'), findsOneWidget);
    expect(find.byIcon(Icons.login), findsOneWidget);
  });

  testWidgets('expired token (401) logs the user out', (tester) async {
    final auth = await pumpTerraPeer(tester);
    await tester.tap(find.text('Plant Care'));
    await tester.pumpAndSettle();

    auth.handleUnauthorized();
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang kembali'), findsOneWidget);
  });
}

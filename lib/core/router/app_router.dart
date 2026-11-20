import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/app_shell.dart';
import 'app_destinations.dart';
import 'app_routes.dart';

/// Builds the app router.
///
/// * Every top-level page lives inside [AppShell] (app bar + drawer / rail).
/// * Guests may only open [AppRoutes.publicRoutes]; any other page sends them
///   to the login page and back to where they wanted to go after logging in.
/// * The router listens to [auth], so logging in or out (or an expired token)
///   moves the user automatically.
///
/// To add a sub-page for a module (e.g. a detail page), add a child route
/// under that module's [GoRoute] using `routes: [...]`.
GoRouter createAppRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: auth,
    redirect: (context, state) => authRedirect(
      status: auth.status,
      location: state.matchedLocation,
      fullUri: state.uri,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => fadeTransitionPage(
          state: state,
          child: const LoginPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          for (final destination in allDestinations)
            GoRoute(
              path: destination.path,
              pageBuilder: (context, state) => fadeTransitionPage(
                state: state,
                child: destination.builder(context),
              ),
            ),
        ],
      ),
    ],
  );
}

/// Pure redirect rule, kept separate so it can be unit-tested.
String? authRedirect({
  required AuthStatus status,
  required String location,
  required Uri fullUri,
}) {
  if (status == AuthStatus.unknown) return null;

  final isLoginPage = location == AppRoutes.login;
  final isPublic = AppRoutes.publicRoutes.contains(location);

  if (status == AuthStatus.guest && !isPublic) {
    return Uri(path: AppRoutes.login, queryParameters: {'from': fullUri.toString()}).toString();
  }
  if (status == AuthStatus.authenticated && isLoginPage) {
    final from = fullUri.queryParameters['from'];
    // Only follow in-app paths, never an external URL.
    return (from != null && from.startsWith('/') && !from.startsWith('//'))
        ? from
        : AppRoutes.home;
  }
  return null;
}

/// Smooth fade + slight slide used for every page change.
CustomTransitionPage<void> fadeTransitionPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

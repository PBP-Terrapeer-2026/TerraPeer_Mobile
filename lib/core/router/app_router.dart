import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_shell.dart';
import 'app_destinations.dart';
import 'app_routes.dart';

/// Builds the app router. Every top-level page lives inside [AppShell],
/// which provides the app bar and the drawer / navigation rail.
///
/// To add a sub-page for a module (e.g. a detail page), add a child route
/// under that module's [GoRoute] using `routes: [...]`.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
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

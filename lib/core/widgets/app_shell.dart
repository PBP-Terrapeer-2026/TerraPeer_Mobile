import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_destinations.dart';
import '../theme/app_colors.dart';

/// Responsive frame around every top-level page.
///
/// * Phone (< 840 px wide): app bar + navigation drawer.
/// * Tablet / wide screens: permanent navigation rail on the left
///   (extended with labels from 1100 px).
class AppShell extends StatelessWidget {
  static const double railBreakpoint = 840;
  static const double extendedRailBreakpoint = 1100;

  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  @override
  Widget build(BuildContext context) {
    final selected = destinationIndexFor(location);
    final destination = allDestinations[selected];
    final width = MediaQuery.sizeOf(context).width;
    final title = selected == 0 ? 'TerraPeer' : destination.label;

    void goTo(int index) {
      if (index != selected) context.go(allDestinations[index].path);
    }

    if (width < railBreakpoint) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        drawer: _AppDrawer(selectedIndex: selected, onSelected: goTo),
        body: SafeArea(top: false, child: child),
      );
    }

    final extended = width >= extendedRailBreakpoint;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selected,
              onDestinationSelected: goTo,
              extended: extended,
              labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
              destinations: [
                for (final d in allDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _AppDrawer({required this.selectedIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        Navigator.of(context).pop();
        onSelected(index);
      },
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          color: AppColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TerraPeer',
                style: textTheme.headlineMedium?.copyWith(color: AppColors.onPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Asisten berkebun pribadimu',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
              ),
            ],
          ),
        ),
        for (final d in allDestinations)
          NavigationDrawerDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
          ),
      ],
    );
  }
}

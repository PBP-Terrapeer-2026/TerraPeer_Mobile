import 'package:flutter/material.dart';

import 'state_views.dart';

/// Temporary body for a module page that has not been built yet.
/// Each module owner replaces this with their real page content.
class ModulePlaceholder extends StatelessWidget {
  final String moduleName;
  final IconData icon;

  const ModulePlaceholder({super.key, required this.moduleName, required this.icon});

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      icon: icon,
      message: 'Halaman $moduleName sedang dikembangkan.',
    );
  }
}

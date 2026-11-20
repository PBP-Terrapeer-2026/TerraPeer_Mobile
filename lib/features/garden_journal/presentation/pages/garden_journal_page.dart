import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the Garden Journal module.
///
/// Clean Architecture layers (see lib/features/auth for a complete example):
///   domain/entities/       plain Dart classes (no Flutter, no JSON)
///   domain/repositories/   abstract repository the UI depends on
///   data/models/           JSON <-> entity conversion
///   data/datasources/      calls to this module's DRF endpoint via ApiClient
///   data/repositories/     implementation of the domain repository
///   presentation/providers ChangeNotifier holding loading / data / error state
///   presentation/pages     pages, presentation/widgets  reusable widgets
class GardenJournalPage extends StatelessWidget {
  const GardenJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      moduleName: 'Garden Journal',
      icon: Icons.menu_book_outlined,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the Garden Journal module.
///
/// Module structure:
///   data/models/     JSON models for this module's DRF endpoint
///   data/services/   API calls for this module
///   presentation/    pages and widgets
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

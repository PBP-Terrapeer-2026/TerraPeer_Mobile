import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the Garden Planning module.
///
/// Module structure:
///   data/models/     JSON models for this module's DRF endpoint
///   data/services/   API calls for this module
///   presentation/    pages and widgets
class GardenPlanningPage extends StatelessWidget {
  const GardenPlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      moduleName: 'Garden Planning',
      icon: Icons.event_note_outlined,
    );
  }
}

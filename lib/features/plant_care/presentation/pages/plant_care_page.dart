import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the Plant Care module.
///
/// Module structure:
///   data/models/     JSON models for this module's DRF endpoint
///   data/services/   API calls for this module
///   presentation/    pages and widgets
class PlantCarePage extends StatelessWidget {
  const PlantCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      moduleName: 'Plant Care',
      icon: Icons.water_drop_outlined,
    );
  }
}

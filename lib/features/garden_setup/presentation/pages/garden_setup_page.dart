import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the Garden Setup module.
///
/// Module structure:
///   data/models/     JSON models for this module's DRF endpoint
///   data/services/   API calls for this module
///   presentation/    pages and widgets
class GardenSetupPage extends StatelessWidget {
  const GardenSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      moduleName: 'Garden Setup',
      icon: Icons.yard_outlined,
    );
  }
}

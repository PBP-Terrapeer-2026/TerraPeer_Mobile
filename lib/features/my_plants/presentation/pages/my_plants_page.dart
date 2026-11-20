import 'package:flutter/material.dart';

import '../../../../core/widgets/module_placeholder.dart';

/// Entry page of the My Plants module.
///
/// Module structure:
///   data/models/     JSON models for this module's DRF endpoint
///   data/services/   API calls for this module
///   presentation/    pages and widgets
class MyPlantsPage extends StatelessWidget {
  const MyPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholder(
      moduleName: 'My Plants',
      icon: Icons.local_florist_outlined,
    );
  }
}

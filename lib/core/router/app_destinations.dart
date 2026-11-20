import 'package:flutter/material.dart';

import '../../features/garden_journal/presentation/pages/garden_journal_page.dart';
import '../../features/garden_planning/presentation/pages/garden_planning_page.dart';
import '../../features/garden_setup/presentation/pages/garden_setup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/my_plants/presentation/pages/my_plants_page.dart';
import '../../features/plant_care/presentation/pages/plant_care_page.dart';
import 'app_routes.dart';

/// One top-level destination in the navigation (drawer / rail).
/// The router, the navigation and the home grid are all built from this list,
/// so adding a module means adding one entry here.
class AppDestination {
  final String label;
  final String description;
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final WidgetBuilder builder;

  const AppDestination({
    required this.label,
    required this.description,
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.builder,
  });
}

final AppDestination homeDestination = AppDestination(
  label: 'Home',
  description: 'Ringkasan TerraPeer',
  path: AppRoutes.home,
  icon: Icons.home_outlined,
  selectedIcon: Icons.home,
  builder: (_) => const HomePage(),
);

final List<AppDestination> moduleDestinations = [
  AppDestination(
    label: 'Garden Setup',
    description: 'Profil ruang tanam: lokasi, cahaya, dan media tanam.',
    path: AppRoutes.gardenSetup,
    icon: Icons.yard_outlined,
    selectedIcon: Icons.yard,
    builder: (_) => const GardenSetupPage(),
  ),
  AppDestination(
    label: 'Garden Planning',
    description: 'Rekomendasi tanaman dan rencana kebun.',
    path: AppRoutes.gardenPlanning,
    icon: Icons.event_note_outlined,
    selectedIcon: Icons.event_note,
    builder: (_) => const GardenPlanningPage(),
  ),
  AppDestination(
    label: 'My Plants',
    description: 'Tanaman yang sudah ditanam dan tahap pertumbuhannya.',
    path: AppRoutes.myPlants,
    icon: Icons.local_florist_outlined,
    selectedIcon: Icons.local_florist,
    builder: (_) => const MyPlantsPage(),
  ),
  AppDestination(
    label: 'Plant Care',
    description: 'Tugas perawatan tanaman dan informasi cuaca.',
    path: AppRoutes.plantCare,
    icon: Icons.water_drop_outlined,
    selectedIcon: Icons.water_drop,
    builder: (_) => const PlantCarePage(),
  ),
  AppDestination(
    label: 'Garden Journal',
    description: 'Catatan perkembangan tanaman dalam timeline.',
    path: AppRoutes.gardenJournal,
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book,
    builder: (_) => const GardenJournalPage(),
  ),
];

final List<AppDestination> allDestinations = [homeDestination, ...moduleDestinations];

/// Index of the destination that owns [location] (also matches sub-routes,
/// e.g. `/my-plants/12` selects My Plants).
int destinationIndexFor(String location) {
  for (var i = allDestinations.length - 1; i > 0; i--) {
    final path = allDestinations[i].path;
    if (location == path || location.startsWith('$path/')) return i;
  }
  return 0;
}

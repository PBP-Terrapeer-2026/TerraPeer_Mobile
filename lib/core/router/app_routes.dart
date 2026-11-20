/// Route paths. Always navigate with these constants, e.g.
/// `context.go(AppRoutes.myPlants)`, never with string literals.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const gardenSetup = '/garden-setup';
  static const gardenPlanning = '/garden-planning';
  static const myPlants = '/my-plants';
  static const plantCare = '/plant-care';
  static const gardenJournal = '/garden-journal';
}

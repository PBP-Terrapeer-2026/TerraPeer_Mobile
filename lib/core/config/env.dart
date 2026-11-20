/// App-wide configuration.
///
/// The Django site (Proyek Tengah Semester) is the single source of data.
/// Override the base URL at run time without editing code, e.g. for an
/// Android emulator talking to a local server:
///
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://muhammad-farel52-terrapeer.pws.cs.ui.ac.id',
  );

  /// Prefix of every Django REST Framework endpoint.
  static const String apiPrefix = '/api/v1';

  static Uri api(String path) => Uri.parse('$baseUrl$apiPrefix$path');
}

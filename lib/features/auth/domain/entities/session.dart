/// A logged-in user. Domain layer: plain Dart, no Flutter or HTTP imports.
class Session {
  final String username;
  final String token;

  const Session({required this.username, required this.token});
}

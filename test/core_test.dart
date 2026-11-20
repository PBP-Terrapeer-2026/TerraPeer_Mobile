import 'package:flutter_test/flutter_test.dart';
import 'package:terrapeer_mobile/core/network/api_exception.dart';
import 'package:terrapeer_mobile/core/router/app_router.dart';
import 'package:terrapeer_mobile/features/auth/presentation/providers/auth_provider.dart';

void main() {
  group('ApiException.fromResponse', () {
    test('reads DRF "detail"', () {
      final e = ApiException.fromResponse(
          401, '{"detail": "Authentication credentials were not provided."}');
      expect(e.isUnauthorized, isTrue);
      expect(e.message, 'Authentication credentials were not provided.');
    });

    test('reads non_field_errors', () {
      final e = ApiException.fromResponse(
          400, '{"non_field_errors": ["Unable to log in with provided credentials."]}');
      expect(e.isValidationError, isTrue);
      expect(e.message, 'Unable to log in with provided credentials.');
    });

    test('keeps per-field serializer errors', () {
      final e = ApiException.fromResponse(
          400, '{"planted_on": ["Planting date cannot be in the future."]}');
      expect(e.errorFor('planted_on'), 'Planting date cannot be in the future.');
      expect(e.message, 'Planting date cannot be in the future.');
    });

    test('falls back to a friendly message for non-JSON bodies', () {
      final e = ApiException.fromResponse(502, '<html>Bad Gateway</html>');
      expect(e.message, contains('Server'));
    });
  });

  group('authRedirect', () {
    Uri uri(String s) => Uri.parse(s);

    test('guest may open home and login', () {
      expect(authRedirect(status: AuthStatus.guest, location: '/', fullUri: uri('/')), isNull);
      expect(
          authRedirect(status: AuthStatus.guest, location: '/login', fullUri: uri('/login')),
          isNull);
    });

    test('guest opening a module goes to login with a return path', () {
      expect(
        authRedirect(status: AuthStatus.guest, location: '/my-plants', fullUri: uri('/my-plants')),
        '/login?from=%2Fmy-plants',
      );
    });

    test('logged-in user on login goes back to "from"', () {
      expect(
        authRedirect(
            status: AuthStatus.authenticated,
            location: '/login',
            fullUri: uri('/login?from=%2Fplant-care')),
        '/plant-care',
      );
    });

    test('"from" pointing outside the app is ignored', () {
      expect(
        authRedirect(
            status: AuthStatus.authenticated,
            location: '/login',
            fullUri: uri('/login?from=https%3A%2F%2Fevil.example')),
        '/',
      );
    });
  });
}

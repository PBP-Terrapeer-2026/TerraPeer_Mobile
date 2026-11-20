import 'dart:convert';

/// Error thrown by [ApiClient] for every failed request, so each module
/// handles failures the same way.
///
/// Understands Django REST Framework error bodies:
///   {"detail": "Authentication credentials were not provided."}
///   {"non_field_errors": ["Unable to log in with provided credentials."]}
///   {"planted_on": ["Planting date cannot be in the future."]}
class ApiException implements Exception {
  /// HTTP status code, or null when the server could not be reached.
  final int? statusCode;
  final String message;

  /// Per-field validation messages from DRF serializers.
  final Map<String, List<String>> fieldErrors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  const ApiException.network()
      : statusCode = null,
        message = 'Tidak dapat terhubung ke server. Periksa koneksi internet.',
        fieldErrors = const {};

  bool get isUnauthorized => statusCode == 401;
  bool get isNetworkError => statusCode == null;
  bool get isValidationError => statusCode == 400;

  /// First message for [field], if the server rejected that field.
  String? errorFor(String field) {
    final errors = fieldErrors[field];
    return (errors == null || errors.isEmpty) ? null : errors.first;
  }

  factory ApiException.fromResponse(int statusCode, String body) {
    final fallback = _defaultMessage(statusCode);
    dynamic decoded;
    try {
      decoded = body.isEmpty ? null : jsonDecode(body);
    } on FormatException {
      return ApiException(statusCode: statusCode, message: fallback);
    }

    if (decoded is Map<String, dynamic>) {
      final fields = <String, List<String>>{};
      String? message;
      decoded.forEach((key, value) {
        final messages = _asMessages(value);
        if (messages.isEmpty) return;
        if (key == 'detail' || key == 'non_field_errors' || key == 'error') {
          message ??= messages.first;
        } else {
          fields[key] = messages;
        }
      });
      message ??= fields.isNotEmpty ? fields.values.first.first : fallback;
      return ApiException(statusCode: statusCode, message: message!, fieldErrors: fields);
    }

    if (decoded is List) {
      final messages = _asMessages(decoded);
      if (messages.isNotEmpty) {
        return ApiException(statusCode: statusCode, message: messages.first);
      }
    }
    return ApiException(statusCode: statusCode, message: fallback);
  }

  static List<String> _asMessages(dynamic value) {
    if (value is String) return [value];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is Map) return value.values.expand(_asMessages).toList();
    return const [];
  }

  static String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Data yang dikirim tidak valid.';
      case 401:
        return 'Sesi berakhir. Silakan masuk lagi.';
      case 403:
        return 'Kamu tidak punya akses ke data ini.';
      case 404:
        return 'Data tidak ditemukan.';
      case 429:
        return 'Terlalu banyak permintaan. Coba lagi sebentar lagi.';
      default:
        return statusCode >= 500
            ? 'Server sedang bermasalah. Coba lagi nanti.'
            : 'Terjadi kesalahan ($statusCode).';
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}

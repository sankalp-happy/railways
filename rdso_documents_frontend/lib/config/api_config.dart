class ApiConfig {
  // TODO: Switch defaultValue to HTTPS once the server has a TLS certificate.
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );
}

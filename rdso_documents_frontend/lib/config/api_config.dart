class ApiConfig {
  // TODO: Switch defaultValue to HTTPS once the server has a TLS certificate.
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://52.140.125.36/api',
  );
}

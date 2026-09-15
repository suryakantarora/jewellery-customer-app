import 'dart:io';

import 'data_mode.dart';
import 'environment.dart';

/// Immutable runtime configuration read from `--dart-define` values.
///
/// No secrets are ever compiled in. The tenant key is the one build-time value
/// that varies per white-label build (plan Q2); in dev it can be overridden at
/// runtime from the shop-code screen.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.tenantKey,
    required this.dataMode,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  final Environment environment;
  final String apiBaseUrl;

  /// The company this binary belongs to. Default `fino`.
  final String tenantKey;

  final DataMode dataMode;

  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// The API root including the version segment.
  String get apiRoot => '$apiBaseUrl/api/v1';

  static const _envName = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const _baseUrl = String.fromEnvironment('API_BASE_URL');
  static const _tenantKey = String.fromEnvironment(
    'TENANT_KEY',
    defaultValue: 'fino',
  );
  static const _dataMode = String.fromEnvironment(
    'DATA_MODE',
    defaultValue: 'demo',
  );

  factory AppConfig.fromEnvironment() {
    final environment = Environment.fromName(_envName);
    final base = _baseUrl.isNotEmpty ? _baseUrl : _defaultBaseUrl(environment);
    return AppConfig(
      environment: environment,
      apiBaseUrl: _stripTrailingSlash(base),
      tenantKey: _tenantKey.isEmpty ? 'fino' : _tenantKey,
      dataMode: DataMode.fromName(_dataMode),
    );
  }

  static String _defaultBaseUrl(Environment environment) {
    switch (environment) {
      case Environment.dev:
        // 10.0.2.2 reaches the host machine from the Android emulator; an iOS
        // simulator shares the host's localhost.
        return Platform.isAndroid
            ? 'http://10.0.2.2:8081'
            : 'http://localhost:8081';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }

  static String _stripTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  AppConfig copyWith({String? tenantKey, DataMode? dataMode}) => AppConfig(
    environment: environment,
    apiBaseUrl: apiBaseUrl,
    tenantKey: tenantKey ?? this.tenantKey,
    dataMode: dataMode ?? this.dataMode,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
  );
}

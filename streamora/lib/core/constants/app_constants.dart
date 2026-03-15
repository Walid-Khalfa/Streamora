class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Streamora';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Storage Keys
  static const String userKey = 'user';
  static const String authCredentialsKey = 'auth_credentials';
  static const String serverUrlKey = 'server_url';
  static const String settingsKey = 'settings';
  static const String favoritesKey = 'favorites';
  static const String watchHistoryKey = 'watch_history';
  static const String themeKey = 'theme_mode';

  // Database
  static const String databaseName = 'streamora.db';
  static const int databaseVersion = 1;

  // Content Types
  static const String contentTypeLive = 'live';
  static const String contentTypeVod = 'movie';
  static const String contentTypeSeries = 'series';

  // Player Settings
  static const int defaultBufferDuration = 30000;
  static const double defaultPlaybackSpeed = 1.0;
  static const bool defaultAutoPlay = true;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI
  static const double cardBorderRadius = 12.0;
  static const double inputBorderRadius = 8.0;
  static const double buttonBorderRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}

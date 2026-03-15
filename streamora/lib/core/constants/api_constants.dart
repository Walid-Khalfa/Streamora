class ApiConstants {
  ApiConstants._();

  // Xtream API Endpoints
  static const String authenticate = '/player_api.php';
  static const String getAccountInfo = '/player_api.php';
  static const String getLiveCategories = '/player_api.php?action=get_live_categories';
  static const String getLiveStreams = '/player_api.php?action=get_live_streams';
  static const String getVodCategories = '/player_api.php?action=get_vod_categories';
  static const String getVodStreams = '/player_api.php?action=get_vod_streams';
  static const String getSeriesCategories = '/player_api.php?action=get_series_categories';
  static const String getSeries = '/player_api.php?action=get_series';
  static const String getSeriesInfo = '/player_api.php?action=get_series_info';
  static const String getShortEpg = '/player_api.php?action=get_short_epg';
  static const String getEpg = '/player_api.php?action=get_simple_data_table';

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Cache duration
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration epgCacheDuration = Duration(minutes: 2);
}

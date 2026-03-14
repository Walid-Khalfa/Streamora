class ApiConstants {
  ApiConstants._();

  static const String xtreamApiVersion = '1.0.0';
  static const int defaultTimeout = 30000;
  static const int maxRetries = 3;

  // Xtream Codes API endpoints
  static const String authenticateEndpoint = '/player_api.php';
  static const String liveCategoriesEndpoint = '/player_api.php?action=get_live_categories';
  static const String liveStreamsEndpoint = '/player_api.php?action=get_live_streams';
  static const String vodCategoriesEndpoint = '/player_api.php?action=get_vod_categories';
  static const String vodStreamsEndpoint = '/player_api.php?action=get_vod_streams';
  static const String seriesCategoriesEndpoint = '/player_api.php?action=get_series_categories';
  static const String seriesEndpoint = '/player_api.php?action=get_series';
  static const String epgEndpoint = '/xmltv.php';

  // Stream URL patterns
  static String liveStreamUrl(String baseUrl, String username, String password, int streamId, String extension) {
    return '$baseUrl/live/$username/$password/$streamId.$extension';
  }

  static String vodStreamUrl(String baseUrl, String username, String password, int streamId, String extension) {
    return '$baseUrl/movie/$username/$password/$streamId.$extension';
  }

  static String seriesStreamUrl(String baseUrl, String username, String password, int streamId, String extension) {
    return '$baseUrl/series/$username/$password/$streamId.$extension';
  }
}

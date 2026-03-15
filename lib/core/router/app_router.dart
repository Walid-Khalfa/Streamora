import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/live/presentation/screens/live_tv_screen.dart';
import '../../features/vod/presentation/screens/movies_screen.dart';
import '../../features/series/presentation/screens/series_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/player/presentation/screens/video_player_screen.dart';
import '../widgets/main_layout.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String login = '/login';
  static const String live = '/live';
  static const String movies = '/movies';
  static const String series = '/series';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String player = '/player';

  static GoRouter router(
    bool isAuthenticated, {
    String? initialLocation,
    bool Function()? getAuthStatus,
  }) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation ?? (isAuthenticated ? live : splash),
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            GoRoute(
              path: live,
              builder: (context, state) => const LiveTvScreen(),
            ),
            GoRoute(
              path: movies,
              builder: (context, state) => const MoviesScreen(),
            ),
            GoRoute(
              path: series,
              builder: (context, state) => const SeriesScreen(),
            ),
            GoRoute(
              path: favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
            GoRoute(
              path: settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
        GoRoute(
          path: search,
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: player,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return VideoPlayerScreen(
              streamUrl: extra?['streamUrl'] ?? '',
              title: extra?['title'] ?? '',
              iconUrl: extra?['iconUrl'],
              contentType: extra?['contentType'] ?? 'live',
              contentId: extra?['contentId'],
            );
          },
        ),
      ],
      redirect: (context, state) {
        // Use dynamic auth check if provided, otherwise fall back to captured value
        final isLoggedIn = getAuthStatus?.call() ?? isAuthenticated;
        final isLoggingIn = state.matchedLocation == login || state.matchedLocation == splash;

        // If not logged in and not on login/splash, redirect to login
        if (!isLoggedIn && !isLoggingIn) {
          return login;
        }

        // If logged in and on login/splash, redirect to live
        if (isLoggedIn && isLoggingIn) {
          return live;
        }

        return null;
      },
    );
  }
}

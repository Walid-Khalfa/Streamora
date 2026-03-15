import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/continue_watching/presentation/screens/continue_watching_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/live/presentation/screens/epg_screen.dart';
import '../../features/live/presentation/screens/live_tv_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/player/presentation/screens/video_player_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/series/presentation/screens/series_detail_screen.dart';
import '../../features/series/presentation/screens/series_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/vod/presentation/screens/movie_detail_screen.dart';
import '../../features/vod/presentation/screens/movies_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_, __) => true,
        orElse: () => false,
      );

      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LiveTvScreen(),
          ),
          GoRoute(
            path: '/movies',
            builder: (context, state) => const MoviesScreen(),
          ),
          GoRoute(
            path: '/series',
            builder: (context, state) => const SeriesScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/player',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VideoPlayerScreen(
            streamUrl: extra?['streamUrl'] ?? '',
            title: extra?['title'] ?? 'Unknown',
            type: extra?['type'] ?? 'live',
            streamId: extra?['streamId'],
            coverUrl: extra?['coverUrl'],
            position: extra?['position'],
          );
        },
      ),
      GoRoute(
        path: '/movie/:id',
        builder: (context, state) {
          final movieId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MovieDetailScreen(movieId: movieId);
        },
      ),
      GoRoute(
        path: '/series/:id',
        builder: (context, state) {
          final seriesId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return SeriesDetailScreen(seriesId: seriesId);
        },
      ),
      GoRoute(
        path: '/epg/:id',
        builder: (context, state) {
          final channelId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final extra = state.extra as Map<String, dynamic>?;
          return EpgScreen(
            channelId: channelId,
            channelName: extra?['channelName'] ?? 'Unknown',
            channelLogo: extra?['channelLogo'],
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/continue-watching',
        builder: (context, state) => const ContinueWatchingScreen(),
      ),
    ],
  );
}

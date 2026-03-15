import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  
  // Open Hive boxes
  final userBox = await Hive.openBox<String>('user_box');
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F0F0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        userBoxProvider.overrideWithValue(userBox),
      ],
      child: const StreamoraApp(),
    ),
  );
}

class StreamoraApp extends ConsumerStatefulWidget {
  const StreamoraApp({super.key});

  @override
  ConsumerState<StreamoraApp> createState() => _StreamoraAppState();
}

class _StreamoraAppState extends ConsumerState<StreamoraApp> {
  @override
  void initState() {
    super.initState();
    // Check authentication status on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Determine initial route based on auth status
    String initialLocation;
    if (authState.isAuthenticated) {
      initialLocation = AppRouter.live;
    } else if (authState.isLoading) {
      initialLocation = AppRouter.splash;
    } else {
      initialLocation = AppRouter.login;
    }

    return MaterialApp.router(
      title: 'Streamora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router(
        authState.isAuthenticated,
        initialLocation: initialLocation,
        getAuthStatus: () => ref.read(authProvider).isAuthenticated,
      ),
    );
  }
}

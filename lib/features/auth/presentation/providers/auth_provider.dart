import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Provider for API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Provider for Flutter Secure Storage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
});

// Provider for Hive box
final userBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('userBoxProvider must be overridden');
});

// Provider for Auth Remote Data Source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

// Provider for Auth Local Data Source
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final userBox = ref.watch(userBoxProvider);
  return AuthLocalDataSourceImpl(
    secureStorage: secureStorage,
    userBox: userBox,
  );
});

// Provider for Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// Provider for Login Use Case
final loginUseCaseProvider = Provider<Login>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return Login(repository);
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Login _loginUseCase;
  final AuthRepository _authRepository;

  AuthNotifier(this._loginUseCase, this._authRepository)
      : super(const AuthState());

  Future<void> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    // Validate URL format
    if (!_isValidUrl(baseUrl)) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Invalid server URL format. Please use: http://example.com:port or https://example.com',
      );
      return;
    }

    final result = await _loginUseCase(
      LoginParams(
        baseUrl: baseUrl,
        username: username,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  String _mapFailureToMessage(dynamic failure) {
    final message = failure.message ?? 'Unknown error occurred';
    
    // Map common error messages to user-friendly ones
    if (message.contains('connection') || message.contains('SocketException')) {
      return 'Unable to connect to server. Please check your internet connection and try again.';
    }
    if (message.contains('timeout') || message.contains('TimeoutException')) {
      return 'Connection timed out. The server is taking too long to respond.';
    }
    if (message.contains('401') || message.contains('Unauthorized')) {
      return 'Invalid username or password. Please check your credentials.';
    }
    if (message.contains('403') || message.contains('Forbidden')) {
      return 'Access denied. Your account may have been suspended.';
    }
    if (message.contains('404') || message.contains('Not Found')) {
      return 'Server not found. Please check your server URL.';
    }
    if (message.contains('Active') || message.contains('status')) {
      return 'Your account is not active. Please contact your provider.';
    }
    if (message.contains('expired') || message.contains('expiry')) {
      return 'Your subscription has expired. Please renew with your provider.';
    }
    
    return message;
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    final result = await _authRepository.logout();
    
    result.fold(
      (failure) {
        // Even if local logout fails, clear the state
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
      (_) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
    );
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    
    final result = await _authRepository.isAuthenticated();
    
    result.fold(
      (failure) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      },
      (isAuthenticated) {
        if (isAuthenticated) {
          // Get cached user
          final userResult = _authRepository.getCurrentUser();
          userResult.fold(
            (_) {
              state = const AuthState(status: AuthStatus.unauthenticated);
            },
            (user) {
              if (user != null) {
                state = state.copyWith(
                  status: AuthStatus.authenticated,
                  user: user,
                );
              } else {
                state = const AuthState(status: AuthStatus.unauthenticated);
              }
            },
          );
        } else {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      },
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(loginUseCase, authRepository);
});

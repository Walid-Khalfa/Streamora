import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user, AuthCredentials? credentials) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final LoginUseCase _loginUseCase;
  late final LoginWithM3UUseCase _loginWithM3UUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  @override
  AuthState build() {
    final repository = ref.watch(authRepositoryProvider);
    _loginUseCase = LoginUseCase(repository);
    _loginWithM3UUseCase = LoginWithM3UUseCase(repository);
    _logoutUseCase = LogoutUseCase(repository);
    _checkAuthStatusUseCase = CheckAuthStatusUseCase(repository);

    // Check auth status on initialization
    _checkAuthStatus();
    return const AuthState.initial();
  }

  Future<void> _checkAuthStatus() async {
    final result = await _checkAuthStatusUseCase(const NoParams());
    result.fold(
      (failure) => state = const AuthState.unauthenticated(),
      (isAuthenticated) async {
        if (isAuthenticated) {
          final userResult = await ref.read(authRepositoryProvider).getCurrentUser();
          final credentialsResult = await ref.read(authRepositoryProvider).getStoredCredentials();
          
          userResult.fold(
            (failure) => state = const AuthState.unauthenticated(),
            (user) {
              credentialsResult.fold(
                (failure) => state = AuthState.authenticated(user!, null),
                (credentials) => state = AuthState.authenticated(user!, credentials),
              );
            },
          );
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> login({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await _loginUseCase(
      LoginParams(
        serverUrl: serverUrl,
        username: username,
        password: password,
      ),
    );

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        final credentials = AuthCredentials(
          serverUrl: serverUrl,
          username: username,
          password: password,
        );
        state = AuthState.authenticated(user, credentials);
      },
    );
  }

  Future<void> loginWithM3U({required String m3uUrl}) async {
    state = const AuthState.loading();

    final result = await _loginWithM3UUseCase(LoginWithM3UParams(m3uUrl: m3uUrl));

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) async {
        final credentialsResult = await ref.read(authRepositoryProvider).getStoredCredentials();
        credentialsResult.fold(
          (failure) => state = AuthState.authenticated(user, null),
          (credentials) => state = AuthState.authenticated(user, credentials),
        );
      },
    );
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }
}

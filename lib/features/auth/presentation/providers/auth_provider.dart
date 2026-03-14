import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';

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
  AuthNotifier() : super(const AuthState());

  Future<void> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // TODO: Implement actual authentication
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: User(
          username: username,
          password: password,
          baseUrl: baseUrl,
          status: 'Active',
          maxConnections: 2,
          activeConnections: 1,
          isTrial: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> checkAuthStatus() async {
    // TODO: Check if user is already authenticated
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

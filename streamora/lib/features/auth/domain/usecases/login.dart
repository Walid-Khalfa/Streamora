import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      serverUrl: params.serverUrl,
      username: params.username,
      password: params.password,
    );
  }
}

class LoginParams {
  final String serverUrl;
  final String username;
  final String password;

  const LoginParams({
    required this.serverUrl,
    required this.username,
    required this.password,
  });
}

class LoginWithM3UUseCase implements UseCase<User, LoginWithM3UParams> {
  final AuthRepository repository;

  LoginWithM3UUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginWithM3UParams params) async {
    return await repository.loginWithM3U(m3uUrl: params.m3uUrl);
  }
}

class LoginWithM3UParams {
  final String m3uUrl;

  const LoginWithM3UParams({required this.m3uUrl});
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

class CheckAuthStatusUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkAuthStatus();
  }
}

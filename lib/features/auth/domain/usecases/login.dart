import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String baseUrl;
  final String username;
  final String password;

  const LoginParams({
    required this.baseUrl,
    required this.username,
    required this.password,
  });
}

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      baseUrl: params.baseUrl,
      username: params.username,
      password: params.password,
    );
  }
}

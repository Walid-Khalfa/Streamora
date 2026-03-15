import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String serverUrl,
    required String username,
    required String password,
  });

  Future<Either<Failure, User>> loginWithM3U({
    required String m3uUrl,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, AuthCredentials?>> getStoredCredentials();

  Future<Either<Failure, void>> saveCredentials(AuthCredentials credentials);

  Future<Either<Failure, bool>> checkAuthStatus();
}

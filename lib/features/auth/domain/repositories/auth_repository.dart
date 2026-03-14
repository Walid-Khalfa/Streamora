import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<Either<Failure, User?>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, void>> saveCredentials({
    required String baseUrl,
    required String username,
    required String password,
  });

  Future<Either<Failure, Map<String, String>?>> getCredentials();
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.authenticate(
        baseUrl: baseUrl,
        username: username,
        password: password,
      );

      if (!user.isActive) {
        return Left(AuthenticationFailure(
          message: user.message ?? 'Account is not active',
        ));
      }

      await localDataSource.cacheUser(user);
      await localDataSource.saveCredentials(
        baseUrl: baseUrl,
        username: username,
        password: password,
      );

      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        code: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(AuthenticationFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get current user: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      await localDataSource.clearCredentials();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to logout: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user != null && user.isActive && !user.isExpired);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to check authentication: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveCredentials({
    required String baseUrl,
    required String username,
    required String password,
  }) async {
    try {
      await localDataSource.saveCredentials(
        baseUrl: baseUrl,
        username: username,
        password: password,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to save credentials: ${e.toString()}',
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>?>> getCredentials() async {
    try {
      final credentials = await localDataSource.getCredentials();
      return Right(credentials);
    } catch (e) {
      return Left(CacheFailure(
        message: 'Failed to get credentials: ${e.toString()}',
      ));
    }
  }
}

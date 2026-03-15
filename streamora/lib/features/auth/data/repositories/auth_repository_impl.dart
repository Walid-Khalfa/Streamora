import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      final user = await remoteDataSource.authenticate(
        baseUrl: serverUrl,
        username: username,
        password: password,
      );

      await localDataSource.cacheUser(user);
      await localDataSource.cacheCredentials(
        AuthCredentialsModel(
          serverUrl: serverUrl,
          username: username,
          password: password,
        ),
      );

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithM3U({required String m3uUrl}) async {
    // Parse M3U URL to extract server URL, username and password
    // M3U URL format: http://server:port/get.php?username=xxx&password=yyy&type=m3u_plus&output=ts
    try {
      final uri = Uri.parse(m3uUrl);
      final params = uri.queryParameters;

      final username = params['username'];
      final password = params['password'];

      if (username == null || password == null) {
        return const Left(ValidationFailure('Invalid M3U URL format'));
      }

      // Extract base server URL
      final serverUrl = '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';

      return await login(
        serverUrl: serverUrl,
        username: username,
        password: password,
      );
    } catch (e) {
      return Left(ValidationFailure('Failed to parse M3U URL: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCachedUser();
      await localDataSource.clearCachedCredentials();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthCredentials?>> getStoredCredentials() async {
    try {
      final credentials = await localDataSource.getCachedCredentials();
      return Right(credentials);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveCredentials(AuthCredentials credentials) async {
    try {
      await localDataSource.cacheCredentials(
        AuthCredentialsModel(
          serverUrl: credentials.serverUrl,
          username: credentials.username,
          password: credentials.password,
          m3uUrl: credentials.m3uUrl,
        ),
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> checkAuthStatus() async {
    try {
      final credentials = await localDataSource.getCachedCredentials();
      if (credentials == null) {
        return const Right(false);
      }

      if (!await networkInfo.isConnected) {
        // If offline, check if we have cached user data
        final user = await localDataSource.getCachedUser();
        return Right(user != null);
      }

      final isValid = await remoteDataSource.validateSession(
        baseUrl: credentials.serverUrl,
        username: credentials.username,
        password: credentials.password,
      );

      return Right(isValid);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  }) : super(code: null);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  }) : super(code: null);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
  }) : super(code: null);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({
    required super.message,
  }) : super(code: null);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
  }) : super(code: 401);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
  }) : super(code: 404);
}

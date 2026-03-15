import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}

class PaginationParams {
  final int page;
  final int limit;

  const PaginationParams({
    this.page = 1,
    this.limit = 20,
  });
}

class SearchParams {
  final String query;
  final int? categoryId;
  final String? type;

  const SearchParams({
    required this.query,
    this.categoryId,
    this.type,
  });
}

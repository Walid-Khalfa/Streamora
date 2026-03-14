import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, void>> addFavorite({
    required String type,
    required int id,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, void>> removeFavorite({
    required String type,
    required int id,
  });

  Future<Either<Failure, bool>> isFavorite({
    required String type,
    required int id,
  });

  Future<Either<Failure, List<Map<String, dynamic>>>> getFavorites(String type);

  Future<Either<Failure, void>> clearFavorites(String type);
}

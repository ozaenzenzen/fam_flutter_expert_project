import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, String>> saveWatchlist(ItemDataEntity itemDataEntity);
  Future<Either<Failure, String>> removeWatchlist(int id, int dataType);
  Future<bool> isAddedToWatchlist(int id, int dataType);
  Future<Either<Failure, List<Poster5Entity>>> getWatchlist();
}

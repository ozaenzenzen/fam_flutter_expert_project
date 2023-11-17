import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class GetWatchlist {
  final WatchlistRepository _repository;

  GetWatchlist(this._repository);

  Future<Either<Failure, List<Poster5Entity>>> execute() {
    return _repository.getWatchlist();
  }
}

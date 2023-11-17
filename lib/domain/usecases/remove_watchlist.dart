import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class RemoveWatchlist {
  final WatchlistRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(Poster2Entity data) {
    return repository.removeWatchlist(
      data.id,
      data.dataType.index,
    );
  }
}

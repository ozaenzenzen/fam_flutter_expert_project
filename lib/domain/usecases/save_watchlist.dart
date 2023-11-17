import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';

class SaveWatchlist {
  final WatchlistRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(ItemDataEntity itemDataEntity) {
    return repository.saveWatchlist(itemDataEntity);
  }
}

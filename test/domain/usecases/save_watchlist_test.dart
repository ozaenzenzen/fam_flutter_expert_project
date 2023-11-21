import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlist usecase;
  late WatchlistRepository repository;

  setUp(() {
    repository = MockWatchlistRepository();
    usecase = SaveWatchlist(repository);
  });

  test('should save movie to the repository', () async {
    // arrange
    final data = ItemDataEntity.fromMovie(testMovieDetail);
    when(repository.saveWatchlist(data)).thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(data);
    // assert
    verify(repository.saveWatchlist(data));
    expect(result, const Right('Added to Watchlist'));
  });
}

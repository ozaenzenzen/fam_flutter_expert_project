import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlist usecase;
  late WatchlistRepository watchlistRepository;

  setUp(() {
    watchlistRepository = MockWatchlistRepository();
    usecase = GetWatchlist(watchlistRepository);
  });

  test('should get list of watchlist from the repository', () async {
    // arrange
    final data = testMovieList;
    final expected = data.map((e) => Poster5Entity.fromMovie(e)).toList();
    when(watchlistRepository.getWatchlist()).thenAnswer((_) async => Right(expected));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(expected));
  });
}

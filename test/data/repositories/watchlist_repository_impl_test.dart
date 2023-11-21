import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:ditonton/data/models/watchlist_table.dart';
import 'package:ditonton/data/repositories/watchlist_repository_impl.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistLocalDataSource localDataSource;
  late WatchlistRepository repository;

  setUp(() {
    localDataSource = MockWatchlistLocalDataSource();
    repository = WatchlistRepositoryImpl(localDataSource);
  });

  const MovieDetailEntity source = testMovieDetail;
  final ItemDataEntity data = ItemDataEntity.fromMovie(source);
  final WatchlistTable table = testMovieTable;

  group('save watchlist action', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(localDataSource.insertWatchlist(table)).thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(data);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(localDataSource.insertWatchlist(testMovieTable)).thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(data);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist action', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(localDataSource.removeWatchlist(data.id, data.dataType.index)).thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(data.id, data.dataType.index);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(localDataSource.removeWatchlist(data.id, data.dataType.index)).thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(data.id, data.dataType.index);
      // assert
      expect(result, const  Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status action', () {
    test('should return watch status whether data is found', () async {
      // arrange
      when(localDataSource.getMovieById(data.id, data.dataType.index)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(data.id, data.dataType.index);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies action', () {
    test('should return list of Movies', () async {
      // arrange
      final expected = [Poster5Entity.fromMovie(testWatchlistMovie)];
      when(localDataSource.getWatchlistMovies()).thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlist();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, expected);
    });
  });
}

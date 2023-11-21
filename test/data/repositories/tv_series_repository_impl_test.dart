import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepository repository;
  late TvRemoteDataSource dataSource;

  String errorMessages = 'Failed to connect to the network';

  setUp(() {
    dataSource = MockTvRemoteDataSource();
    repository = TvSeriesRepositoryImpl(dataSource);
  });

  group('Popular TvSeriesModel', () {
    test(
        'should return popular list TvSeriesModel when call to remote data success',
        () async {
      //arrange
      final expected = tPopularTvSeriesList;

      when(dataSource.getPopularTvSeries()).thenAnswer((_) async => expected);

      //act
      final result = await repository.getPopularTvSeries();
      final actual = result.getOrElse(() => TvSeriesResponseModel());

      //assert
      verify(dataSource.getPopularTvSeries());

      expect(actual, expected);
    });

    test('should return ServerFailure when call remote data unsuccessful',
        () async {
      //arrange
      final failure = ServerFailure("server failed");
      final matcher = Left(failure);

      when(dataSource.getPopularTvSeries()).thenThrow(ServerException());

      //act
      final actual = await repository.getPopularTvSeries();

      //assert
      verify(dataSource.getPopularTvSeries());
      expect(actual, matcher);
    });

    test('should return ConnectionFailure when call remote data unsuccessful',
        () async {
      //arrange
      final failure = ConnectionFailure("connection failed");
      final matcher = Left(failure);

      when(dataSource.getPopularTvSeries())
          .thenThrow(SocketException(errorMessages));

      //act
      final actual = await repository.getPopularTvSeries();

      //assert
      verify(dataSource.getPopularTvSeries());
      expect(actual, matcher);
    });

    test('should return UnknownFailure when throw Exception', () async {
      //arrange
      final failure = UnknownFailure();
      final matcher = Left(failure);

      when(dataSource.getPopularTvSeries()).thenThrow(Exception());

      //act
      final actual = await repository.getPopularTvSeries();

      //assert
      verify(dataSource.getPopularTvSeries());
      expect(actual, matcher);
    });
  });

  group('on the air TvSeries', () {
    test(
        'should return on the air tv series list when call to remote data success',
        () async {
      //arrange
      final expected = tOnTheAirTvSeriesList;

      when(dataSource.getOnTheAirTvSeries()).thenAnswer((_) async => expected);

      //act
      final result = await repository.getOnTheAirTvSeries();
      final actual = result.getOrElse(() => TvSeriesResponseModel());

      //assert
      verify(dataSource.getOnTheAirTvSeries());
      expect(actual, expected);
    });

    test(
        'should return ServerFailure when call remote data source unsuccessful',
        () async {
      //arrange
      final failure = ServerFailure("server failed");
      final matcher = Left(failure);

      when(dataSource.getOnTheAirTvSeries()).thenThrow((ServerException()));

      //act
      final actual = await repository.getOnTheAirTvSeries();

      //assert
      verify(dataSource.getOnTheAirTvSeries());
      expect(actual, matcher);
    });

    test('should return ConnectionFailure when trow SocketException', () async {
      //arrange
      final failure = ConnectionFailure("connection failed");
      final matcher = Left(failure);

      when(dataSource.getOnTheAirTvSeries())
          .thenThrow((SocketException(errorMessages)));

      //act
      final actual = await repository.getOnTheAirTvSeries();

      //assert
      verify(dataSource.getOnTheAirTvSeries());
      expect(actual, matcher);
    });

    test('should return UnknownFailure when throw Exception', () async {
      //arrange
      final failure = UnknownFailure();
      final matcher = Left(failure);

      when(dataSource.getOnTheAirTvSeries()).thenThrow(Exception());

      //act
      final actual = await repository.getOnTheAirTvSeries();

      //assert
      verify(dataSource.getOnTheAirTvSeries());
      expect(actual, matcher);
    });
  });

  group('Top Rated TvSeries', () {
    test(
        'should return top rated tv series list when call to remote data success',
        () async {
      //arrange
      final expected = tTopRatedSeriesList;

      when(dataSource.getTopRatedTvSeries()).thenAnswer((_) async => expected);

      //act
      final result = await repository.getTopRatedTvSeries();
      final actual = result.getOrElse(() => TvSeriesResponseModel());

      //assert
      verify(dataSource.getTopRatedTvSeries());
      expect(actual, expected);
    });

    test(
        'should return ServerFailure when call remote data source unsuccessful',
        () async {
      //arrange
      final failure = ServerFailure("server failed");
      final matcher = Left(failure);

      when(dataSource.getTopRatedTvSeries()).thenThrow((ServerException()));

      //act
      final actual = await repository.getTopRatedTvSeries();

      //assert
      verify(dataSource.getTopRatedTvSeries());
      expect(actual, matcher);
    });

    test('should return ConnectionFailure when trow SocketException', () async {
      //arrange
      final failure = ConnectionFailure("connection failed");
      final matcher = Left(failure);

      when(dataSource.getTopRatedTvSeries())
          .thenThrow((SocketException(errorMessages)));

      //act
      final actual = await repository.getTopRatedTvSeries();

      //assert
      verify(dataSource.getTopRatedTvSeries());
      expect(actual, matcher);
    });

    test('should return UnknownFailure when throw Exception', () async {
      //arrange
      final failure = UnknownFailure();
      final matcher = Left(failure);

      when(dataSource.getOnTheAirTvSeries()).thenThrow(Exception());

      //act
      final actual = await repository.getOnTheAirTvSeries();

      //assert
      verify(dataSource.getOnTheAirTvSeries());
      expect(actual, matcher);
    });
  });

  group('Seach TvSeries', () {
    final tQuery = 'phoenix';

    test('should return tv series list when call to data source is successful',
        () async {
      // arrange
      final expected = tSearchTvSeriesList;

      when(dataSource.searchTvSeries(tQuery)).thenAnswer((_) async => expected);
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => TvSeriesResponseModel());
      expect(resultList, expected);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(dataSource.searchTvSeries(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure("server failed")));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(dataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException(errorMessages));
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(result, Left(ConnectionFailure("connection failed")));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = tTvDetail.id;
    final response = tTvDetail;

    test(
        'should return tv detail data when the call to remote data source is successful',
        () async {
      // arrange
      when(dataSource.getTvSeriesDetail(tId!)).thenAnswer((_) async => response);
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(dataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(response)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(dataSource.getTvSeriesDetail(tId!)).thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(dataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure("server failed"))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(dataSource.getTvSeriesDetail(tId!))
          .thenThrow(SocketException(errorMessages));
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(dataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ConnectionFailure("connection failed"))));
    });
  });

  group('Get Movie Recommendations', () {
    final tId = tTvDetail.id;

    test('should return data (tv series list) when the call is successful',
        () async {
      // arrange
      final response = tTvRecommendationList;
      when(dataSource.getTvSeriesRecommendation(tId!))
          .thenAnswer((_) async => response);
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assert
      verify(dataSource.getTvSeriesRecommendation(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => TvSeriesResponseModel());
      expect(resultList, equals(response));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(dataSource.getTvSeriesRecommendation(tId!))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assertbuild runner
      verify(dataSource.getTvSeriesRecommendation(tId));
      expect(result, equals(Left(ServerFailure("server failed"))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(dataSource.getTvSeriesRecommendation(tId!))
          .thenThrow(SocketException(errorMessages));
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assert
      verify(dataSource.getTvSeriesRecommendation(tId));
      expect(result, equals(Left(ConnectionFailure("connection failed"))));
    });
  });
}

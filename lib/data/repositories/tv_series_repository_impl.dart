import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/tvseries_entity.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl extends TvSeriesRepository {
  final TvRemoteDataSource _dataSource;

  TvSeriesRepositoryImpl(this._dataSource);
  
  @override
  Future<Either<Failure, List<TvSeriesEntity>>> getOnTheAirTvSeries() async {
     try {
      final result = await _dataSource.getOnTheAirTvSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<TvSeriesEntity>>> getPopularTvSeries() async {
    try {
      final result = await _dataSource.getPopularTvSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<TvSeriesEntity>>> getTopRatedTvSeries()  async {
    try {
      final result = await _dataSource.getTopRatedTvSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, ItemDataEntity>> getTvSeriesDetail(int id) async {
    try {
      final result = await _dataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<TvSeriesEntity>>> getTvSeriesRecommendation(int id) async {
    try {
      final result = await _dataSource.getTvSeriesRecommendation(id);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<TvSeriesEntity>>> searchTvSeries(String keyword) async {
    try {
      final result = await _dataSource.searchTvSeries(keyword);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure("Server Failure"));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}

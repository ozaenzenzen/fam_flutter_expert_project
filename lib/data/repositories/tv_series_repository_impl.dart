import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl extends TvSeriesRepository {
  TvRemoteDataSource _dataSource;

  TvSeriesRepositoryImpl(this._dataSource);
  
  @override
  Future<Either<Failure, TvSeriesResponseModel>> getOnTheAirTvSeries() async {
     try {
      final result = await _dataSource.getOnTheAirTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, TvSeriesResponseModel>> getPopularTvSeries() async {
    try {
      final result = await _dataSource.getPopularTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, TvSeriesResponseModel>> getTopRatedTvSeries()  async {
    try {
      final result = await _dataSource.getTopRatedTvSeries();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, TvDetailResponseModel>> getTvSeriesDetail(int id) async {
    try {
      final result = await _dataSource.getTvSeriesDetail(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, TvSeriesResponseModel>> getTvSeriesRecommendation(int id) async {
    try {
      final result = await _dataSource.getTvSeriesRecommendation(id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
  
  @override
  Future<Either<Failure, TvSeriesResponseModel>> searchTvSeries(String keyword) async {
    try {
      final result = await _dataSource.searchTvSeries(keyword);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure("Server failure"));
    } on SocketException {
      return Left(ConnectionFailure("Failed to connection to the network"));
    } catch (e) {
      return Left(UnknownFailure());
    }
  }
}

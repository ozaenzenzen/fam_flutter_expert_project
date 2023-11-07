import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, TvSeriesResponseModel>> getOnTheAirTvSeries();
  Future<Either<Failure, TvSeriesResponseModel>> getPopularTvSeries();
  Future<Either<Failure, TvSeriesResponseModel>> getTopRatedTvSeries();
  Future<Either<Failure, TvSeriesResponseModel>> searchTvSeries(String keyword);
  Future<Either<Failure, TvDetailResponseModel>> getTvSeries(int id);
  Future<Either<Failure, TvSeriesResponseModel>> getTvSeriesRecommendation(int id);
}

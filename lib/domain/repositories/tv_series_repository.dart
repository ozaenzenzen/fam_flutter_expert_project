import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/tvseries_entity.dart';
// import 'package:ditonton/data/models/tv_detail_response_model.dart';
// import 'package:ditonton/data/models/tv_series_response_model.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeriesEntity>>> getOnTheAirTvSeries();
  Future<Either<Failure, List<TvSeriesEntity>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeriesEntity>>> getTopRatedTvSeries();
  Future<Either<Failure, List<TvSeriesEntity>>> searchTvSeries(String keyword);
  Future<Either<Failure, ItemDataEntity>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeriesEntity>>> getTvSeriesRecommendation(int id);
  // Future<Either<Failure, TvSeriesResponseModel>> getOnTheAirTvSeries();
  // Future<Either<Failure, TvSeriesResponseModel>> getPopularTvSeries();
  // Future<Either<Failure, TvSeriesResponseModel>> getTopRatedTvSeries();
  // Future<Either<Failure, TvSeriesResponseModel>> searchTvSeries(String keyword);
  // Future<Either<Failure, TvDetailResponseModel>> getTvSeriesDetail(int id);
  // Future<Either<Failure, TvSeriesResponseModel>> getTvSeriesRecommendation(int id);
}

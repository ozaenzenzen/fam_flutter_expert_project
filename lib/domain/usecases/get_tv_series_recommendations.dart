import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendations(this.repository);

  Future<Either<Failure, TvSeriesResponseModel>> execute(id) {
    return repository.getTvSeriesRecommendation(id);
  }
}

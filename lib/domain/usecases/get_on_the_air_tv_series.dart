import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetOnTheAirTvSeries {
  final TvSeriesRepository repository;

  GetOnTheAirTvSeries(this.repository);

  Future<Either<Failure, TvSeriesResponseModel>> execute() {
    return repository.getOnTheAirTvSeries();
  }
}

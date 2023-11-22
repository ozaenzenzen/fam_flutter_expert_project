import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tvseries_entity.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetOnTheAirTvSeries {
  final TvSeriesRepository repository;

  GetOnTheAirTvSeries(this.repository);

  Future<Either<Failure, List<TvSeriesEntity>>> execute() {
    return repository.getOnTheAirTvSeries();
  }
}

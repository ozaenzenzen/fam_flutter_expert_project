import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:equatable/equatable.dart';

class Params5Entity extends Equatable {
  final int id;
  final String poster;
  final String title;
  final String overview;
  final DataType dataType;

  Params5Entity(
    this.id,
    this.poster,
    this.title,
    this.overview, {
    required this.dataType,
  });

  factory Params5Entity.fromMovie(MovieEntity movie) => Params5Entity(
        movie.id,
        movie.posterPath ?? "",
        movie.title ?? "No Title",
        movie.overview ?? "No Overview",
        dataType: DataType.Movie,
      );

  factory Params5Entity.fromMovieDetail(MovieDetailEntity movieDetail) => Params5Entity(
        movieDetail.id,
        movieDetail.posterPath,
        movieDetail.title,
        movieDetail.overview,
        dataType: DataType.Movie,
      );

  factory Params5Entity.fromTvSeries(ResultTvSeries tvSeries) => Params5Entity(
        tvSeries.id!,
        tvSeries.posterPath ?? "",
        tvSeries.name!,
        tvSeries.overview!,
        dataType: DataType.TvSeries,
      );

  @override
  List<Object?> get props => [
        id,
        poster,
        title,
        overview,
      ];
}

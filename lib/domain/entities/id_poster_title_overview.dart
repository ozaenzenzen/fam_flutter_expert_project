import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:equatable/equatable.dart';

class IdPosterTitleOverview extends Equatable {
  final int id;
  final String poster;
  final String title;
  final String overview;
  final DataType dataType;

  IdPosterTitleOverview({
    required this.id,
    required this.poster,
    required this.title,
    required this.overview,
    required this.dataType,
  });

  factory IdPosterTitleOverview.fromMovie(MovieEntity movie) => IdPosterTitleOverview(
        id: movie.id,
        poster: movie.posterPath ?? "",
        title: movie.title ?? "No Title",
        overview: movie.overview ?? "No Overview",
        dataType: DataType.Movie,
      );

  factory IdPosterTitleOverview.fromMovieDetail(MovieDetailEntity movieDetail) => IdPosterTitleOverview(
        id: movieDetail.id,
        poster: movieDetail.posterPath,
        title: movieDetail.title,
        overview: movieDetail.overview,
        dataType: DataType.Movie,
      );

  factory IdPosterTitleOverview.fromTvSeries(ResultTvSeries tvSeries) => IdPosterTitleOverview(
        id: tvSeries.id!,
        poster: tvSeries.posterPath ?? "",
        title: tvSeries.name!,
        overview: tvSeries.overview!,
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

import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:equatable/equatable.dart';

class Poster5Entity extends Equatable {
  final int id;
  final String poster;
  final String title;
  final String overview;
  final DataType dataType;

  const Poster5Entity({
    required this.id,
    required this.poster,
    required this.title,
    required this.overview,
    required this.dataType,
  });

  factory Poster5Entity.fromMovie(MovieEntity movie) => Poster5Entity(
        id: movie.id,
        poster: movie.posterPath ?? "",
        title: movie.title ?? "No Title",
        overview: movie.overview ?? "No Overview",
        dataType: DataType.movie,
      );

  factory Poster5Entity.fromMovieDetail(MovieDetailEntity movieDetail) => Poster5Entity(
        id: movieDetail.id,
        poster: movieDetail.posterPath,
        title: movieDetail.title,
        overview: movieDetail.overview,
        dataType: DataType.movie,
      );

  factory Poster5Entity.fromTvSeries(ResultTvSeries tvSeries) => Poster5Entity(
        id: tvSeries.id!,
        poster: tvSeries.posterPath ?? "",
        title: tvSeries.name!,
        overview: tvSeries.overview!,
        dataType: DataType.tvSeries,
      );

  @override
  List<Object?> get props => [
        id,
        poster,
        title,
        overview,
      ];
}

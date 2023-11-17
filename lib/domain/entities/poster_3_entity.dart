import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:equatable/equatable.dart';

class Poster3Entity extends Equatable {
  final int id;
  final String poster;
  final DataType dataType;

  Poster3Entity({
    required this.id,
    required this.poster,
    required this.dataType,
  });

  factory Poster3Entity.fromMovie(MovieEntity movie) => Poster3Entity(
        id: movie.id,
        poster: movie.posterPath ?? "",
        dataType: DataType.Movie,
      );

  factory Poster3Entity.fromTvSeries(ResultTvSeries tvSeries) => Poster3Entity(
        id: tvSeries.id!,
        poster: tvSeries.posterPath ?? "",
        dataType: DataType.TvSeries,
      );

  factory Poster3Entity.fromPoster5Entity(Poster5Entity poster5Entity) => Poster3Entity(
        id: poster5Entity.id,
        poster: poster5Entity.poster,
        dataType: poster5Entity.dataType,
      );

  @override
  List<Object?> get props => [id, poster];
}

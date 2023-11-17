import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:equatable/equatable.dart';

class IdPosterDataType extends Equatable {
  final int id;
  final String poster;
  final DataType dataType;

  IdPosterDataType({
    required this.id,
    required this.poster,
    required this.dataType,
  });

  factory IdPosterDataType.fromMovie(MovieEntity movie) => IdPosterDataType(
        id: movie.id,
        poster: movie.posterPath ?? "",
        dataType: DataType.Movie,
      );

  factory IdPosterDataType.fromTvSeries(ResultTvSeries tvSeries) => IdPosterDataType(
        id: tvSeries.id!,
        poster: tvSeries.posterPath ?? "",
        dataType: DataType.TvSeries,
      );

  factory IdPosterDataType.fromIdPosterTitleOverview(IdPosterTitleOverview idPosterTitleOverview) => IdPosterDataType(
        id: idPosterTitleOverview.id,
        poster: idPosterTitleOverview.poster,
        dataType: idPosterTitleOverview.dataType,
      );

  @override
  List<Object?> get props => [id, poster];
}

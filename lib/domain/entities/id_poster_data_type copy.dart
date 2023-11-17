import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:equatable/equatable.dart';

class Params3Entity extends Equatable {
  final int id;
  final String poster;
  final DataType dataType;

  Params3Entity(this.id, this.poster, this.dataType);

  factory Params3Entity.fromMovie(MovieEntity movie) => Params3Entity(
        movie.id,
        movie.posterPath ?? "",
        DataType.Movie,
      );

  factory Params3Entity.fromTvSeries(ResultTvSeries tvSeries) => Params3Entity(
        tvSeries.id!,
        tvSeries.posterPath ?? "",
        DataType.TvSeries,
      );

  factory Params3Entity.fromIdPosterTitleOverview(IdPosterTitleOverview idPosterTitleOverview) => Params3Entity(
        idPosterTitleOverview.id,
        idPosterTitleOverview.poster,
        idPosterTitleOverview.dataType,
      );

  @override
  List<Object?> get props => [id, poster];
}

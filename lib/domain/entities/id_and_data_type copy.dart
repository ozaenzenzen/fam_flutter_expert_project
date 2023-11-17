import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';

class Params2Entity {
  int id;
  DataType dataType;

  Params2Entity(this.id, this.dataType);

  factory Params2Entity.from(IdPosterTitleOverview idPosterTitleOverview) => Params2Entity(
        idPosterTitleOverview.id,
        idPosterTitleOverview.dataType,
      );

  factory Params2Entity.fromMovie(MovieEntity movie) => Params2Entity(
        movie.id,
        DataType.Movie,
      );

  factory Params2Entity.fromIdPosterDataType(IdPosterDataType idPosterDataType) => Params2Entity(
        idPosterDataType.id,
        idPosterDataType.dataType,
      );
}

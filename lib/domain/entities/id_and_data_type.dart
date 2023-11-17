import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';

class IdAndDataType {
  int id;
  DataType dataType;

  IdAndDataType(this.id, this.dataType);

  factory IdAndDataType.from(IdPosterTitleOverview idPosterTitleOverview) => IdAndDataType(
        idPosterTitleOverview.id,
        idPosterTitleOverview.dataType,
      );

  factory IdAndDataType.fromMovie(MovieEntity movie) => IdAndDataType(
        movie.id,
        DataType.Movie,
      );

  factory IdAndDataType.fromIdPosterDataType(IdPosterDataType idPosterDataType) => IdAndDataType(
        idPosterDataType.id,
        idPosterDataType.dataType,
      );
}

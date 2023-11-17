import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/id_poster_title_overview.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';

class IdAndDataType {
  int id;
  DataType dataType;

  IdAndDataType({
    required this.id,
    required this.dataType,
  });

  factory IdAndDataType.from(IdPosterTitleOverview idPosterTitleOverview) => IdAndDataType(
        id: idPosterTitleOverview.id,
        dataType: idPosterTitleOverview.dataType,
      );

  factory IdAndDataType.fromMovie(MovieEntity movie) => IdAndDataType(
        id: movie.id,
        dataType: DataType.Movie,
      );

  factory IdAndDataType.fromIdPosterDataType(IdPosterDataType idPosterDataType) => IdAndDataType(
        id: idPosterDataType.id,
        dataType: idPosterDataType.dataType,
      );
}

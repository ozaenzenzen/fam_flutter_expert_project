import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';

class Poster2Entity {
  int id;
  DataType dataType;

  Poster2Entity({
    required this.id,
    required this.dataType,
  });

  factory Poster2Entity.from(Poster5Entity poster5Entity) => Poster2Entity(
        id: poster5Entity.id,
        dataType: poster5Entity.dataType,
      );

  factory Poster2Entity.fromMovie(MovieEntity movie) => Poster2Entity(
        id: movie.id,
        dataType: DataType.Movie,
      );

  factory Poster2Entity.fromPoster3Entity(Poster3Entity poster3Entity) => Poster2Entity(
        id: poster3Entity.id,
        dataType: poster3Entity.dataType,
      );
}

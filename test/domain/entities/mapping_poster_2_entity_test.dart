import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final testPoster2EntityFromMovie = Poster2Entity.fromMovie(testMovie);

  final testPoster2EntityFromPoster5Entity = Poster2Entity.from(
    Poster5Entity(
      id: testMovie.id,
      poster: testMovie.posterPath!,
      title: testMovie.title!,
      overview: testMovie.overview!,
      dataType: DataType.movie,
    ),
  );

  final testPoster2EntityFromPoster3Entity = Poster2Entity.fromPoster3Entity(
    Poster3Entity(
      id: testMovie.id,
      poster: testMovie.posterPath!,
      dataType: DataType.movie,
    ),
  );

  group("test poster 2 entity all", () {
    test('should get Poster2Entity from the movie', () async {
      final result = testPoster2EntityFromMovie;
      expect(testPoster2EntityBaseData.toString(), result.toString());
    });

    test('should get Poster2Entity from the Poster5Entity', () async {
      final result = testPoster2EntityFromPoster5Entity;
      expect(testPoster2EntityBaseData.toString(), result.toString());
    });

    test('should get Poster2Entity from the Poster3Entity', () async {
      final result = testPoster2EntityFromPoster3Entity;
      expect(testPoster2EntityBaseData.toString(), result.toString());
    });
  });
}

import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const testMovieModelData = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3, 4, 5],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'spiderman',
    video: false,
    voteAverage: 1,
    voteCount: 25,
  );

  final testMovieData = MovieEntity(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3, 4, 5],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'spiderman',
    video: false,
    voteAverage: 1,
    voteCount: 25,
  );

  test('mapping to subclass of Movie entity', () async {
    final result = testMovieModelData.toEntity();
    expect(result, testMovieData);
  });
}

import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  const int testId = 1;
  final tMovies = <MovieEntity>[];

  test('should get list of movie recommendations from the repository',
      () async {
    // arrange
    when(mockMovieRepository.getMovieRecommendations(testId))
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(testId);
    // assert
    expect(result, Right(tMovies));
  });
}

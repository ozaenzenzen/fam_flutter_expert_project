import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMovies getPopularMovies;
  late PopularMovieBloc bloc;

  setUp(() {
    getPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieBloc(getPopularMovies);
  });

  final MovieEntity tMovie = testMovie;
  final List<MovieEntity> tMovieList = <MovieEntity>[tMovie];
  final List<Poster5Entity> expected = tMovieList.map((e) => Poster5Entity.fromMovie(e)).toList();

  test(
    'inital state should be [PopularMovieInitial]',
    () {
      expect(bloc.state, PopularMovieInitial());
    },
  );

  blocTest(
    'emit [Loading, HasData] when data is gotten succesful',
    build: () {
      when(getPopularMovies.execute()).thenAnswer(
        (realInvocation) async => Right(tMovieList),
      );
      return bloc;
    },
    act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieSuccess(expected),
    ],
    verify: (PopularMovieBloc bloc) {
      verify(getPopularMovies.execute());
    },
  );

  blocTest(
    'emit [Loading, Error] when data is gotten succesful',
    build: () {
      when(getPopularMovies.execute()).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      return bloc;
    },
    act: (PopularMovieBloc bloc) => bloc.add(OnPopularMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (PopularMovieBloc bloc) {
      verify(getPopularMovies.execute());
    },
  );
}

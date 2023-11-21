import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late GetTopRatedMovies getTopRatedMovies;
  late TopRatedMovieBloc bloc;

  setUp(() {
    getTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMovieBloc(getTopRatedMovies);
  });

  final data = [testMovie];
  final expected = data.map((e) => Poster5Entity.fromMovie(e)).toList();

  test(
    'inital state should be [TopRatedMovieInitial]',
    () {
      expect(bloc.state, TopRatedMovieInitial());
    },
  );

  blocTest(
    'emit [Loading, Succes] when data is gotten succesful',
    build: () {
      when(getTopRatedMovies.execute()).thenAnswer(
        (realInvocation) async => Right(data),
      );
      return bloc;
    },
    act: (TopRatedMovieBloc bloc) => bloc.add(OnTopRatedMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieSuccess(expected),
    ],
    verify: (TopRatedMovieBloc bloc) {
      verify(getTopRatedMovies.execute());
    },
  );

  blocTest(
    'emit [Loading, Error] when server failure',
    build: () {
      when(getTopRatedMovies.execute()).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      return bloc;
    },
    act: (TopRatedMovieBloc bloc) => bloc.add(OnTopRatedMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (TopRatedMovieBloc bloc) {
      verify(getTopRatedMovies.execute());
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late GetNowPlayingMovies getNowPlayingMovies;
  late NowPlayingMovieBloc bloc;

  setUp(() {
    getNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMovieBloc(getNowPlayingMovies);
  });

  final MovieEntity testMovieModel = testMovie;
  final List<MovieEntity> testMovieList = [testMovieModel];
  final List<Poster5Entity> expected = testMovieList.map((e) => Poster5Entity.fromMovie(e)).toList();

  test(
    'inital state should be [NowPlayingMovieInitial]',
    () {
      expect(bloc.state, NowPlayingMovieInitial());
    },
  );

  blocTest(
    'emit [Loading, Success] when data is gotten succesful',
    build: () {
      when(getNowPlayingMovies.execute()).thenAnswer(
        (realInvocation) async => Right(testMovieList),
      );
      return bloc;
    },
    act: (NowPlayingMovieBloc bloc) => bloc.add(OnNowPlayingMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieSuccess(expected),
    ],
    verify: (NowPlayingMovieBloc bloc) {
      verify(getNowPlayingMovies.execute());
    },
  );

  blocTest(
    'emit [Loading, Error] when data is unsuccesful',
    build: () {
      when(getNowPlayingMovies.execute()).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      return bloc;
    },
    act: (NowPlayingMovieBloc bloc) => bloc.add(OnNowPlayingMovieDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (NowPlayingMovieBloc bloc) {
      verify(getNowPlayingMovies.execute());
    },
  );
}

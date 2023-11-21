import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
])
void main() {
  late GetMovieDetail getMovieDetail;
  late GetMovieRecommendations getMovieRecommendations;
  late MovieDetailBloc bloc;

  setUp(() {
    getMovieDetail = MockGetMovieDetail();
    getMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieDetailBloc(getMovieDetail, getMovieRecommendations);
  });

  const MovieDetailEntity movieDetail = testMovieDetail;
  final int testId = movieDetail.id;
  final ItemDataEntity itemDataEntity = ItemDataEntity.fromMovie(movieDetail);
  final List<MovieEntity> listMovieEntity = [testMovie];
  final List<Poster3Entity> expectedRecommendation = listMovieEntity.map((e) => Poster3Entity.fromMovie(e)).toList();

  test(
    'inital state should be [MovieDetailInitial]',
    () {
      expect(bloc.state, MovieDetailInitial());
    },
  );

  blocTest(
    'emit [Loading, Success] when data is gotten succesful',
    build: () {
      when(getMovieDetail.execute(testId)).thenAnswer(
        (realInvocation) async => const Right(movieDetail),
      );
      when(getMovieRecommendations.execute(testId)).thenAnswer(
        (realInvocation) async => Right(listMovieEntity),
      );

      return bloc;
    },
    act: (MovieDetailBloc bloc) => bloc.add(OnMovieDetailDataRequested(testId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailSuccess(
        itemDataEntity,
        recommendations: expectedRecommendation,
      ),
    ],
    verify: (MovieDetailBloc bloc) {
      verify(getMovieDetail.execute(testId));
      verify(getMovieRecommendations.execute(testId));
    },
  );

  blocTest(
    'emit [Loading, ErrorRecommendation, Success] when data is gotten succesful',
    build: () {
      when(getMovieDetail.execute(testId)).thenAnswer(
        (realInvocation) async => const Right(movieDetail),
      );
      when(getMovieRecommendations.execute(testId)).thenAnswer(
        (realInvocation) async => const Left(ServerFailure("Server Failure")),
      );

      return bloc;
    },
    act: (MovieDetailBloc bloc) => bloc.add(OnMovieDetailDataRequested(testId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError(
        'Server Failure',
        retry: () {},
      ),
      MovieDetailSuccess(itemDataEntity),
    ],
    verify: (MovieDetailBloc bloc) {
      verify(getMovieDetail.execute(testId));
      verify(getMovieRecommendations.execute(testId));
    },
  );

  blocTest(
    'emit [Loading, Success] when data is gotten succesful',
    build: () {
      when(getMovieRecommendations.execute(testId)).thenAnswer(
        (realInvocation) async => Right(listMovieEntity),
      );
      return bloc;
    },
    act: (MovieDetailBloc bloc) => bloc.add(OnMovieRecommendationsRequested(itemDataEntity)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailSuccess(
        itemDataEntity,
        recommendations: expectedRecommendation,
      ),
    ],
    verify: (MovieDetailBloc bloc) {
      verify(getMovieRecommendations.execute(testId));
    },
  );
}

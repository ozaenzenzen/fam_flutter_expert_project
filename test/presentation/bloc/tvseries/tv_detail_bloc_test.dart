import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail, GetTvSeriesRecommendations])
void main() {
  late GetTvSeriesDetail getTvSeriesDetail;
  late GetTvSeriesRecommendations getTvSeriesRecommendations;
  late TvDetailBloc bloc;

  final TvDetailResponseModel detailData = testTvDetail;
  final int testId = detailData.id!;
  // final ItemDataEntity itemDataEntity = ItemDataEntity.fromTvSeries(detailData);
  final ItemDataEntity itemDataEntity = detailData.toEntity();
  final TvSeriesResponseModel recommendationData = testTvRecommendationList;
  final List<Poster3Entity> recommendationExpected = recommendationData.results!.map((e) => Poster3Entity.fromTvSeries(e.toEntity())).toList();

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    bloc = TvDetailBloc(
      getTvSeriesDetail,
      getTvSeriesRecommendations,
    );
  });

  test('inital state should be [TvDetailInitial]', () {
    expect(bloc.state, TvDetailInitial());
  });

  blocTest(
    'emit [Loading, Success] when data is gotten succesful',
    build: () {
      when(getTvSeriesDetail.execute(testId)).thenAnswer(
        (realInvocation) async => Right(detailData.toEntity()),
      );
      when(getTvSeriesRecommendations.execute(testId)).thenAnswer(
        (_) async => Right(recommendationData.toEntity()),
      );

      return bloc;
    },
    act: (TvDetailBloc bloc) => bloc.add(OnTvDetailDataRequested(testId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailSuccess(
        itemDataEntity,
        recommendations: recommendationExpected,
      ),
    ],
    verify: (TvDetailBloc bloc) {
      verify(
        getTvSeriesDetail.execute(testId),
      );
      verify(
        getTvSeriesRecommendations.execute(testId),
      );
    },
  );

  blocTest(
    'emit [Loading, Success, Error] when data is gotten succesful',
    build: () {
      when(getTvSeriesDetail.execute(testId)).thenAnswer(
        (realInvocation) async => Right(detailData.toEntity()),
      );
      when(getTvSeriesRecommendations.execute(testId)).thenAnswer(
        (_) async => const Left(ServerFailure("Server Failure")),
      );

      return bloc;
    },
    act: (TvDetailBloc bloc) => bloc.add(
      OnTvDetailDataRequested(testId),
    ),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailError(
        'Server Failure',
        retry: () {},
      ),
      TvDetailSuccess(itemDataEntity),
    ],
    verify: (TvDetailBloc bloc) {
      verify(
        getTvSeriesDetail.execute(testId),
      );
      verify(getTvSeriesRecommendations.execute(testId));
    },
  );

  blocTest(
    'emit [Loading, Error] when data is gotten succesful',
    build: () {
      when(getTvSeriesDetail.execute(testId)).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      when(getTvSeriesRecommendations.execute(testId)).thenAnswer(
        (_) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );

      return bloc;
    },
    act: (TvDetailBloc bloc) => bloc.add(
      OnTvDetailDataRequested(testId),
    ),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (TvDetailBloc bloc) {
      verify(
        getTvSeriesDetail.execute(testId),
      );
      verify(
        getTvSeriesRecommendations.execute(testId),
      );
    },
  );
}

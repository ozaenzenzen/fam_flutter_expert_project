import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail, GetTvSeriesRecommendations])
void main() {
  late GetTvSeriesDetail getTvSeriesDetail;
  late GetTvSeriesRecommendations getTvSeriesRecommendations;
  late TvDetailBloc bloc;

  final detailData = testTvDetail;
  final tId = detailData.id;
  final detailExpected = ItemDataEntity.fromTvSeries(detailData);
  final recommendationData = testTvRecommendationList;
  final recommendationExpected = recommendationData.results!.map((e) => Poster3Entity.fromTvSeries(e)).toList();

  setUp(() {
    getTvSeriesDetail = MockGetTvSeriesDetail();
    getTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    bloc = TvDetailBloc(
      getTvSeriesDetail,
      getTvSeriesRecommendations,
    );
  });

  test('inital state should be empty', () {
    expect(bloc.state, TvDetailInitial());
  });

  blocTest('Should emit [Loading, Success] when data is gotten succesful',
      build: () {
        when(getTvSeriesDetail.execute(tId!)).thenAnswer(
          (realInvocation) async => Right(detailData),
        );
        when(getTvSeriesRecommendations.execute(tId)).thenAnswer(
          (_) async => Right(recommendationData),
        );

        return bloc;
      },
      act: (TvDetailBloc bloc) => bloc.add(OnTvDetailDataRequested(tId!)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvDetailLoading(),
            TvDetailSuccess(
              detailExpected,
              recommendations: recommendationExpected,
            ),
          ],
      verify: (TvDetailBloc bloc) {
        verify(
          getTvSeriesDetail.execute(tId!),
        );
        verify(
          getTvSeriesRecommendations.execute(tId),
        );
      });

  blocTest('Should emit [Loading, Success, Error] when data is gotten succesful',
      build: () {
        when(getTvSeriesDetail.execute(tId!)).thenAnswer(
          (realInvocation) async => Right(detailData),
        );
        when(getTvSeriesRecommendations.execute(tId)).thenAnswer(
          (_) async => const Left(ServerFailure("Server Failure")),
        );

        return bloc;
      },
      act: (TvDetailBloc bloc) => bloc.add(
            OnTvDetailDataRequested(tId!),
          ),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TvDetailLoading(),
            TvDetailError('Server Failure', retry: () {}),
            TvDetailSuccess(detailExpected),
          ],
      verify: (TvDetailBloc bloc) {
        verify(
          getTvSeriesDetail.execute(tId!),
        );
        verify(getTvSeriesRecommendations.execute(tId));
      });

  blocTest('Should emit [Loading, Error] when data is gotten succesful',
      build: () {
        when(getTvSeriesDetail.execute(tId!)).thenAnswer(
          (realInvocation) async => const Left(
            ServerFailure("Server Failure"),
          ),
        );
        when(getTvSeriesRecommendations.execute(tId)).thenAnswer(
          (_) async => const Left(
            ServerFailure("Server Failure"),
          ),
        );

        return bloc;
      },
      act: (TvDetailBloc bloc) => bloc.add(
            OnTvDetailDataRequested(tId!),
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
          getTvSeriesDetail.execute(tId!),
        );
        verify(
          getTvSeriesRecommendations.execute(tId),
        );
      });
}

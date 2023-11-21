import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late GetTopRatedTvSeries getTopRatedTvSeries;
  late TopRatedTvSeriesBloc bloc;

  setUp(() {
    getTopRatedTvSeries = MockGetTopRatedTvSeries();
    bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries);
  });

  final data = testOnTheAirTvSeriesList;
  final expected =
      data.results!.map((e) => Poster5Entity.fromTvSeries(e)).toList();

  test('inital state should be initial', () {
    expect(bloc.state, TopRatedTvSeriesInitial());
  });

  blocTest('Should emit [Loading, HasData] when data is gotten succesful',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => Right(data));

        return bloc;
      },
      act: (TopRatedTvSeriesBloc bloc) =>
          bloc.add(OnTopRatedTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [TopRatedTvSeriesLoading(), TopRatedTvSeriesSuccess(expected)],
      verify: (TopRatedTvSeriesBloc bloc) {
        verify(getTopRatedTvSeries.execute());
      });

  blocTest('Should emit [Loading, Error] when server failure',
      build: () {
        when(getTopRatedTvSeries.execute())
            .thenAnswer((realInvocation) async => const Left(ServerFailure("Server Failure")));

        return bloc;
      },
      act: (TopRatedTvSeriesBloc bloc) =>
          bloc.add(OnTopRatedTvSeriesDataRequested()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            TopRatedTvSeriesLoading(),
            TopRatedTvSeriesError('Server Failure', retry: () {})
          ],
      verify: (TopRatedTvSeriesBloc bloc) {
        verify(getTopRatedTvSeries.execute());
      });
}

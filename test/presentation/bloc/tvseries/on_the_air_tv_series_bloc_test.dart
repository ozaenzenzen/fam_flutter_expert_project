import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_series.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'on_the_air_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvSeries])
void main() {
  late GetOnTheAirTvSeries getOnTheAirTvSeries;
  late OnTheAirTvSeriesBloc bloc;

  setUp(() {
    getOnTheAirTvSeries = MockGetOnTheAirTvSeries();
    bloc = OnTheAirTvSeriesBloc(getOnTheAirTvSeries);
  });

  final TvSeriesResponseModel data = testOnTheAirTvSeriesList;
  final List<Poster3Entity> expected = data.results!.map((e) => Poster3Entity.fromTvSeries(e)).toList();

  test('inital state should be [OnTheAirTvSeriesInitial]', () {
    expect(bloc.state, OnTheAirTvSeriesInitial());
  });

  blocTest(
    'emit [Loading, Success] when data is gotten succesful',
    build: () {
      when(getOnTheAirTvSeries.execute()).thenAnswer((realInvocation) async => Right(data));

      return bloc;
    },
    act: (OnTheAirTvSeriesBloc bloc) => bloc.add(OnTheAirTvSeriesDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirTvSeriesLoading(),
      OnTheAirTvSeriesSuccess(expected),
    ],
    verify: (OnTheAirTvSeriesBloc bloc) {
      verify(getOnTheAirTvSeries.execute());
    },
  );

  blocTest(
    'emit [Loading, Error] when data is gotten succesful',
    build: () {
      when(getOnTheAirTvSeries.execute()).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      return bloc;
    },
    act: (OnTheAirTvSeriesBloc bloc) => bloc.add(OnTheAirTvSeriesDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirTvSeriesLoading(),
      OnTheAirTvSeriesError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (OnTheAirTvSeriesBloc bloc) {
      verify(getOnTheAirTvSeries.execute());
    },
  );
}

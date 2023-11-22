import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late GetPopularTvSeries getPopularTvSeries;
  late PopularTvSeriesBloc bloc;

  setUp(() {
    getPopularTvSeries = MockGetPopularTvSeries();
    bloc = PopularTvSeriesBloc(getPopularTvSeries);
  });

  final data = testOnTheAirTvSeriesList;
  final expected = data.results!.map((e) => Poster5Entity.fromTvSeries(e.toEntity())).toList();

  test('inital state should be [PopularTvSeriesInitial]', () {
    expect(bloc.state, PopularTvSeriesInitial());
  });

  blocTest(
    'emit [Loading, HasData] when data is gotten succesful',
    build: () {
      when(getPopularTvSeries.execute()).thenAnswer(
        (realInvocation) async => Right(data.toEntity()),
      );
      return bloc;
    },
    act: (PopularTvSeriesBloc bloc) => bloc.add(OnPopulartTvSeriesDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvSeriesLoading(),
      PopularTvSeriesSuccess(expected),
    ],
    verify: (PopularTvSeriesBloc bloc) {
      verify(getPopularTvSeries.execute());
    },
  );

  blocTest(
    'emit [Loading, Error] when data is gotten succesful',
    build: () {
      when(getPopularTvSeries.execute()).thenAnswer(
        (realInvocation) async => const Left(
          ServerFailure("Server Failure"),
        ),
      );
      return bloc;
    },
    act: (PopularTvSeriesBloc bloc) => bloc.add(OnPopulartTvSeriesDataRequested()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvSeriesLoading(),
      PopularTvSeriesError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (PopularTvSeriesBloc bloc) {
      verify(getPopularTvSeries.execute());
    },
  );
}

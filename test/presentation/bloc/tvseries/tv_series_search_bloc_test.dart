import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_response_model.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_searies_search/tv_series_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late TvSeriesSearchBloc bloc;
  late SearchTvSeries searchTvSeries;

  setUp(() {
    searchTvSeries = MockSearchTvSeries();
    bloc = TvSeriesSearchBloc(searchTvSeries);
  });

  const String testQuery = 'spiderman';
  final TvSeriesResponseModel data = testSearchTvSeriesList;
  final List<Poster5Entity> expected = testSearchTvSeriesList.results!.map((e) => Poster5Entity.fromTvSeries(e)).toList();

  test('inital state should be [TvSeriesSearchInitial]', () {
    expect(bloc.state, TvSeriesSearchInitial());
  });

  blocTest(
    'emit [Loading, HasData] when data is gotten succesful',
    build: () {
      when(searchTvSeries.execute(testQuery)).thenAnswer((realInvocation) async => Right(data));
      return bloc;
    },
    act: (TvSeriesSearchBloc bloc) => bloc.add(const OnQueryTvSeriesChanged(testQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      TvSeriesSearchHasData(expected),
    ],
    verify: (TvSeriesSearchBloc bloc) {
      verify(searchTvSeries.execute(testQuery));
    },
  );

  blocTest(
    'emit [Initial] when query is empty',
    build: () => bloc,
    act: (TvSeriesSearchBloc bloc) => bloc.add(const OnQueryTvSeriesChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchInitial(),
    ],
  );

  blocTest(
    'emit [Loading, Empty] when data is gotten succesful but empty',
    build: () {
      when(searchTvSeries.execute(testQuery)).thenAnswer(
        (realInvocation) async => Right(
          TvSeriesResponseModel(results: []),
        ),
      );

      return bloc;
    },
    act: (TvSeriesSearchBloc bloc) => bloc.add(const OnQueryTvSeriesChanged(testQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      const TvSeriesSearchEmpty('No Tv Series found $testQuery'),
    ],
    verify: (TvSeriesSearchBloc bloc) {
      verify(searchTvSeries.execute(testQuery));
    },
  );

  blocTest(
    'emit [Loading, Error] when data is unsuccesful',
    build: () {
      when(searchTvSeries.execute(testQuery)).thenAnswer((realInvocation) async => const Left(ServerFailure("Server Failure")));

      return bloc;
    },
    act: (TvSeriesSearchBloc bloc) => bloc.add(const OnQueryTvSeriesChanged(testQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesSearchLoading(),
      TvSeriesSearchError(
        'Server Failure',
        retry: () {},
      ),
    ],
    verify: (TvSeriesSearchBloc bloc) {
      verify(searchTvSeries.execute(testQuery));
    },
  );
}

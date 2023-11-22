import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tvseries/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../mock/mock_bloc.dart';

void main() {
  late PopularTvSeriesBloc bloc;

  setUp(() {
    bloc = MockPopularTvSeriesBloc();
  });

  setUpAll(() {
    registerFallbackValue(PopularTvSeriesStateFake());
    registerFallbackValue(PopularTvSeriesEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Page display center progress bar when loading',
    (WidgetTester tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            PopularTvSeriesLoading(),
          ],
        ),
        initialState: PopularTvSeriesInitial(),
      );

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));
      await tester.pump(Duration.zero);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page display ListView when data is loaded',
    (WidgetTester tester) async {
      final movie = Poster5Entity.fromTvSeries(testPopularTvSeries.toEntity());
      final imageUrl = '$baseImageUrl${movie.poster}';

      whenListen(
          bloc,
          Stream.fromIterable(
            [
              PopularTvSeriesLoading(),
              PopularTvSeriesSuccess([movie]),
            ],
          ),
          initialState: PopularTvSeriesInitial());

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));
      await tester.pump(Duration.zero);

      expect(listViewFinder, findsOneWidget);

      expect(find.text(movie.overview), findsOneWidget);
      expect(find.text(movie.title), findsOneWidget);
      final image = find.byType(CachedNetworkImage).evaluate().single.widget as CachedNetworkImage;

      expect(image.imageUrl, imageUrl);
    },
  );

  testWidgets(
    'Page display text with message when Error',
    (WidgetTester tester) async {
      const String message = 'Server Failure';

      whenListen(bloc, Stream.fromIterable([PopularTvSeriesLoading(), PopularTvSeriesError(message, retry: () {})]), initialState: PopularTvSeriesInitial());

      await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));
      await tester.pump(Duration.zero);

      expect(find.text(message), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    },
  );
}

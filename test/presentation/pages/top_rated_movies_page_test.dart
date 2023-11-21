import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mock/mock_bloc.dart';

void main() {
  late TopRatedMovieBloc bloc;

  setUp(() {
    bloc = MockTopRatedMovieBloc();
  });

  setUpAll(() {
    registerFallbackValue(TopRatedMovieStateFake());
    registerFallbackValue(TopRatedMovieEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    whenListen(bloc, Stream.fromIterable([TopRatedMovieLoading()]),
        initialState: TopRatedMovieInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final movie = Poster5Entity.fromMovie(testMovie);
    final imageUrl = '$baseImageUrl${movie.poster}';

    whenListen(
        bloc,
        Stream.fromIterable([
          TopRatedMovieLoading(),
          TopRatedMovieSuccess([movie])
        ]),
        initialState: TopRatedMovieInitial());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(listViewFinder, findsOneWidget);

    expect(find.text(movie.overview), findsOneWidget);
    expect(find.text(movie.title), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    const String message = 'Server Failure';

    whenListen(
        bloc,
        Stream.fromIterable([
          TopRatedMovieLoading(),
          TopRatedMovieError(message, retry: () {})
        ]),
        initialState: TopRatedMovieInitial());

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));
    await tester.pump(Duration.zero);

    expect(find.text(message), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/widgets/app_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mock/mock_bloc.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late WatchlistStatusBloc watchlistStatusBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
    watchlistStatusBloc = MockWatchListStatusBloc();
  });

  setUpAll(() {
    registerFallbackValue(MovieDetailStateFake());
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => movieDetailBloc,
          ),
          BlocProvider(
            create: (context) => watchlistStatusBloc,
          )
        ],
        child: Builder(
          builder: (_) => MaterialApp(
              home: Scaffold(
            body: body,
          )),
        ));
  }

  const MovieDetailEntity movieDetail = testMovieDetail;
  final List<Poster3Entity> movieRecommendation = <Poster3Entity>[];
  final ItemDataEntity itemDataEntity = ItemDataEntity.fromMovie(movieDetail);

  testWidgets(
    'should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      const String message = 'Added to Watchlist';

      whenListen(
        movieDetailBloc,
        Stream.fromIterable(
          [
            MovieDetailLoading(),
            MovieDetailSuccess(
              itemDataEntity,
              recommendations: movieRecommendation,
            ),
          ],
        ),
        initialState: MovieDetailInitial(),
      );
      whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          const WatchlistStatusSuccess(message),
          const WatchlistStatusLoaded(true),
        ]),
        initialState: const WatchlistStatusLoaded(false),
      );

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(
        makeTestableWidget(
          AppDetailContent(itemDataEntity),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.pump(Duration.zero);

      await tester.tap(watchlistButton);
      await tester.pump(Duration.zero);

      await expectLater(find.byType(SnackBar), findsOneWidget);
      await expectLater(find.text(message), findsOneWidget);
      await expectLater(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      const String message = 'Failed';

      whenListen(
        movieDetailBloc,
        Stream.fromIterable(
          [
            MovieDetailLoading(),
            MovieDetailSuccess(
              itemDataEntity,
              recommendations: movieRecommendation,
            )
          ],
        ),
        initialState: MovieDetailInitial(),
      );
      whenListen(
          watchlistStatusBloc,
          Stream.fromIterable([
            WatchlistStatusLoading(),
            WatchlistStatusError(message, retry: () {}),
          ]),
          initialState: const WatchlistStatusLoaded(false));

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(makeTestableWidget(AppDetailContent(itemDataEntity)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(message), findsOneWidget);
    },
  );
}

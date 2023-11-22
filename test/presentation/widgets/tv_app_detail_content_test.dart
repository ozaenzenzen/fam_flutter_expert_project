import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/data/repositories/watchlist_repository_impl.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
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
  late TvDetailBloc bloc;
  late WatchlistStatusBloc watchlistStatusBloc;
  late WatchlistBloc watchlistBloc;

  setUp(() {
    bloc = MockTvDetailBloc();
    watchlistStatusBloc = MockWatchListStatusBloc();
    watchlistBloc = WatchlistBloc(
      GetWatchlist(
        WatchlistRepositoryImpl(
          WatchlistLocalDataSourceImpl(
            databaseHelper: DatabaseHelper(),
          ),
        ),
      ),
    );
  });

  setUpAll(() {
    registerFallbackValue(TvDetailStateFake());
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
    registerFallbackValue(MockWatchlistBloc());
  });

  Widget makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => bloc,
        ),
        BlocProvider(
          create: (context) => watchlistStatusBloc,
        ),
        BlocProvider(
          create: (context) => watchlistBloc,
        ),
      ],
      child: Builder(
        builder: (_) => MaterialApp(
          home: Scaffold(
            body: body,
          ),
        ),
      ),
    );
  }

  final TvDetailResponseModel tvDetail = testTvDetail;
  final List<Poster3Entity> tvRecommendation = <Poster3Entity>[];
  // final ItemDataEntity itemDataEntity = ItemDataEntity.fromTvSeries(tvDetail);
  final ItemDataEntity itemDataEntity = tvDetail.toEntity();

  testWidgets('should display Snackbar when added to watchlist', (WidgetTester tester) async {
    const String message = 'Added to Watchlist';

    whenListen(
      bloc,
      Stream.fromIterable(
        [
          TvDetailLoading(),
          TvDetailSuccess(
            itemDataEntity,
            recommendations: tvRecommendation,
          ),
        ],
      ),
      initialState: TvDetailInitial(),
    );
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable(
          [
            WatchlistStatusLoading(),
            const WatchlistStatusSuccess(message),
            const WatchlistStatusLoaded(true),
          ],
        ),
        initialState: const WatchlistStatusLoaded(false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(AppDetailContent(itemDataEntity)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.pump(Duration.zero);

    await tester.tap(watchlistButton);
    await tester.pump(Duration.zero);

    await expectLater(find.byType(SnackBar), findsOneWidget);
    await expectLater(find.text(message), findsOneWidget);
    await expectLater(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Watchlist button should display AlertDialog when add to watchlist failed', (WidgetTester tester) async {
    const String message = 'Failed';

    whenListen(
      bloc,
      Stream.fromIterable(
        [
          TvDetailLoading(),
          TvDetailSuccess(
            itemDataEntity,
            recommendations: tvRecommendation,
          ),
        ],
      ),
      initialState: TvDetailInitial(),
    );
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusError(
            message,
            retry: () {},
          ),
        ]),
        initialState: const WatchlistStatusLoaded(false));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(AppDetailContent(itemDataEntity)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });
}

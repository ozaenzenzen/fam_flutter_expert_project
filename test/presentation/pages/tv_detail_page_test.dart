import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_data_type.dart';
import 'package:ditonton/data/models/tv_detail_response_model.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_3_entity.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
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

  setUp(() {
    bloc = MockTvDetailBloc();
    watchlistStatusBloc = MockWatchListStatusBloc();
  });

  setUpAll(() {
    registerFallbackValue(TvDetailStateFake());
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(WatchListStatusStateFake());
    registerFallbackValue(WatchListStatusEventFake());
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
        providers: [
          BlocProvider(
            create: (_) => bloc,
          ),
          BlocProvider(
            create: (context) => watchlistStatusBloc,
          )
        ],
        child: Builder(
          builder: (_) => MaterialApp(home: body),
        ));
  }

  final TvDetailResponseModel tvDetail = tTvDetail;
  final Poster2Entity poster2entity = Poster2Entity(id: tvDetail.id!, dataType: DataType.TvSeries);
  final List<Poster3Entity> tvRecommendations = <Poster3Entity>[];
  final bool isAddedToWatchList = false;
  final String imageUrl = '$BASE_IMAGE_URL${tvDetail.posterPath}';
  final ItemDataEntity itemDataEntity = ItemDataEntity.fromTvSeries(tvDetail);

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    whenListen(bloc, Stream.fromIterable([TvDetailLoading()]),
        initialState: TvDetailInitial());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(
        _makeTestableWidget(DetailPage(poster2Entity: poster2entity)));
    await tester.pump(Duration.zero);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });
  testWidgets('Should has same data', (WidgetTester tester) async {
    whenListen(
        bloc,
        Stream.fromIterable([
          TvDetailLoading(),
          TvDetailSuccess(itemDataEntity, recommendations: tvRecommendations)
        ]),
        initialState: TvDetailInitial());
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    await tester.pumpWidget(
      _makeTestableWidget(DetailPage(poster2Entity: poster2entity)),
    );
    await tester.pump(Duration.zero);

    expect(find.text(tvDetail.overview!), findsOneWidget);
    expect(find.text(tvDetail.name!), findsOneWidget);
    final image = find.byType(CachedNetworkImage).evaluate().single.widget
        as CachedNetworkImage;

    expect(image.imageUrl, imageUrl);
  });

  testWidgets('should show ditonton error widget when failure',
      (WidgetTester tester) async {
    whenListen(
        bloc,
        Stream.fromIterable(
            [TvDetailLoading(), TvDetailError('Server Failure', retry: () {})]),
        initialState: TvDetailInitial());
    whenListen(
        watchlistStatusBloc,
        Stream.fromIterable([
          WatchlistStatusLoading(),
          WatchlistStatusLoaded(isAddedToWatchList)
        ]),
        initialState: WatchlistStatusInitial());

    await tester.pumpWidget(
      _makeTestableWidget(DetailPage(poster2Entity: poster2entity)),
    );
    await tester.pump(Duration.zero);

    expect(find.text('Retry'), findsOneWidget);
  });
}

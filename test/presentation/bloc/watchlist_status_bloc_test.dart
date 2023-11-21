import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/movie_detail_entity.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/entities/poster_5_entity.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';
import 'watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([GetWatchListStatus, RemoveWatchlist, SaveWatchlist])
void main() {
  late WatchlistBloc watchlistBloc;
  late GetWatchlist getWatchlist;
  late GetWatchListStatus getWatchListStatus;
  late SaveWatchlist saveWatchlist;
  late RemoveWatchlist removeWatchlist;
  late WatchlistStatusBloc bloc;

  setUp(() {
    getWatchlist = MockGetWatchlist();
    getWatchListStatus = MockGetWatchListStatus();
    saveWatchlist = MockSaveWatchlist();
    removeWatchlist = MockRemoveWatchlist();

    watchlistBloc = WatchlistBloc(getWatchlist);
    bloc = WatchlistStatusBloc(
      watchlistBloc,
      getWatchListStatus,
      saveWatchlist,
      removeWatchlist,
    );
  });

  final List<MovieEntity> data = [testWatchlistMovie];
  final List<Poster5Entity> expected = data.map((e) => Poster5Entity.fromMovie(e)).toList();
  const MovieDetailEntity movie = testMovieDetail;
  final ItemDataEntity itemDataEntity = ItemDataEntity.fromMovie(movie);
  final Poster2Entity poster2entity = Poster2Entity(id: itemDataEntity.id, dataType: itemDataEntity.dataType);

  test('inital state should be [WatchlistStatusInitial]', () {
    expect(bloc.state, WatchlistStatusInitial());
  });

  blocTest(
    'emit [Loading, HasData] when data added succesful',
    build: () {
      when(saveWatchlist.execute(itemDataEntity)).thenAnswer((_) async => const Right('Success'));
      when(getWatchListStatus.execute(
        itemDataEntity.id,
        itemDataEntity.dataType.index,
      )).thenAnswer((_) async => true);
      when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));

      return bloc;
    },
    act: (WatchlistStatusBloc bloc) => bloc.add(OnWatchlistAdded(itemDataEntity)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistStatusLoading(),
      const WatchlistStatusSuccess('Success Added title to watchlist'),
      const WatchlistStatusLoaded(true),
    ],
    verify: (WatchlistStatusBloc bloc) {
      verify(saveWatchlist.execute(itemDataEntity));
      verify(getWatchListStatus.execute(
        itemDataEntity.id,
        itemDataEntity.dataType.index,
      ));
    },
  );

  blocTest(
    'emit [Loading, HasData] when data removed succesful',
    build: () {
      when(removeWatchlist.execute(poster2entity)).thenAnswer((_) async => const Right('Removed'));
      when(getWatchListStatus.execute(
        itemDataEntity.id,
        itemDataEntity.dataType.index,
      )).thenAnswer((_) async => false);
      when(getWatchlist.execute()).thenAnswer((_) async => const Right([]));

      return bloc;
    },
    act: (WatchlistStatusBloc bloc) => bloc.add(OnWatchlistRemoved(poster2entity)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistStatusLoading(),
      const WatchlistStatusSuccess('Success Removed'),
      const WatchlistStatusLoaded(false),
    ],
    verify: (WatchlistStatusBloc bloc) {
      verify(removeWatchlist.execute(poster2entity));
      verify(getWatchListStatus.execute(
        itemDataEntity.id,
        itemDataEntity.dataType.index,
      ));
      verify(getWatchlist.execute());
    },
  );
}

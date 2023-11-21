import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
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
        watchlistBloc, getWatchListStatus, saveWatchlist, removeWatchlist);
  });

  final data = [testWatchlistMovie];
  final expected = data.map((e) => Poster5Entity.fromMovie(e)).toList();
  const movie = testMovieDetail;
  final params = ItemDataEntity.fromMovie(movie);
  final idAndDataType = Poster2Entity(id: params.id, dataType: params.dataType);

  test('inital state should be empty', () {
    expect(bloc.state, WatchlistStatusInitial());
  });

  blocTest('Should emit [Loading, HasData] when data added succesful',
      build: () {
        when(saveWatchlist.execute(params))
            .thenAnswer((_) async => const Right('Success'));
        when(getWatchListStatus.execute(params.id, params.dataType.index))
            .thenAnswer((_) async => true);
        when(getWatchlist.execute()).thenAnswer((_) async => Right(expected));

        return bloc;
      },
      act: (WatchlistStatusBloc bloc) => bloc.add(OnWatchlistAdded(params)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WatchlistStatusLoading(),
            const WatchlistStatusSuccess('Success Added title to watchlist'),
            const WatchlistStatusLoaded(true)
          ],
      verify: (WatchlistStatusBloc bloc) {
        verify(saveWatchlist.execute(params));
        verify(getWatchListStatus.execute(params.id, params.dataType.index));
      });

  blocTest('Should emit [Loading, HasData] when data removed succesful',
      build: () {
        when(removeWatchlist.execute(idAndDataType))
            .thenAnswer((_) async => const Right('Removed'));
        when(getWatchListStatus.execute(params.id, params.dataType.index))
            .thenAnswer((_) async => false);
        when(getWatchlist.execute()).thenAnswer((_) async => const Right([]));

        return bloc;
      },
      act: (WatchlistStatusBloc bloc) =>
          bloc.add(OnWatchlistRemoved(idAndDataType)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
            WatchlistStatusLoading(),
            const WatchlistStatusSuccess('Success Removed'),
            const WatchlistStatusLoaded(false)
          ],
      verify: (WatchlistStatusBloc bloc) {
        verify(removeWatchlist.execute(idAndDataType));
        verify(getWatchListStatus.execute(params.id, params.dataType.index));
        verify(getWatchlist.execute());
      });
}

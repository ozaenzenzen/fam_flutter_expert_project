// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/item_data_entity.dart';
import 'package:ditonton/domain/entities/poster_2_entity.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_status_event.dart';
part 'watchlist_status_state.dart';

class WatchlistStatusBloc extends Bloc<WatchlistStatusEvent, WatchlistStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusBloc(
    WatchlistBloc watchlistBloc,
    GetWatchListStatus getWatchListStatus,
    SaveWatchlist saveWatchlist,
    RemoveWatchlist removeWatchlist,
  ) : super(WatchlistStatusInitial()) {
    on<WatchlistStatusEvent>((event, emit) async {
      if (event is OnWatchlistAdded) {
        await onWatchlistAdded(
          watchlistBloc,
          saveWatchlist,
          event.itemDataEntity,
        );
      } else if (event is OnWatchlistRemoved) {
        await onWatchListRemoved(
          watchlistBloc,
          removeWatchlist,
          event.poster2Entity,
        );
      } else if (event is OnWatchlistStatusChecked) {
        await onWatchListStatusChecked(
          getWatchListStatus,
          event.poster2Entity,
        );
      }
    });
  }

  Future<void> onWatchListStatusChecked(
    GetWatchListStatus getWatchListStatus,
    Poster2Entity poster2Entity,
  ) async {
    final isAdded = await getWatchListStatus.execute(
      poster2Entity.id,
      poster2Entity.dataType.index,
    );

    emit(WatchlistStatusLoaded(isAdded));
  }

  Future<void> onWatchListRemoved(
    WatchlistBloc watchlistBloc,
    RemoveWatchlist removeWatchlist,
    Poster2Entity poster2Entity,
  ) async {
    emit(WatchlistStatusLoading());
    final result = await removeWatchlist.execute(poster2Entity);

    result.fold((failure) {
      final state = WatchlistStatusError(failure.message, retry: () {
        add(OnWatchlistRemoved(poster2Entity));
      });

      emit(state);
    }, (data) {
      const state = WatchlistStatusSuccess('Success Removed');
      emit(state);

      add(OnWatchlistStatusChecked(poster2Entity));

      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }

  Future<void> onWatchlistAdded(
    WatchlistBloc watchlistBloc,
    SaveWatchlist saveWatchlist,
    ItemDataEntity itemDataEntity,
  ) async {
    emit(WatchlistStatusLoading());
    final result = await saveWatchlist.execute(itemDataEntity);

    result.fold((failure) {
      final state = WatchlistStatusError(
        failure.message,
        retry: () {
          add(OnWatchlistAdded(itemDataEntity));
        },
      );

      emit(state);
    }, (data) {
      final state = WatchlistStatusSuccess('Success Added ${itemDataEntity.title} to watchlist');
      emit(state);

      add(
        OnWatchlistStatusChecked(
          Poster2Entity(
            id: itemDataEntity.id,
            dataType: itemDataEntity.dataType,
          ),
        ),
      );
      watchlistBloc.add(OnWatchlistDataRequested());
    });
  }
}

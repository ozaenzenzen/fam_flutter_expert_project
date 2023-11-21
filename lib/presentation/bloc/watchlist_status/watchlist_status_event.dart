part of 'watchlist_status_bloc.dart';

abstract class WatchlistStatusEvent extends Equatable {
  const WatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistAdded extends WatchlistStatusEvent {
  final ItemDataEntity itemDataEntity;

  const OnWatchlistAdded(this.itemDataEntity);

  @override
  List<Object> get props => [itemDataEntity];
}

class OnWatchlistRemoved extends WatchlistStatusEvent {
  final Poster2Entity poster2Entity;

  const OnWatchlistRemoved(this.poster2Entity);

  @override
  List<Object> get props => [poster2Entity];
}

class OnWatchlistStatusChecked extends WatchlistStatusEvent {
  final Poster2Entity poster2Entity;

  const OnWatchlistStatusChecked(this.poster2Entity);

  @override
  List<Object> get props => [poster2Entity];
}

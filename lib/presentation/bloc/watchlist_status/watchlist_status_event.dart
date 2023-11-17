part of 'watchlist_status_bloc.dart';

abstract class WatchlistStatusEvent extends Equatable {
  const WatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class OnWatchlistAdded extends WatchlistStatusEvent {
  final ItemDataEntity itemDataEntity;

  OnWatchlistAdded(this.itemDataEntity);

  @override
  List<Object> get props => [itemDataEntity];
}

class OnWatchlistRemoved extends WatchlistStatusEvent {
  final IdAndDataType idAndDataType;

  OnWatchlistRemoved(this.idAndDataType);

  @override
  List<Object> get props => [idAndDataType];
}

class OnWatchlistStatusChecked extends WatchlistStatusEvent {
  final IdAndDataType idAndDataType;

  OnWatchlistStatusChecked(this.idAndDataType);

  List<Object> get props => [idAndDataType];
}

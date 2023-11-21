part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistEmpty extends WatchlistState {}

class WatchlistHasData extends WatchlistState {
  final List<Poster5Entity> data;

  const WatchlistHasData(this.data);

  @override
  List<Object> get props => [...data];
}

class WatchlistError extends WatchlistState {
  final String message;
  final Function retry;

  const WatchlistError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

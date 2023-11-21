part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchInitial extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchEmpty extends TvSeriesSearchState {
  final String message;

  const TvSeriesSearchEmpty(this.message);
}

class TvSeriesSearchHasData extends TvSeriesSearchState {
  final List<Poster5Entity> data;

  const TvSeriesSearchHasData(this.data);

  @override
  List<Object> get props => [...data];
}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;
  final Function retry;

  const TvSeriesSearchError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

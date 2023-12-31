part of 'movie_search_bloc.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object> get props => [];
}

class MovieSearchInitial extends MovieSearchState {}

class MovieSearchEmpty extends MovieSearchState {
  final String message;

  const MovieSearchEmpty(this.message);
}

class MovieSearchLoading extends MovieSearchState {}

class MovieSearchError extends MovieSearchState {
  final String message;
  final Function? retry;

  const MovieSearchError(this.message, {this.retry});

  @override
  List<Object> get props => [message, retry != null];
}

class MovieSearchHasData extends MovieSearchState {
  final List<MovieEntity> data;

  const MovieSearchHasData(this.data);

  @override
  List<Object> get props => [data];
}

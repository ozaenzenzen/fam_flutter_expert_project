part of 'popular_movie_bloc.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();
  
  @override
  List<Object> get props => [];
}

class PopularMovieInitial extends PopularMovieState {}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieSuccess extends PopularMovieState {
  final List<Poster5Entity> movies;

  const PopularMovieSuccess(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMovieError extends PopularMovieState {
  final String message;
  final Function() retry;

  const PopularMovieError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

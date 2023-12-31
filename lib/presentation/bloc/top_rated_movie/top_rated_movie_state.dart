part of 'top_rated_movie_bloc.dart';

abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();
  
  @override
  List<Object> get props => [];
}

class TopRatedMovieInitial extends TopRatedMovieState {}

class TopRatedMovieLoading extends TopRatedMovieState {}

class TopRatedMovieSuccess extends TopRatedMovieState {
  final List<Poster5Entity> movies;
  
  const TopRatedMovieSuccess(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMovieError extends TopRatedMovieState {
  final String message;
  final Function retry;

  const TopRatedMovieError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

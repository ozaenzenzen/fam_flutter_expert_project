part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnMovieDetailDataRequested extends MovieDetailEvent {
  final int id;

  OnMovieDetailDataRequested(this.id);

  @override
  List<Object> get props => [id];
}

class OnMovieRecommendationsRequested extends MovieDetailEvent {
  final ItemDataEntity itemDataEntity;

  OnMovieRecommendationsRequested(this.itemDataEntity);

  @override
  List<Object> get props => [itemDataEntity];
}

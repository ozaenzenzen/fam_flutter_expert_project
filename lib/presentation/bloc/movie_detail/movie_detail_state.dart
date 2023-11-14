part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailSuccess extends MovieDetailState {
  final ItemDataModel itemDataModel;
  final List<IdPosterDataType> recommendations;

  MovieDetailSuccess(this.itemDataModel, {this.recommendations = const []});
}

class MovieDetailError extends MovieDetailState {
  final String message;
  final Function retry;

  MovieDetailError(this.message, {required this.retry});
}

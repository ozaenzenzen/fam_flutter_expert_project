part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();
  
  @override
  List<Object> get props => [];
}

class TvDetailInitial extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailSuccess extends TvDetailState {
  final ItemDataEntity itemDataEntity;
  final List<Poster3Entity> recommendations;

  const TvDetailSuccess(this.itemDataEntity, {this.recommendations = const []});

  @override
  List<Object> get props => [itemDataEntity, recommendations];
}

class TvDetailError extends TvDetailState {
  final String message;
  final Function retry;

  const TvDetailError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

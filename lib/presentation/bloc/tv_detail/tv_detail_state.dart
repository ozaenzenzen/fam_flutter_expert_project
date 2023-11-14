part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();
  
  @override
  List<Object> get props => [];
}

class TvDetailInitial extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailSuccess extends TvDetailState {
  final ItemDataModel itemDataModel;
  final List<IdPosterDataType> recommendations;

  TvDetailSuccess(this.itemDataModel, {this.recommendations = const []});

  @override
  List<Object> get props => [itemDataModel, recommendations];
}

class TvDetailError extends TvDetailState {
  final String message;
  final Function retry;

  TvDetailError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

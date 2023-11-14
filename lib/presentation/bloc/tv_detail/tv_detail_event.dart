part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class OnTvDetailDataRequested extends TvDetailEvent {
  final int id;

  OnTvDetailDataRequested(this.id); 

  @override
  List<Object> get props => [id];
}

class OnTvRecommendationRequested extends TvDetailEvent {
  final ItemDataModel itemDataModel;

  OnTvRecommendationRequested(this.itemDataModel);

  @override
  List<Object> get props => [itemDataModel];
}

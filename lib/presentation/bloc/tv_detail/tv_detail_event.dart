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
  final ItemDataEntity itemDataEntity;

  OnTvRecommendationRequested(this.itemDataEntity);

  @override
  List<Object> get props => [itemDataEntity];
}

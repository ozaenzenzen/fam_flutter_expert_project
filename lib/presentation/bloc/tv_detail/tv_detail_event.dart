part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent {
  const TvDetailEvent();
}

class OnTvDetailDataRequested extends TvDetailEvent {
  final int id;

  const OnTvDetailDataRequested(this.id); 
}

class OnTvRecommendationRequested extends TvDetailEvent {
  final ItemDataEntity itemDataEntity;

  const OnTvRecommendationRequested(this.itemDataEntity);
}

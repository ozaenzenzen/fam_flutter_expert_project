// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/item_data_model.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  TvDetailBloc(
    GetTvSeriesDetail getTvSeriesDetail,
    GetTvSeriesRecommendations getTvSeriesRecommendations,
  ) : super(TvDetailInitial()) {
    on<TvDetailEvent>((event, emit) async {
      if (event is OnTvDetailDataRequested) {
        await onTvDetailDataRequested(
          getTvSeriesDetail,
          getTvSeriesRecommendations,
          event.id,
        );
      } else if (event is OnTvRecommendationRequested) {
        await onTvRecommendationRequested(
          getTvSeriesRecommendations,
          event.itemDataEntity,
        );
      }
    });
  }

  Future<void> onTvDetailDataRequested(
    GetTvSeriesDetail getTvSeriesDetail,
    GetTvSeriesRecommendations getTvSeriesRecommendations,
    int id,
  ) async {
    emit(TvDetailLoading());
    final result = await getTvSeriesDetail.execute(id);
    final recommendationFuture = getTvSeriesRecommendations.execute(id);

    result.fold((failure) {
      final state = TvDetailError(failure.message, retry: () {
        add(OnTvDetailDataRequested(id));
      });

      emit(state);
    }, (data) async {
      final itemDataEntity = ItemDataEntity.fromTvSeries(data);

      final recommendation = await recommendationFuture;
      recommendation.fold((failure) {
        final state = TvDetailError(failure.message, retry: () {
          add(OnTvRecommendationRequested(itemDataEntity));
        });

        emit(state);

        final stateDetail = TvDetailSuccess(itemDataEntity);
        emit(stateDetail);
      }, (data) {
        final result = data.results!.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
        final successState = TvDetailSuccess(
          itemDataEntity,
          recommendations: result,
        );

        emit(successState);
      });
    });
  }

  Future<void> onTvRecommendationRequested(
    GetTvSeriesRecommendations getTvSeriesRecommendations,
    ItemDataEntity itemDataEntity,
  ) async {
    emit(TvDetailLoading());
    final recommendation = await getTvSeriesRecommendations.execute(itemDataEntity.id);

    recommendation.fold((failure) {
      final state = TvDetailError(failure.message, retry: () {
        add(OnTvRecommendationRequested(itemDataEntity));
      });

      emit(state);
      emit(TvDetailSuccess(itemDataEntity));
    }, (data) {
      final result = data.results!.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
      final state = TvDetailSuccess(
        itemDataEntity,
        recommendations: result,
      );

      emit(state);
    });
  }
}

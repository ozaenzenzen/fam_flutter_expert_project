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
          event.itemDataModel,
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
      final contentData = ItemDataModel.fromTvSeries(data);

      final recommendation = await recommendationFuture;
      recommendation.fold((failure) {
        final state = TvDetailError(failure.message, retry: () {
          add(OnTvRecommendationRequested(contentData));
        });

        emit(state);

        final stateDetail = TvDetailSuccess(contentData);
        emit(stateDetail);
      }, (data) {
        final result = data.results!.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
        final successState = TvDetailSuccess(
          contentData,
          recommendations: result,
        );

        emit(successState);
      });
    });
  }

  Future<void> onTvRecommendationRequested(
    GetTvSeriesRecommendations getTvSeriesRecommendations,
    ItemDataModel itemDataModel,
  ) async {
    emit(TvDetailLoading());
    final recommendation = await getTvSeriesRecommendations.execute(itemDataModel.id);

    recommendation.fold((failure) {
      final state = TvDetailError(failure.message, retry: () {
        add(OnTvRecommendationRequested(itemDataModel));
      });

      emit(state);
      emit(TvDetailSuccess(itemDataModel));
    }, (data) {
      final result = data.results!.map((e) => IdPosterDataType.fromTvSeries(e)).toList();
      final state = TvDetailSuccess(
        itemDataModel,
        recommendations: result,
      );

      emit(state);
    });
  }
}

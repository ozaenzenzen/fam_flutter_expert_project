// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/id_poster_data_type.dart';
import 'package:ditonton/domain/entities/item_data_model.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc(GetMovieDetail getMovieDetail, GetMovieRecommendations getMovieRecommendations) : super(MovieDetailInitial()) {
    on<MovieDetailEvent>((event, emit) {
      if (event is OnMovieDetailDataRequested) {
        onMovieDetailDataRequested(getMovieDetail, getMovieRecommendations, event.id);
      } else if (event is OnMovieRecommendationsRequested) {
        onMovieRecommendationsRequested(getMovieRecommendations, event.itemDataModel);
      }
    });
  }

  Future<void> onMovieDetailDataRequested(GetMovieDetail getMovieDetail, GetMovieRecommendations getMovieRecommendations, int id) async {
    emit(MovieDetailLoading());

    final result = await getMovieDetail.execute(id);
    final futureRecommendation = getMovieRecommendations.execute(id);

    result.fold((failure) {
      final state = MovieDetailError(failure.message, retry: () {
        add(OnMovieDetailDataRequested(id));
      });

      emit(state);
    }, (data) async {
      final itemDataModel = ItemDataModel.fromMovie(data);
      final recommendation = await futureRecommendation;

      recommendation.fold((failure) {
        final state = MovieDetailError(failure.message, retry: () {
          add(OnMovieRecommendationsRequested(itemDataModel));
        });

        emit(state);

        final detailState = MovieDetailSuccess(itemDataModel);
        emit(detailState);
      }, (data) {
        final recommendationResult = data.map((e) => IdPosterDataType.fromMovie(e)).toList();

        final state = MovieDetailSuccess(
          itemDataModel,
          recommendations: recommendationResult,
        );
        emit(state);
      });
    });
  }

  Future<void> onMovieRecommendationsRequested(
    GetMovieRecommendations getMovieRecommendations,
    ItemDataModel itemDataModel,
  ) async {
    emit(MovieDetailLoading());
    final result = await getMovieRecommendations.execute(itemDataModel.id);

    result.fold((failure) {
      final state = MovieDetailError(failure.message, retry: () {
        add(OnMovieRecommendationsRequested(itemDataModel));
      });

      emit(state);
    }, (data) async {
      final recommendation = data.map((e) => IdPosterDataType.fromMovie(e)).toList();
      final state = MovieDetailSuccess(
        itemDataModel,
        recommendations: recommendation,
      );

      emit(state);
    });
  }
}

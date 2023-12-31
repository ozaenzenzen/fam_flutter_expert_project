part of 'popular_tv_series_bloc.dart';

abstract class PopularTvSeriesState extends Equatable {
  const PopularTvSeriesState();
  
  @override
  List<Object> get props => [];
}

class PopularTvSeriesInitial extends PopularTvSeriesState {}

class PopularTvSeriesLoading extends PopularTvSeriesState {}

class PopularTvSeriesSuccess extends PopularTvSeriesState {
  final List<Poster5Entity> tvSeries;

  const PopularTvSeriesSuccess(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class PopularTvSeriesError extends PopularTvSeriesState {
  final String message;
  final Function() retry;

  const PopularTvSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

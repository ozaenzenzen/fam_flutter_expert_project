part of 'on_the_air_tv_series_bloc.dart';

abstract class OnTheAirTvSeriesState extends Equatable {
  const OnTheAirTvSeriesState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvSeriesInitial extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesLoading extends OnTheAirTvSeriesState {}

class OnTheAirTvSeriesSuccess extends OnTheAirTvSeriesState {
  final List<Poster5Entity> tvSeries;

  const OnTheAirTvSeriesSuccess(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class OnTheAirTvSeriesError extends OnTheAirTvSeriesState {
  final String message;
  final Function retry;

  const OnTheAirTvSeriesError(this.message, {required this.retry});

  @override
  List<Object> get props => [message];
}

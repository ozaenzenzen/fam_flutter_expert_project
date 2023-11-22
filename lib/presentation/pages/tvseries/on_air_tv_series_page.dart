import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/app_loading_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnAirTvSeriesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/on_air-tv-series';

  const OnAirTvSeriesPage({super.key});

  @override
  State<OnAirTvSeriesPage> createState() => _OnAirTvSeriesPageState();
}

class _OnAirTvSeriesPageState extends State<OnAirTvSeriesPage> {
  @override
  Widget build(BuildContext context) {
    context.read<OnTheAirTvSeriesBloc>().add(OnTheAirTvSeriesDataRequested());
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(
          builder: (context, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return const AppLoadingWidget();
            } else if (state is OnTheAirTvSeriesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return PosterItemWidget(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is OnTheAirTvSeriesError) {
              return AppErrorWidget(
                state.message,
                retry: state.retry,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

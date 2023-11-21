import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvSeriesPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/top-rated-tv-series';

  const TopRatedTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TopRatedTvSeriesBloc>().add(OnTopRatedTvSeriesDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv Series'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvSeriesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return PosterItemWidget(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is TopRatedTvSeriesError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

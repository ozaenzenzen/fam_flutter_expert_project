import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/app_loading_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/popular-tv-series';

  const PopularTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PopularTvSeriesBloc>().add(OnPopulartTvSeriesDataRequested());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
          builder: (context, state) {
            if (state is PopularTvSeriesLoading) {
              return const AppLoadingWidget();
            } else if (state is PopularTvSeriesSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.tvSeries[index];
                  return PosterItemWidget(movie);
                },
                itemCount: state.tvSeries.length,
              );
            } else if (state is PopularTvSeriesError) {
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

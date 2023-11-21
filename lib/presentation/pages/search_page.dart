import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_searies_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/app_loading_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/search';
  final HomeState homeState;

  const SearchPage({super.key, this.homeState = HomeState.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (homeState == HomeState.movies) {
                  context.read<MovieSearchBloc>().add(OnQueryMovieChanged(query));
                } else {
                  context.read<TvSeriesSearchBloc>().add(OnQueryTvSeriesChanged(query));
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            if (homeState == HomeState.movies) buildSearchMoviesWidget(),
            if (homeState == HomeState.tvSeries) buildSearchTvSeriesWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchMoviesWidget() {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) {
          return const AppLoadingWidget();
        } else if (state is MovieSearchHasData) {
          final result = state.data;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
                return PosterItemWidget.fromMovie(movie);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is MovieSearchEmpty) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is MovieSearchError) {
          return Center(
            child: state.retry != null
                ? AppErrorWidget(
                    state.message,
                    retry: state.retry,
                  )
                : Text(state.message),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget buildSearchTvSeriesWidget() {
    return BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
      builder: (context, state) {
        if (state is TvSeriesSearchLoading) {
          return const AppLoadingWidget();
        } else if (state is TvSeriesSearchHasData) {
          final result = state.data;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tvSeries = result[index];
                return PosterItemWidget(tvSeries);
              },
              itemCount: result.length,
            ),
          );
        } else if (state is TvSeriesSearchEmpty) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is TvSeriesSearchError) {
          return Center(
            child: Column(
              children: [
                Text(state.message),
                AppErrorWidget(
                  state.message,
                  retry: state.retry,
                ),
              ],
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}

import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/app_loading_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  Widget build(BuildContext context) {
    context.read<PopularMovieBloc>().add(OnPopularMovieDataRequested());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, PopularMovieState>(
          builder: (context, state) {
            if (state is PopularMovieLoading) {
              return const AppLoadingWidget();
            } else if (state is PopularMovieSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return PosterItemWidget(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is PopularMovieError) {
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

import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/app_loading_widget.dart';
import 'package:ditonton/presentation/widgets/poster_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnAirMoviesPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/on_air-movie';

  const OnAirMoviesPage({super.key});

  @override
  State<OnAirMoviesPage> createState() => _OnAirMoviesPageState();
}

class _OnAirMoviesPageState extends State<OnAirMoviesPage> {
  @override
  Widget build(BuildContext context) {
    context.read<NowPlayingMovieBloc>().add(OnNowPlayingMovieDataRequested());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
          builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return const AppLoadingWidget();
            } else if (state is NowPlayingMovieSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return PosterItemWidget(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is NowPlayingMovieError) {
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

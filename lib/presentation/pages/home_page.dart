import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:ditonton/presentation/bloc/home_state_handler/home_state_handler_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movies/on_air_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tvseries/on_air_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tvseries/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tvseries/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/app_error_widget.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:ditonton/presentation/widgets/app_row_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeState stateHome = HomeState.movies;
  void _getTvSeriesData(BuildContext context) {
    context
      ..read<OnTheAirTvSeriesBloc>().add(OnTheAirTvSeriesDataRequested())
      ..read<PopularTvSeriesBloc>().add(OnPopulartTvSeriesDataRequested())
      ..read<TopRatedTvSeriesBloc>().add(OnTopRatedTvSeriesDataRequested());
  }

  void _getMovieData(BuildContext context) {
    context
      ..read<NowPlayingMovieBloc>().add(OnNowPlayingMovieDataRequested())
      ..read<PopularMovieBloc>().add(OnPopularMovieDataRequested())
      ..read<TopRatedMovieBloc>().add(OnTopRatedMovieDataRequested());
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeStateHandlerBloc>().add(const ActionChangeHomeState(homeState: HomeState.movies));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeStateHandlerBloc, HomeStateHandlerState>(
      listener: (context, state) {
        if (state is HomeStateHandlerMovies) {
          _getMovieData(context);
        } else {
          _getTvSeriesData(context);
        }
      },
      builder: (context, state) {
        if (state is HomeStateHandlerMovies) {
          stateHome = HomeState.movies;
        } else {
          stateHome = HomeState.tvSeries;
        }

        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                const UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/circle-g.png'),
                  ),
                  accountName: Text('Ditonton'),
                  accountEmail: Text('ditonton@dicoding.com'),
                ),
                ListTile(
                  leading: const Icon(Icons.movie),
                  title: const Text('Movies'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeStateHandlerBloc>().add(const ActionChangeHomeState(homeState: HomeState.movies));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.movie),
                  title: const Text('Tv Series'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeStateHandlerBloc>().add(const ActionChangeHomeState(homeState: HomeState.tvSeries));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: const Text('Watchlist'),
                  onTap: () {
                    Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                  },
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Ditonton ${stateHome == HomeState.movies ? 'Movie' : 'Tv Series'}'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SearchPage.ROUTE_NAME,
                    arguments: stateHome,
                  );
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: stateHome == HomeState.tvSeries ? tvSeriesSection() : moviesSection(),
          ),
        );
      },
    );
  }

  SingleChildScrollView moviesSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeading(
            title: 'Now Playing',
            onTap: () => Navigator.pushNamed(context, OnAirMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return const AppRowLoadingWidget();
            } else if (state is NowPlayingMovieSuccess) {
              return MovieList.fromPoster5Entity(state.movies);
            } else if (state is NowPlayingMovieError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Popular',
            onTap: () => Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularMovieBloc, PopularMovieState>(builder: (context, state) {
            if (state is PopularMovieLoading) {
              return const AppRowLoadingWidget();
            } else if (state is PopularMovieSuccess) {
              return MovieList.fromPoster5Entity(state.movies);
            } else if (state is PopularMovieError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () => Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(builder: (context, state) {
            if (state is TopRatedMovieLoading) {
              return const AppRowLoadingWidget();
            } else if (state is TopRatedMovieSuccess) {
              return MovieList.fromPoster5Entity(state.movies);
            } else if (state is TopRatedMovieError) {
              return AppErrorWidget(
                state.message,
                retry: state.retry,
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  SingleChildScrollView tvSeriesSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubHeading(
            title: 'On The Air Tv Series',
            onTap: () => Navigator.pushNamed(context, OnAirTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(builder: (context, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return const AppRowLoadingWidget();
            } else if (state is OnTheAirTvSeriesSuccess) {
              return MovieList.fromPoster5Entity(state.tvSeries);
            } else if (state is OnTheAirTvSeriesError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Popular Tv Series',
            onTap: () => Navigator.pushNamed(context, PopularTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(builder: (context, state) {
            if (state is PopularTvSeriesLoading) {
              return const AppRowLoadingWidget();
            } else if (state is PopularTvSeriesSuccess) {
              return MovieList.fromPoster5Entity(state.tvSeries);
            } else if (state is PopularTvSeriesError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () => Navigator.pushNamed(context, TopRatedTvSeriesPage.ROUTE_NAME),
          ),
          BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(builder: (context, state) {
            if (state is TopRatedTvSeriesLoading) {
              return const AppRowLoadingWidget();
            } else if (state is TopRatedTvSeriesSuccess) {
              return MovieList.fromPoster5Entity(state.tvSeries);
            } else if (state is TopRatedTvSeriesError) {
              return AppErrorWidget(state.message, retry: state.retry);
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

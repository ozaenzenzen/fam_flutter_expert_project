import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:ditonton/presentation/bloc/bloc/home_state_handler_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/widgets/ditonton_error_widget.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:ditonton/presentation/widgets/row_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  HomeState stateHome = HomeState.Movies;
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
    context.read<HomeStateHandlerBloc>()..add(ActionChangeHomeState(homeState: HomeState.Movies));
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
          stateHome = HomeState.Movies;
        } else {
          stateHome = HomeState.TvSeries;
        }

        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/circle-g.png'),
                  ),
                  accountName: Text('Ditonton'),
                  accountEmail: Text('ditonton@dicoding.com'),
                ),
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('Movies'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeStateHandlerBloc>()..add(ActionChangeHomeState(homeState: HomeState.Movies));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.movie),
                  title: Text('Tv Series'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<HomeStateHandlerBloc>()..add(ActionChangeHomeState(homeState: HomeState.TvSeries));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.save_alt),
                  title: Text('Watchlist'),
                  onTap: () {
                    Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
                  },
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Ditonton ${stateHome == HomeState.Movies ? 'Movie' : 'Tv'}'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    SearchPage.ROUTE_NAME,
                    arguments: stateHome,
                  );
                },
                icon: Icon(Icons.search),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: stateHome == HomeState.TvSeries ? tvSeriesSection() : moviesSection(),
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
          Text(
            'Now Playing',
            style: kHeading6,
          ),
          BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(builder: (context, state) {
            if (state is NowPlayingMovieLoading) {
              return RowLoading();
            } else if (state is NowPlayingMovieSuccess) {
              return MovieList(state.movies);
            } else if (state is NowPlayingMovieError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
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
              return RowLoading();
            } else if (state is PopularMovieSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.movies);
            } else if (state is PopularMovieError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
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
              return RowLoading();
            } else if (state is TopRatedMovieSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.movies);
            } else if (state is TopRatedMovieError) {
              return DitontonErrorWidget(
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
          Text(
            'On The Air Tv Series',
            style: kHeading6,
          ),
          BlocBuilder<OnTheAirTvSeriesBloc, OnTheAirTvSeriesState>(builder: (context, state) {
            if (state is OnTheAirTvSeriesLoading) {
              return RowLoading();
            } else if (state is OnTheAirTvSeriesSuccess) {
              return MovieList(state.tvSeries);
            } else if (state is OnTheAirTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
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
              return RowLoading();
            } else if (state is PopularTvSeriesSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.tvSeries);
            } else if (state is PopularTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
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
              return RowLoading();
            } else if (state is TopRatedTvSeriesSuccess) {
              return MovieList.fromIdPosterTitleOverview(state.tvSeries);
            } else if (state is TopRatedTvSeriesError) {
              return DitontonErrorWidget(state.message, retry: state.retry);
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/enum/enum_home_state.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/id_and_data_type.dart';
import 'package:ditonton/presentation/bloc/home_state_handler/home_state_handler_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/on_the_air_tv_series/on_the_air_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_searies_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_status/watchlist_status_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/detail_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/tvseries/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tvseries/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesSearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistStatusBloc>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMovieBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<NowPlayingMovieBloc>()),
        BlocProvider(create: (_) => di.locator<HomeStateHandlerBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomePage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => HomePage(),
              );
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => PopularMoviesPage(),
              );
            case PopularTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => PopularTvSeriesPage(),
              );
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => TopRatedTvSeriesPage(),
              );
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                builder: (_) => TopRatedMoviesPage(),
              );
            case DetailPage.ROUTE_NAME:
              final id = settings.arguments as IdAndDataType;
              return MaterialPageRoute(
                builder: (_) => DetailPage(idAndDataType: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              final state = settings.arguments as HomeState;
              return CupertinoPageRoute(
                builder: (_) => SearchPage(homeState: state),
              );
            case WatchlistPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => WatchlistPage(),
              );
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(
                builder: (_) => AboutPage(),
              );
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}

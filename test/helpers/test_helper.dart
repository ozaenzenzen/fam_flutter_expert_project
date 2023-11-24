import 'package:ditonton/common/http_custom_client.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/datasources/watchlist_local_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/repositories/watch_list_repository.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  WatchlistLocalDataSource,
  WatchlistRepository,
  DatabaseHelper,
  TvRemoteDataSource,
  TvSeriesRepository,
], customMocks: [
  MockSpec<HttpCustomClient>(as: #MockHttpClient)
])
void main() {}

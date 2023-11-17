import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/common/failure.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getNowPlayingMovies();
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies();
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies();
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);
  Future<Either<Failure, List<MovieEntity>>> getMovieRecommendations(int id);
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
  // Future<Either<Failure, String>> saveWatchlist(MovieDetail movie);
  // Future<Either<Failure, String>> removeWatchlist(MovieDetail movie);
  // Future<bool> isAddedToWatchlist(int id);
  // Future<Either<Failure, List<Movie>>> getWatchlistMovies();
}

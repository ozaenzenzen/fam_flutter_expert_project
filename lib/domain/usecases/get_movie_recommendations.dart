import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie_entity.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<MovieEntity>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}

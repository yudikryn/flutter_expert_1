import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}

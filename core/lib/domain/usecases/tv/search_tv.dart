import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/repositories/tv_repository.dart';

import '../../../utils/failure.dart';

class SearchTv {
  final TvRepository repository;

  SearchTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTv(query);
  }
}

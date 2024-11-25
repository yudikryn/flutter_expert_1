import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/repositories/tv_repository.dart';

import '../../../utils/failure.dart';

class GetTvPopular {
  final TvRepository repository;

  GetTvPopular(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTv();
  }
}

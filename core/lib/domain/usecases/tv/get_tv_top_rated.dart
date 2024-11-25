import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/repositories/tv_repository.dart';

import '../../../utils/failure.dart';

class GetTvTopRated {
  final TvRepository repository;

  GetTvTopRated(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}

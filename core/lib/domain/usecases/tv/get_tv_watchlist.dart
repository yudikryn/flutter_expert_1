import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/repositories/tv_repository.dart';

import '../../../utils/failure.dart';

class GetTvWatchlist {
  final TvRepository repository;

  GetTvWatchlist(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getWatchlistTv();
  }
}

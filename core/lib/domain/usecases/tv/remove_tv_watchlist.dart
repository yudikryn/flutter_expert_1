import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv_detail.dart';
import '../../../domain/repositories/tv_repository.dart';

import '../../../utils/failure.dart';

class RemoveTvWatchlist {
  final TvRepository repository;

  RemoveTvWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlistTv(tv);
  }
}

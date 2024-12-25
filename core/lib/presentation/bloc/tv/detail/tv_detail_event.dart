part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddWatchlistTv extends TvDetailEvent {
  final TvDetail tvDetail;

  const AddWatchlistTv(this.tvDetail);

  @override
  List<Object?> get props => [TvDetail];
}

class RemoveFromWatchlistTv extends TvDetailEvent {
  final TvDetail tvDetail;

  const RemoveFromWatchlistTv(this.tvDetail);

  @override
  List<Object?> get props => [TvDetail];
}

class LoadWatchlistStatusTv extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatusTv(this.id);

  @override
  List<Object?> get props => [id];
}
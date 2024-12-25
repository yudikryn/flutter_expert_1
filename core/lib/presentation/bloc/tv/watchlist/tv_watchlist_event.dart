part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {
  const TvWatchlistEvent();
}

class FetchTvWatchlist extends TvWatchlistEvent {
  const FetchTvWatchlist();

  @override
  List<Object> get props => [];
}
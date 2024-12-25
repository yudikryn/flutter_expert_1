part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvWatchlistEmpty extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistHasData extends TvWatchlistState {
  final List<Tv> result;

  TvWatchlistHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  TvWatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
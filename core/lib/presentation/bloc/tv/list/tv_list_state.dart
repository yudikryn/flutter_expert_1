part of 'tv_list_bloc.dart';

abstract class TvListState extends Equatable {
  const TvListState();

  @override
  List<Object?> get props => [];
}

class TvListInitial extends TvListState {}

class TvListCombinedState extends TvListState {
  final List<Tv> airingToday;
  final List<Tv> popular;
  final List<Tv> topRated;

  TvListCombinedState({
    required this.airingToday,
    required this.popular,
    required this.topRated,
  });

  @override
  List<Object?> get props => [airingToday, popular, topRated];
}

// Now Playing Tv State
class AiringTodayTvEmpty extends TvListState {}

class AiringTodayTvLoading extends TvListState {}

class AiringTodayTvError extends TvListState {
  final String message;

  AiringTodayTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// Popular Tv State
class PopularTvEmpty extends TvListState {}

class PopularTvLoading extends TvListState {}

class PopularTvError extends TvListState {
  final String message;

  PopularTvError(this.message);

  @override
  List<Object?> get props => [message];
}

// Top Rated State
class TopRatedTvEmpty extends TvListState {}

class TopRatedTvLoading extends TvListState {}

class TopRatedTvError extends TvListState {
  final String message;

  TopRatedTvError(this.message);

  @override
  List<Object?> get props => [message];
}
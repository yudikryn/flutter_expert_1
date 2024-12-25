part of 'tv_popular_bloc.dart';

abstract class TvPopularEvent extends Equatable {
  const TvPopularEvent();
}

class FetchPopularTv extends TvPopularEvent {
  const FetchPopularTv();

  @override
  List<Object> get props => [];
}
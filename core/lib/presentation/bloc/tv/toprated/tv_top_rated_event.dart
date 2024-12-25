part of 'tv_top_rated_bloc.dart';

abstract class TvTopRatedEvent extends Equatable {
  const TvTopRatedEvent();
}

class FetchTopRatedTv extends TvTopRatedEvent {
  const FetchTopRatedTv();

  @override
  List<Object> get props => [];
}
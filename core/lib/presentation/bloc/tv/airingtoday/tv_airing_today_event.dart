part of 'tv_airing_today_bloc.dart';

abstract class TvAiringTodayEvent extends Equatable {
  const TvAiringTodayEvent();
}

class FetchAiringTodayTv extends TvAiringTodayEvent {
  const FetchAiringTodayTv();

  @override
  List<Object> get props => [];
}
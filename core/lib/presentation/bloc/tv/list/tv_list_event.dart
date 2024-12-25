part of 'tv_list_bloc.dart';

abstract class TvListEvent extends Equatable {
  const TvListEvent();
}

class FetchAllTv extends TvListEvent {
  const FetchAllTv();

  @override
  List<Object> get props => [];
}
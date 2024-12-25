import 'package:core/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/tv.dart';

part 'tv_airing_today_event.dart';
part 'tv_airing_today_state.dart';

class TvAiringTodayBloc extends Bloc<TvAiringTodayEvent, TvAiringTodayState> {
  final GetTvAiringToday _getTvAiringToday;

  TvAiringTodayBloc(this._getTvAiringToday) : super(TvAiringTodayEmpty()) {
    on<FetchAiringTodayTv>((event, emit) async {
      emit(TvAiringTodayLoading());

      final result = await _getTvAiringToday.execute();

      result.fold(
        (failure) {
          emit(TvAiringTodayError(failure.message));
        },
        (data) {
          emit(TvAiringTodayHasData(data));
        },
      );
    });
  }
}

import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/tv.dart';

part 'tv_top_rated_event.dart';
part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TvTopRatedEvent, TvTopRatedState> {
  final GetTvTopRated _getTvTopRated;

  TvTopRatedBloc(this._getTvTopRated) : super(TvTopRatedEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TvTopRatedLoading());

      final result = await _getTvTopRated.execute();

      result.fold(
        (failure) {
          emit(TvTopRatedError(failure.message));
        },
        (data) {
          emit(TvTopRatedHasData(data));
        },
      );
    });
  }
}

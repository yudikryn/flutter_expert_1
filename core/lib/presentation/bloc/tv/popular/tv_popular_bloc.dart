import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:core/domain/entities/tv.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetTvPopular _getTvPopular;

  TvPopularBloc(this._getTvPopular) : super(TvPopularEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(TvPopularLoading());

      final result = await _getTvPopular.execute();

      result.fold(
        (failure) {
          emit(TvPopularError(failure.message));
        },
        (data) {
          emit(TvPopularHasData(data));
        },
      );
    });
  }
}

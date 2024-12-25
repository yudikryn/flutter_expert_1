import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc
    extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetTvWatchlist _getTvWatchlist;

  TvWatchlistBloc(this._getTvWatchlist)
      : super(TvWatchlistEmpty()) {
    on<FetchTvWatchlist>((event, emit) async {
      emit(TvWatchlistLoading());

      final result = await _getTvWatchlist.execute();

      result.fold(
        (failure) => emit(TvWatchlistError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(TvWatchlistEmpty());
          } else {
            emit(TvWatchlistHasData(data));
          }
        },
      );
    });
  }
}
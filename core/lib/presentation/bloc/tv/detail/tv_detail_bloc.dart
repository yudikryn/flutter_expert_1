import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final SaveTvWatchlist saveTvWatchlist;
  final RemoveTvWatchlist removeTvWatchlist;
  final GetTvWatchlistStatus getTvWatchlistStatus;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.saveTvWatchlist,
    required this.removeTvWatchlist,
    required this.getTvWatchlistStatus,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading));

      final id = event.id;

      final tvDetailResult = await getTvDetail.execute(id);
      final recommendationTvsResult =
          await getTvRecommendations.execute(id);

      tvDetailResult.fold(
        (failure) => emit(
          state.copyWith(
            tvDetailState: RequestState.Error,
            message: failure.message,
          ),
        ),
        (tvDetail) {
          emit(
            state.copyWith(
              tvRecommendationsState: RequestState.Loading,
              tvDetailState: RequestState.Loaded,
              tvDetail: tvDetail,
              message: '',
            ),
          );
          recommendationTvsResult.fold(
            (failure) => emit(
              state.copyWith(
                tvRecommendationsState: RequestState.Error,
                message: failure.message,
              ),
            ),
            (tvRecommendations) {
              if (tvRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.Empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    tvRecommendationsState: RequestState.Loaded,
                    tvRecommendations: tvRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistTv>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await saveTvWatchlist.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(message: failure.message)),
        (successMessage) =>
            emit(state.copyWith(message: successMessage)),
      );

      add(LoadWatchlistStatusTv(tvDetail.id));
    });

    on<RemoveFromWatchlistTv>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await removeTvWatchlist.execute(tvDetail);

      result.fold(
        (failure) => emit(state.copyWith(message: failure.message)),
        (successMessage) =>
            emit(state.copyWith(message: successMessage)),
      );

      add(LoadWatchlistStatusTv(tvDetail.id));
    });

    on<LoadWatchlistStatusTv>((event, emit) async {
      final status = await getTvWatchlistStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
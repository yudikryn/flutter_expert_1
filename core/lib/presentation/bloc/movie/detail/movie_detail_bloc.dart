import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist.dart';
import 'package:core/domain/usecases/movie/save_watchlist.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetWatchListStatus getWatchListStatus;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchListStatus,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.Loading));

      final id = event.id;

      final MovieDetailResult = await getMovieDetail.execute(id);
      final recommendationMoviesResult =
          await getMovieRecommendations.execute(id);

      MovieDetailResult.fold(
        (failure) => emit(
          state.copyWith(
            movieDetailState: RequestState.Error,
            message: failure.message,
          ),
        ),
        (movieDetail) {
          emit(
            state.copyWith(
              movieRecommendationsState: RequestState.Loading,
              movieDetailState: RequestState.Loaded,
              movieDetail: movieDetail,
              message: '',
            ),
          );
          recommendationMoviesResult.fold(
            (failure) => emit(
              state.copyWith(
                movieRecommendationsState: RequestState.Error,
                message: failure.message,
              ),
            ),
            (movieRecommendations) {
              if (movieRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.Empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.Loaded,
                    movieRecommendations: movieRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlist.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(message: failure.message)),
        (successMessage) =>
            emit(state.copyWith(message: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<RemoveFromWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlist.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(message: failure.message)),
        (successMessage) =>
            emit(state.copyWith(message: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<LoadWatchlistStatusMovie>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
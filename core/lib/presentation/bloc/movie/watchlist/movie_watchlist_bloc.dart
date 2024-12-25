import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies _getMovieWatchlist;

  MovieWatchlistBloc(this._getMovieWatchlist)
      : super(MovieWatchlistEmpty()) {
    on<FetchMovieWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());

      final result = await _getMovieWatchlist.execute();

      result.fold(
        (failure) => emit(MovieWatchlistError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(MovieWatchlistEmpty());
          } else {
            emit(MovieWatchlistHasData(data));
          }
        },
      );
    });
  }
}
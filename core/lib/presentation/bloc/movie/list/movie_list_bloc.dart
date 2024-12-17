import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_list_state.dart';
part 'movie_list_event.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc(
      {required this.getNowPlayingMovies,
      required this.getPopularMovies,
      required this.getTopRatedMovies})
      : super(MovieListInitial()) {

    on<FetchAllMovies>((event, emit) async {
      emit(MovieListInitial());

      final nowPlayingResult = await getNowPlayingMovies.execute();
      final popularResult = await getPopularMovies.execute();
      final topRatedResult = await getTopRatedMovies.execute();

      List<Movie> nowPlaying = [];
      List<Movie> popular = [];
      List<Movie> topRated = [];

      String? errorMessage;

      nowPlayingResult.fold(
        (failure) {
          emit(NowPlayingMoviesError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(NowPlayingMoviesEmpty());
          else
            nowPlaying = data;
        },
      );

      popularResult.fold(
        (failure) {
          emit(PopularMoviesError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(PopularMoviesEmpty());
          else
            popular = data;
        },
      );

      topRatedResult.fold(
        (failure) {
          emit(TopRatedMoviesError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(TopRatedMoviesEmpty());
          else
            topRated = data;
        },
      );

      if (errorMessage == null) {
        emit(MovieListCombinedState(
          nowPlaying: nowPlaying,
          popular: popular,
          topRated: topRated,
        ));
      }
    });
  }
}

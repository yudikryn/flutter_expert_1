part of 'movie_list_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListInitial extends MovieListState {}

class MovieListCombinedState extends MovieListState {
  final List<Movie> nowPlaying;
  final List<Movie> popular;
  final List<Movie> topRated;

  MovieListCombinedState({
    required this.nowPlaying,
    required this.popular,
    required this.topRated,
  });

  @override
  List<Object?> get props => [nowPlaying, popular, topRated];
}

// Now Playing Movies State
class NowPlayingMoviesEmpty extends MovieListState {}

class NowPlayingMoviesLoading extends MovieListState {}

class NowPlayingMoviesError extends MovieListState {
  final String message;

  NowPlayingMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Popular Movies State
class PopularMoviesEmpty extends MovieListState {}

class PopularMoviesLoading extends MovieListState {}

class PopularMoviesError extends MovieListState {
  final String message;

  PopularMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Top Rated State
class TopRatedMoviesEmpty extends MovieListState {}

class TopRatedMoviesLoading extends MovieListState {}

class TopRatedMoviesError extends MovieListState {
  final String message;

  TopRatedMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
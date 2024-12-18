part of 'movie_popular_bloc.dart';

abstract class MoviePopularEvent extends Equatable {
  const MoviePopularEvent();
}

class FetchPopularMovies extends MoviePopularEvent {
  const FetchPopularMovies();

  @override
  List<Object> get props => [];
}
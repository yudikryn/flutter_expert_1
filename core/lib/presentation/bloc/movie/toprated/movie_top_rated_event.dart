part of 'movie_top_rated_bloc.dart';

abstract class MovieTopRatedEvent extends Equatable {
  const MovieTopRatedEvent();
}

class FetchTopRatedMovies extends MovieTopRatedEvent {
  const FetchTopRatedMovies();

  @override
  List<Object> get props => [];
}
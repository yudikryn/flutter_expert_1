part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();
}

class FetchAllMovies extends MovieListEvent {
  const FetchAllMovies();

  @override
  List<Object> get props => [];
}
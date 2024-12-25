part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final RequestState movieDetailState;
  final List<Movie> movieRecommendations;
  final RequestState movieRecommendationsState;
  final String message;
  final bool isAddedToWatchlist;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieDetailState,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.message,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props {
    return [
      movieDetail,
      movieDetailState,
      movieRecommendations,
      movieRecommendationsState,
      message,
      isAddedToWatchlist,
    ];
  }

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    RequestState? movieDetailState,
    List<Movie>? movieRecommendations,
    RequestState? movieRecommendationsState,
    String? message,
    bool? isAddedToWatchlist,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movieDetail: null,
      movieDetailState: RequestState.Empty,
      movieRecommendations: [],
      movieRecommendationsState: RequestState.Empty,
      message: '',
      isAddedToWatchlist: false,
    );
  }
}
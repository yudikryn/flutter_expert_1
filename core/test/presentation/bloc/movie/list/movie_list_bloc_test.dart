import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:core/presentation/bloc/movie/list/movie_list_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMoviesList = <Movie>[testMovie];

  test('initial state should be MovieListInitial', () {
    expect(movieListBloc.state, MovieListInitial());
  });

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, MovieListCombinedState] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      MovieListCombinedState(
        nowPlaying: tMoviesList,
        popular: tMoviesList,
        topRated: tMoviesList,
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, NowPlayingMoviesError] when getting now playing movies fails',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      NowPlayingMoviesError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, PopularMoviesError] when getting popular movies fails',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      PopularMoviesError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, TopRatedMoviesError] when getting top rated movies fails',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      TopRatedMoviesError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, NowPlayingMoviesEmpty] when now playing movies data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right([]));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      NowPlayingMoviesEmpty(),
      MovieListCombinedState(
        nowPlaying: [],
        popular: tMoviesList,
        topRated: tMoviesList,
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, PopularMoviesEmpty] when popular movies data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetPopularMovies.execute()).thenAnswer((_) async => Right([]));
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      PopularMoviesEmpty(),
      MovieListCombinedState(
        nowPlaying: tMoviesList,
        popular: [],
        topRated: tMoviesList,
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );

  blocTest<MovieListBloc, MovieListState>(
    'Should emit [MovieListInitial, TopRatedMoviesEmpty] when top rated movies data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMoviesList));
      when(mockGetTopRatedMovies.execute()).thenAnswer((_) async => Right([]));
      return movieListBloc;
    },
    act: (bloc) => bloc.add(FetchAllMovies()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      MovieListInitial(),
      TopRatedMoviesEmpty(),
      MovieListCombinedState(
        nowPlaying: tMoviesList,
        popular: tMoviesList,
        topRated: [],
      ),
    ],
    verify: (_) => [
      verify(mockGetNowPlayingMovies.execute()),
      verify(mockGetPopularMovies.execute()),
      verify(mockGetTopRatedMovies.execute()),
    ],
  );
}

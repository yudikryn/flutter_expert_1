import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/presentation/bloc/movie/watchlist/movie_watchlist_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MovieWatchlistBloc movieWatchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(mockGetWatchlistMovies);
  });

  final tWatchlistMoviesList = <Movie>[testWatchlistMovie];

  test('initial state should be empty', () {
    expect(movieWatchlistBloc.state, MovieWatchlistEmpty());
  });

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tWatchlistMoviesList));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieWatchlist()),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistHasData(tWatchlistMoviesList),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      const FetchMovieWatchlist().props,
    ],
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieWatchlist()),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistEmpty(),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      const FetchMovieWatchlist().props,
    ],
  );

  blocTest<MovieWatchlistBloc, MovieWatchlistState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return movieWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchMovieWatchlist()),
    expect: () => [
      MovieWatchlistLoading(),
      MovieWatchlistError('Database Failure'),
    ],
    verify: (_) => [
      verify(mockGetWatchlistMovies.execute()),
      const FetchMovieWatchlist().props,
    ],
  );
}

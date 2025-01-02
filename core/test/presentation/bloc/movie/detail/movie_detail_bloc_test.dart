import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_watchlist_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist.dart';
import 'package:core/domain/usecases/movie/save_watchlist.dart';
import 'package:core/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetRecommendationMovies;
  late MockGetWatchListStatus mockGetWatchListStatusMovie;
  late MockSaveWatchlist mockSaveWatchlistMovie;
  late MockRemoveWatchlist mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetRecommendationMovies = MockGetMovieRecommendations();
    mockGetWatchListStatusMovie = MockGetWatchListStatus();
    mockSaveWatchlistMovie = MockSaveWatchlist();
    mockRemoveWatchlistMovie = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetRecommendationMovies,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
      getWatchListStatus: mockGetWatchListStatusMovie,
    );
  });

  const tId = 1;

  group(
    'Get Detail Movie',
    () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Shoud emit [MovieDetailLoading, MovieDetailLoaded, RecomendationLoading, RecommendationLoaded] when get detail movie and recommendation movies success',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetRecommendationMovies.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          MovieDetailState.initial().copyWith(
            movieRecommendationsState: RequestState.Loading,
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationsState: RequestState.Loaded,
            movieRecommendations: testMovieList,
          ),
        ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetRecommendationMovies.execute(tId));
          const FetchMovieDetail(tId).props;
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'Shoud emit [MovieDetailError] when get detail movie failed',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
          when(mockGetRecommendationMovies.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Error,
            message: 'Failed',
          ),
        ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetRecommendationMovies.execute(tId));
          const FetchMovieDetail(tId).props;
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'Shoud emit [MovieDetailLoading, MovieDetailLoaded, RecommendationEmpty] when get recommendation movies empty',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetRecommendationMovies.execute(tId))
              .thenAnswer((_) async => const Right([]));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          MovieDetailState.initial().copyWith(
            movieRecommendationsState: RequestState.Loading,
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationsState: RequestState.Empty,
          ),
        ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetRecommendationMovies.execute(tId));
          const FetchMovieDetail(tId).props;
        },
      );

      blocTest<MovieDetailBloc, MovieDetailState>(
        'Shoud emit [MovieDetailLoading, RecomendationLoading, MovieDetailLoaded, RecommendationError] when get recommendation movies failed',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async =>  Right(testMovieDetail));
          when(mockGetRecommendationMovies.execute(tId))
              .thenAnswer((_) async =>  Left(ConnectionFailure('Failed')));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
        expect: () => [
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loading,
          ),
          MovieDetailState.initial().copyWith(
            movieRecommendationsState: RequestState.Loading,
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationsState: RequestState.Error,
            message: 'Failed',
          ),
        ],
        verify: (_) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetRecommendationMovies.execute(tId));
          const FetchMovieDetail(tId).props;
        },
      );
    },
  );

  group('Load Watchlist Status Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusMovie.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        MovieDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetWatchListStatusMovie.execute(tId)),
        const LoadWatchlistStatusMovie(tId).props,
      ],
    );
  });

  group('Added To Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          message: 'Added to Watchlist',
        ),
        MovieDetailState.initial().copyWith(
          message: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        AddWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(message: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        AddWatchlistMovie(testMovieDetail).props;
      },
    );
  });

  group('Remove From Watchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(
          message: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Shoud emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusMovie.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        MovieDetailState.initial().copyWith(message: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListStatusMovie.execute(testMovieDetail.id));
        RemoveFromWatchlistMovie(testMovieDetail).props;
      },
    );
  });
}

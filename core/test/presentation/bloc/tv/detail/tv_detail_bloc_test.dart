
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/usecases/tv/get_tv_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_watchlist.dart';
import 'package:core/presentation/bloc/tv/detail/tv_detail_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchlistStatus,
  SaveTvWatchlist,
  RemoveTvWatchlist,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;
  late MockSaveTvWatchlist mockSaveTvWatchlist;
  late MockRemoveTvWatchlist mockRemoveTvWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    mockSaveTvWatchlist = MockSaveTvWatchlist();
    mockRemoveTvWatchlist = MockRemoveTvWatchlist();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      saveTvWatchlist: mockSaveTvWatchlist,
      removeTvWatchlist: mockRemoveTvWatchlist,
      getTvWatchlistStatus: mockGetTvWatchlistStatus,
    );
  });

const tId = 1;

  group(
    'Get Detail Tv',
    () {
      blocTest<TvDetailBloc, TvDetailState>(
        'Shoud emit [TvDetailLoading, TvDetailLoaded, RecomendationLoading, RecommendationLoaded] when get detail tv and recommendation tv success',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testTvList));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchTvDetail(tId)),
        expect: () => [
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loading,
          ),
          TvDetailState.initial().copyWith(
            tvRecommendationsState: RequestState.Loading,
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationsState: RequestState.Loaded,
            tvRecommendations: testTvList,
          ),
        ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecommendations.execute(tId));
          const FetchTvDetail(tId).props;
        },
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'Shoud emit [TvDetailError] when get detail tv failed',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async => Right(testTvList));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchTvDetail(tId)),
        expect: () => [
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loading,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Error,
            message: 'Failed',
          ),
        ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecommendations.execute(tId));
          const FetchTvDetail(tId).props;
        },
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'Shoud emit [TvDetailLoading, TvDetailLoaded, RecommendationEmpty] when get recommendation tv empty',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async => const Right([]));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchTvDetail(tId)),
        expect: () => [
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loading,
          ),
          TvDetailState.initial().copyWith(
            tvRecommendationsState: RequestState.Loading,
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationsState: RequestState.Empty,
          ),
        ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecommendations.execute(tId));
          const FetchTvDetail(tId).props;
        },
      );

      blocTest<TvDetailBloc, TvDetailState>(
        'Shoud emit [TvDetailLoading, RecomendationLoading, TvDetailLoaded, RecommendationError] when get recommendation tv failed',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async =>  Right(testTvDetail));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async =>  Left(ConnectionFailure('Failed')));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(const FetchTvDetail(tId)),
        expect: () => [
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loading,
          ),
          TvDetailState.initial().copyWith(
            tvRecommendationsState: RequestState.Loading,
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationsState: RequestState.Error,
            message: 'Failed',
          ),
        ],
        verify: (_) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecommendations.execute(tId));
          const FetchTvDetail(tId).props;
        },
      );
    },
  );

  group('Load Watchlist Status Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistStatus] is true',
      build: () {
        when(mockGetTvWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTv(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => [
        verify(mockGetTvWatchlistStatus.execute(tId)),
        const LoadWatchlistStatusTv(tId).props,
      ],
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [WatchlistStatus] is false',
      build: () {
        when(mockGetTvWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusTv(tId)),
      expect: () => [
        TvDetailState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => [
        verify(mockGetTvWatchlistStatus.execute(tId)),
        const LoadWatchlistStatusTv(tId).props,
      ],
    );
  });

  group('Added To Watchlist Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success added to watchlist',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          message: 'Added to Watchlist',
        ),
        TvDetailState.initial().copyWith(
          message: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        AddWatchlistTv(testTvDetail).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Shoud emit [WatchlistMessage] when failed added to watchlist',
      build: () {
        when(mockSaveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(message: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        AddWatchlistTv(testTvDetail).props;
      },
    );
  });

  group('Remove From Watchlist Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Shoud emit [WatchlistMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(
          message: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        RemoveFromWatchlistTv(testTvDetail).props;
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Shoud emit [WatchlistMessage] when failed removed from watchlist',
      build: () {
        when(mockRemoveTvWatchlist.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetTvWatchlistStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTv(testTvDetail)),
      expect: () => [
        TvDetailState.initial().copyWith(message: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveTvWatchlist.execute(testTvDetail));
        verify(mockGetTvWatchlistStatus.execute(testTvDetail.id));
        RemoveFromWatchlistTv(testTvDetail).props;
      },
    );
  });
}
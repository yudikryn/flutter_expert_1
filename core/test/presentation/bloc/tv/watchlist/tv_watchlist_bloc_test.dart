import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist.dart';
import 'package:core/presentation/bloc/tv/watchlist/tv_watchlist_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetTvWatchlist])
void main() {
  late TvWatchlistBloc tvWatchlistBloc;
  late MockGetTvWatchlist mockGetTvWatchlist;

  setUp(() {
    mockGetTvWatchlist = MockGetTvWatchlist();
    tvWatchlistBloc = TvWatchlistBloc(mockGetTvWatchlist);
  });

  final tWatchlistTvList = <Tv>[testWatchlistTv];

  test('initial state should be empty', () {
    expect(tvWatchlistBloc.state, TvWatchlistEmpty());
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvWatchlist.execute())
          .thenAnswer((_) async => Right(tWatchlistTvList));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      TvWatchlistHasData(tWatchlistTvList),
    ],
    verify: (_) => [
      verify(mockGetTvWatchlist.execute()),
      const FetchTvWatchlist().props,
    ],
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetTvWatchlist.execute())
          .thenAnswer((_) async => const Right([]));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      TvWatchlistEmpty(),
    ],
    verify: (_) => [
      verify(mockGetTvWatchlist.execute()),
      const FetchTvWatchlist().props,
    ],
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
    build: () {
      when(mockGetTvWatchlist.execute())
          .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
      return tvWatchlistBloc;
    },
    act: (bloc) => bloc.add(const FetchTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      TvWatchlistError('Database Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvWatchlist.execute()),
      const FetchTvWatchlist().props,
    ],
  );
}
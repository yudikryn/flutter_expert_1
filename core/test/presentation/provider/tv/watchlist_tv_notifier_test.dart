import 'package:core/core.dart';
import 'package:core/domain/usecases/tv/get_tv_watchlist.dart';
import 'package:core/presentation/provider/tv/tv_watchlist_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetTvWatchlist])
void main() {
  late TvWatchlistNotifier provider;
  late MockGetTvWatchlist mockGetTvWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvWatchlist = MockGetTvWatchlist();
    provider = TvWatchlistNotifier(
      getTvWatchlist: mockGetTvWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetTvWatchlist.execute())
        .thenAnswer((_) async => Right([testWatchlistTv]));
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.Loaded);
    expect(provider.watchlistTv, [testWatchlistTv]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTvWatchlist.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlistTv();
    // assert
    expect(provider.watchlistState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}

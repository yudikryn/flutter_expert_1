import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:core/presentation/provider/tv/tv_list_notifier.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetTvAiringToday, GetTvPopular, GetTvTopRated])
void main() {
  late TvListNotifier provider;
  late MockGetTvAiringToday mockGetTvAiringToday;
  late MockGetTvPopular mockGetTvPopular;
  late MockGetTvTopRated mockGetTvTopRated;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvAiringToday = MockGetTvAiringToday();
    mockGetTvPopular = MockGetTvPopular();
    mockGetTvTopRated = MockGetTvTopRated();
    provider = TvListNotifier(
        getTvAiringToday: mockGetTvAiringToday,
        getTvPopular: mockGetTvPopular,
        getTvTopRated: mockGetTvTopRated)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTv = Tv(
    adult: false,
    backdropPath: '/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg',
    genreIds: [10765, 18, 10759],
    id: 94997,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'House of the Dragon',
    name: 'House of the Dragon',
    firstAirDate: '2022-08-21',
    overview:
        'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
    popularity: 5772.936,
    posterPath: '/t9XkeE7HzOsdQcDDDapDYh8Rrmt.jpg',
    voteAverage: 8.425,
    voteCount: 4186,
  );

  final tTvList = <Tv>[tTv];

  group('tv airing today', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayTvState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTv();
      // assert
      verify(mockGetTvAiringToday.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayTvState, RequestState.Loading);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayTvState, RequestState.Loaded);
      expect(provider.airingToday, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchAiringTodayTv();
      // assert
      expect(provider.airingTodayTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchPopularTv();
      // assert
      expect(provider.popularTvState, RequestState.Loading);
      // verify(provider.setState(RequestState.Loading));
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.popularTvState, RequestState.Loaded);
      expect(provider.popularTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvPopular.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchPopularTv();
      // assert
      expect(provider.popularTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

   group('top rated tv', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Loading);
    });

    test('should change movies data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Loaded);
      expect(provider.topRatedTv, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTopRatedTv();
      // assert
      expect(provider.topRatedTvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}

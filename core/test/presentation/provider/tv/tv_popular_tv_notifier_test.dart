import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:core/presentation/provider/tv/tv_popular_notifier.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetTvPopular])
void main() {
  late MockGetTvPopular mockGetTvPopular;
  late TvPopularNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvPopular = MockGetTvPopular();
    notifier = TvPopularNotifier(getTvPopular: mockGetTvPopular)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvModel = Tv(
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
  final tTvList = <Tv>[tTvModel];

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetTvPopular.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchPopularTv();
    // assert
    expect(notifier.popularTvState, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv data when data is gotten successfully', () async {
    // arrange
    when(mockGetTvPopular.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.popularTvState, RequestState.Loaded);
    expect(notifier.popularTv, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTvPopular.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchPopularTv();
    // assert
    expect(notifier.popularTvState, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}

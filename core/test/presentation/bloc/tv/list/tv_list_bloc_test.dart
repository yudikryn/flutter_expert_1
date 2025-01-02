import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:core/presentation/bloc/tv/list/tv_list_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetTvAiringToday, GetTvPopular, GetTvTopRated])
void main() {
  late TvListBloc tvListBloc;
  late MockGetTvAiringToday mockGetTvAiringToday;
  late MockGetTvPopular mockGetTvPopular;
  late MockGetTvTopRated mockGetTvTopRated;

  setUp(() {
    mockGetTvAiringToday = MockGetTvAiringToday();
    mockGetTvPopular = MockGetTvPopular();
    mockGetTvTopRated = MockGetTvTopRated();
    tvListBloc = TvListBloc(
      getTvAiringToday: mockGetTvAiringToday,
      getPopularTv: mockGetTvPopular,
      getTopRatedTv: mockGetTvTopRated,
    );
  });

  final tTvList = <Tv>[testTv];

  test('initial state should be TvListInitial', () {
    expect(tvListBloc.state, TvListInitial());
  });

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, TvListCombinedState] when data is gotten successfully',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right(tTvList));
      when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      TvListCombinedState(
        airingToday: tTvList,
        popular: tTvList,
        topRated: tTvList,
      ),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, AiringTodayTvError] when getting now playing tv fails',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right(tTvList));
      when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      AiringTodayTvError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, PopularTvError] when getting popular tv fails',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvPopular.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      PopularTvError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, TopRatedTvError] when getting top rated tv fails',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right(tTvList));
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      TopRatedTvError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, AiringTodayTvEmpty] when now playing tv data is empty',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right([]));
      when(mockGetTvPopular.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      AiringTodayTvEmpty(),
      TvListCombinedState(
        airingToday: [],
        popular: tTvList,
        topRated: tTvList,
      ),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, PopularTvEmpty] when popular tv data is empty',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvPopular.execute()).thenAnswer((_) async => Right([]));
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      PopularTvEmpty(),
      TvListCombinedState(
        airingToday: tTvList,
        popular: [],
        topRated: tTvList,
      ),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );

  blocTest<TvListBloc, TvListState>(
    'Should emit [TvListInitial, TopRatedTvEmpty] when top rated tv data is empty',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvPopular.execute())
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetTvTopRated.execute()).thenAnswer((_) async => Right([]));
      return tvListBloc;
    },
    act: (bloc) => bloc.add(FetchAllTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvListInitial(),
      TopRatedTvEmpty(),
      TvListCombinedState(
        airingToday: tTvList,
        popular: tTvList,
        topRated: [],
      ),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      verify(mockGetTvPopular.execute()),
      verify(mockGetTvTopRated.execute()),
    ],
  );
}

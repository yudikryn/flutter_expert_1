import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:core/presentation/bloc/tv/airingtoday/tv_airing_today_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_airing_today_bloc_test.mocks.dart';

@GenerateMocks([GetTvAiringToday])
void main() {
  late TvAiringTodayBloc tvAiringTodayBloc;
  late MockGetTvAiringToday mockGetTvAiringToday;

  setUp(() {
    mockGetTvAiringToday = MockGetTvAiringToday();
    tvAiringTodayBloc = TvAiringTodayBloc(mockGetTvAiringToday);
  });

  final tTvList = <Tv>[testTv];
 test('initial state should be empty', () {
    expect(tvAiringTodayBloc.state, TvAiringTodayEmpty());
  });

  blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvAiringToday.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(const FetchAiringTodayTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayHasData(tTvList),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      const FetchAiringTodayTv().props,
    ],
  );

    blocTest<TvAiringTodayBloc, TvAiringTodayState>(
    'Should emit [Loading, Error] when get AiringToday movies is unsuccessful',
    build: () {
      when(mockGetTvAiringToday.execute())
         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvAiringTodayBloc;
    },
    act: (bloc) => bloc.add(const FetchAiringTodayTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvAiringTodayLoading(),
      TvAiringTodayError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvAiringToday.execute()),
      const FetchAiringTodayTv().props,
    ],
  );
}
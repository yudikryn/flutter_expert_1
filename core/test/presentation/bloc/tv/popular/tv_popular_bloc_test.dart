
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:core/presentation/bloc/tv/popular/tv_popular_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_popular_bloc_test.mocks.dart';

@GenerateMocks([GetTvPopular])
void main() {
  late TvPopularBloc tvPopularBloc;
  late MockGetTvPopular mockGetTvPopular;

  setUp(() {
    mockGetTvPopular = MockGetTvPopular();
    tvPopularBloc = TvPopularBloc(mockGetTvPopular);
  });

  final tTvList = <Tv>[testTv];

  test('initial state should be empty', () {
    expect(tvPopularBloc.state, TvPopularEmpty());
  });

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvPopular.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvPopularLoading(),
      TvPopularHasData(tTvList),
    ],
    verify: (_) => [
      verify(mockGetTvPopular.execute()),
      const FetchPopularTv().props,
    ],
  );

    blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetTvPopular.execute())
         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(const FetchPopularTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvPopularLoading(),
      TvPopularError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvPopular.execute()),
      const FetchPopularTv().props,
    ],
  );
}
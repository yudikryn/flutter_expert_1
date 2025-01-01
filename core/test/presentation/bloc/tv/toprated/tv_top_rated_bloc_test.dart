
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:core/presentation/bloc/tv/toprated/tv_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/dummy_objects.dart';
import 'tv_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTvTopRated])
void main() {
  late TvTopRatedBloc tvTopRatedBloc;
  late MockGetTvTopRated mockGetTvTopRated;

  setUp(() {
    mockGetTvTopRated = MockGetTvTopRated();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTvTopRated);
  });

 final tTvList = <Tv>[testTv];
 test('initial state should be empty', () {
    expect(tvTopRatedBloc.state, TvTopRatedEmpty());
  });

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvTopRated.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedHasData(tTvList),
    ],
    verify: (_) => [
      verify(mockGetTvTopRated.execute()),
      const FetchTopRatedTv().props,
    ],
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Error] when get TopRated Tv is unsuccessful',
    build: () {
      when(mockGetTvTopRated.execute())
         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(const FetchTopRatedTv()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      TvTopRatedLoading(),
      TvTopRatedError('Server Failure'),
    ],
    verify: (_) => [
      verify(mockGetTvTopRated.execute()),
      const FetchTopRatedTv().props,
    ],
  );
}
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvTopRated usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvTopRated(mockTvRepository);
  });

  final tTv = <Tv>[];

  test('should get list of tv from the repository', () async {
    // arrange
    when(mockTvRepository.getTopRatedTv())
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTv));
  });
}

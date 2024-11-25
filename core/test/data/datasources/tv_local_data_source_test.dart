
import 'package:core/core.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist tv', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertTvWatchlist(testTvTable);
      // assert
      expect(result, 'Added to Watchlist TV');
    });

    test('should throw DatabaseException when insert to database is failed', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(testTvTable)).thenThrow(Exception());
      // act
      final result = dataSource.insertTvWatchlist(testTvTable);
      // assert
      expect(() => result, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist tv', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeTvWatchlist(testTvTable);
      // assert
      expect(result, 'Removed from Watchlist TV');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(testTvTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeTvWatchlist(testTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Tv Detail By Id', () {
    final tId = 1;

    test('should return TV Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId))
          .thenAnswer((_) async => testTvMap);
      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, null);
    });
  });

    group('get watchlist tv', () {
    test('should return list of TvTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTv())
          .thenAnswer((_) async => [testTvMap]);
      // act
      final result = await dataSource.getWatchlistTv();
      // assert
      expect(result, [testTvTable]);
    });
  });
}

import 'dart:convert';

import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: '2022-08-21',
    episodeCount: 53,
    id: 309556,
    name: 'Specials',
    overview: '',
    posterPath: '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
    seasonNumber: 0,
    voteAverage: 0.0,
  );

  final tSeason = Season(
    airDate: '2022-08-21',
    episodeCount: 53,
    id: 309556,
    name: 'Specials',
    overview: '',
    posterPath: '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
    seasonNumber: 0,
    voteAverage: 0.0,
  );

  group('toEntity', () {
    test('should be a subclass of Season entity', () async {
      final result = tSeasonModel.toEntity();
      expect(result, tSeason);
    });
  });

  final tListSeasonModel = <SeasonModel>[tSeasonModel];

  group('fromJson & toJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));
      // act
      final listSeason = TvDetailResponse.fromJson(jsonMap).seasons;
      final seasonMap = listSeason.map((season) => season.toJson());
      final result = seasonMap.map((season)=> SeasonModel.fromJson(season));
   
      // assert
      expect(result.toList(), tListSeasonModel);
    });
  });
}

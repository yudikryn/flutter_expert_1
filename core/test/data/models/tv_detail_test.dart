
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/season_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTvDetailResponse = TvDetailResponse(
    adult: false,
    backdropPath: '/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg',
    episodeRunTime: [],
    firstAirDate: '2022-08-21',
    genres: [GenreModel(id: 10765, name: 'Sci-Fi & Fantasy')],
    homepage: "https://www.hbo.com/house-of-the-dragon",
    id: 94997,
    inProduction: true,
    languages: ['en'],
    lastAirDate: '2024-06-23',
    name: 'House of the Dragon',
    numberOfEpisodes: 18,
    numberOfSeasons: 2,
    originalLanguage: 'en',
    originalName: 'House of the Dragon',
    overview:
        'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
    popularity: 5772.936,
    posterPath: '/t9XkeE7HzOsdQcDDDapDYh8Rrmt.jpg',
    seasons: [
      SeasonModel(
          airDate: '2022-08-21',
          episodeCount: 53,
          id: 309556,
          name: 'Specials',
          overview: '',
          posterPath: '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
          seasonNumber: 0,
          voteAverage: 0.0)
    ],
    type: 'Scripted',
    status: 'Returning Series',
    tagline: 'All must choose.',
    voteAverage: 8.424,
    voteCount: 4189,
  );

  group('toEntity', () {
    test('should be a subclass of TvDetail entity', () async {
      final result = tTvDetailResponse.toEntity();
      expect(result, testTvDetail);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg",
        "episode_run_time": [],
        "first_air_date": "2022-08-21",
        "genres": [
          {"id": 10765, "name": "Sci-Fi & Fantasy"}
        ],
        "homepage": "https://www.hbo.com/house-of-the-dragon",
        "id": 94997,
        "in_production": true,
        "languages": ["en"],
        "last_air_date": "2024-06-23",
        "name": 'House of the Dragon',
        "number_of_episodes": 18,
        "number_of_seasons": 2,
        "original_language": "en",
        "original_name": "House of the Dragon",
        "overview":
            "The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.",
        "popularity": 5772.936,
        "poster_path": "/t9XkeE7HzOsdQcDDDapDYh8Rrmt.jpg",
        "seasons": [
          {
            "air_date": "2022-08-21",
            "episode_count": 53,
            "id": 309556,
            "name": "Specials",
            "overview": "",
            "poster_path": "/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg",
            "season_number": 0,
            "vote_average": 0.0
          }
        ],
        "type": "Scripted",
        "status": "Returning Series",
        "tagline": "All must choose.",
        "vote_average": 8.424,
        "vote_count": 4189
      };
      expect(result, expectedJsonMap);
    });
  });
}

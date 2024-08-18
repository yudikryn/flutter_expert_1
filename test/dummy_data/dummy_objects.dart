import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
  adult: false,
  backdropPath: '/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg',
  genreIds: [10765, 18, 10759],
  id: 94997,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'House of the Dragon',
  overview:
      'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
  popularity: 5772.936,
  posterPath: '/t9XkeE7HzOsdQcDDDapDYh8Rrmt.jpg',
  firstAirDate: '2022-08-21',
  name: 'House of the Dragon',
  voteAverage: 8.425,
  voteCount: 4186,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg',
  episodeRunTime: [],
  firstAirDate: '2022-08-21',
  genres: [Genre(id: 10765, name: 'Sci-Fi & Fantasy')],
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
    Season(
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

final testWatchlistTv = Tv.watchlist(
  id: 94997,
  name: 'House of the Dragon',
  posterPath: '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
  overview: 'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
);

final testTvTable = TvTable(
  id: 94997,
  name: 'House of the Dragon',
  posterPath: '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
  overview: 'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
);

final testTvMap = {
  'id': 94997,
  'overview': 'The Targaryen dynasty is at the absolute apex of its power, with more than 15 dragons under their yoke. Most empires crumble from such heights. In the case of the Targaryens, their slow fall begins when King Viserys breaks with a century of tradition by naming his daughter Rhaenyra heir to the Iron Throne. But when Viserys later fathers a son, the court is shocked when Rhaenyra retains her status as his heir, and seeds of division sow friction across the realm.',
  'posterPath': '/qVU4112Ob2ikHBu4VRC50MdWZcM.jpg',
  'name': 'House of the Dragon',
};

// Local
final testTvDetailLocal = TvDetail(
  adult: false,
  backdropPath: '/etj8E2o0Bud0HkONVQPjyCkIvpv.jpg',
  episodeRunTime: [],
  firstAirDate: '2022-08-21',
  genres: [Genre(id: 10765, name: 'Sci-Fi & Fantasy')],
  homepage: "https://www.hbo.com/house-of-the-dragon",
  id: 1,
  inProduction: true,
  languages: ['en'],
  lastAirDate: '2024-06-23',
  name: 'name',
  numberOfEpisodes: 18,
  numberOfSeasons: 2,
  originalLanguage: 'en',
  originalName: 'House of the Dragon',
  overview:
      'overview',
  popularity: 5772.936,
  posterPath: 'posterPath',
  seasons: [
    Season(
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

final testWatchlistTvLocal = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTableLocal = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMapLocal = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};


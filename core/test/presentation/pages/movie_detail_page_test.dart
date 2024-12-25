import 'package:flutter/material.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/presentation/bloc/movie/detail/movie_detail_bloc.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeDetailMovieEvent extends Fake implements MovieDetailEvent {}

class FakeDetailMovieState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeDetailMovieEvent());
    registerFallbackValue(FakeDetailMovieState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Loaded,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButton = find.byKey(const Key('watchlistButton'));
    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(watchlistButton, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(
      MovieDetailState.initial().copyWith(
        movieDetailState: RequestState.Loaded,
        movieDetail: testMovieDetail,
        movieRecommendationsState: RequestState.Loaded,
        movieRecommendations: [testMovie],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButton = find.byKey(const Key('watchlistButton'));
    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(watchlistButton, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          message: 'Added to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist');

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(snackbar, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackbar, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockMovieDetailBloc,
      Stream.fromIterable([
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        MovieDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          message: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: MovieDetailState.initial(),
    );

    final alertDialog = find.byType(AlertDialog);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(alertDialog, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(alertDialog, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });
}

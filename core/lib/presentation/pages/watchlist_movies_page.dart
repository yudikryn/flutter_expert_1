import 'package:core/presentation/bloc/movie/watchlist/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc/tv/watchlist/tv_watchlist_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../widgets/movie_card_list.dart';
import '../widgets/tv_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MovieWatchlistBloc>().add(const FetchMovieWatchlist());
      context.read<TvWatchlistBloc>().add(const FetchTvWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<MovieWatchlistBloc>().add(const FetchMovieWatchlist());
    context.read<TvWatchlistBloc>().add(const FetchTvWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return _watchlistTab();
  }

  Widget _watchlistTab() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'Movie'),
              Tab(icon: Icon(Icons.tv), text: 'TV'),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          children: [
            _contentTabMovie(),
            _contentTabTv(),
          ],
        ),
      ),
    );
  }

  Widget _contentTabMovie() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<MovieWatchlistBloc, MovieWatchlistState>(
        builder: (_, state) {
          if (state is MovieWatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieWatchlistHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if (state is MovieWatchlistError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility_off, size: 72),
                    const SizedBox(height: 2),
                    Text('Empty Watchlist Movie', style: kSubtitle),
                  ],
                ),
            );
          }
        },
      ),
    );
  }

  Widget _contentTabTv() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TvWatchlistBloc, TvWatchlistState>(
        builder: (_, state) {
          if (state is TvWatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvWatchlistHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TvCard(tv);
              },
              itemCount: state.result.length,
            );
          } else if (state is TvWatchlistError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility_off, size: 72),
                    const SizedBox(height: 2),
                    Text('Empty Watchlist Tv', style: kSubtitle),
                  ],
                ),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

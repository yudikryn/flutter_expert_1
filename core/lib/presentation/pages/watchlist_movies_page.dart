import '../../core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../provider/movie/watchlist_movie_notifier.dart';
import '../provider/tv/tv_watchlist_notifier.dart';
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
      Provider.of<WatchlistMovieNotifier>(context, listen: false)
          .fetchWatchlistMovies();

      Provider.of<TvWatchlistNotifier>(context, listen: false)
          .fetchWatchlistTv();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false).fetchWatchlistMovies();

    Provider.of<TvWatchlistNotifier>(context, listen: false).fetchWatchlistTv();
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
          title: Text('Watchlist'),
          bottom: TabBar(
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
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }

  Widget _contentTabTv() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<TvWatchlistNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = data.watchlistTv[index];
                return TvCard(tv);
              },
              itemCount: data.watchlistTv.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(data.message),
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

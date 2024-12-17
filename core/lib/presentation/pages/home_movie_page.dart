import 'package:core/presentation/bloc/movie/list/movie_list_bloc.dart';

import 'list_tv_page.dart';
import 'movie_detail_page.dart';
import 'popular_movies_page.dart';
import 'top_rated_movies_page.dart';
import 'watchlist_movies_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/movie.dart';
import '../../core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/routes.dart';
import 'package:flutter/material.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: const Text('TV'),
              onTap: () {
                Navigator.pushNamed(context, ListTvPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: TYPE_MOVIE,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (_, state) {
                  if (state is NowPlayingMoviesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieListCombinedState) {
                    return MovieList(state.nowPlaying);
                  } else if (state is NowPlayingMoviesError) {
                    return Center(child: Text(state.message));
                  } else if (state is NowPlayingMoviesEmpty) {
                    return const Center(
                        child: Text('No Now Playing Movies Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (_, state) {
                  if (state is PopularMoviesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieListCombinedState) {
                    return MovieList(state.popular);
                  } else if (state is PopularMoviesError) {
                    return Center(child: Text(state.message));
                  } else if (state is PopularMoviesEmpty) {
                    return const Center(child: Text('No Popular Movies Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              BlocBuilder<MovieListBloc, MovieListState>(
                builder: (_, state) {
                  if (state is TopRatedMoviesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MovieListCombinedState) {
                    return MovieList(state.topRated);
                  } else if (state is TopRatedMoviesError) {
                    return Center(child: Text(state.message));
                  } else if (state is TopRatedMoviesEmpty) {
                    return const Center(
                        child: Text('No Top Rated Movies Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie/toprated/movie_top_rated_bloc.dart';
import '../widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
 
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MovieTopRatedBloc>().add(const FetchTopRatedMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
          builder: (_, state) {
            if (state is MovieTopRatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieTopRatedHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is MovieTopRatedError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message));
            } else if (state is MovieTopRatedEmpty) {
              return const Center(child: Text('Top Rated Movies Empty'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

import 'package:core/presentation/bloc/movie/popular/movie_popular_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<MoviePopularBloc>().add(const FetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MoviePopularBloc, MoviePopularState>(
          builder: (_, state) {
            if (state is MoviePopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MoviePopularHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is MoviePopularError) {
              return Center(
                  key: const Key('error_message'), child: Text(state.message));
            } else if (state is MoviePopularEmpty) {
              return const Center(child: Text('Popular Movies Empty'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

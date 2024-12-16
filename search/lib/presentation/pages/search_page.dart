import 'package:core/core.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

import '../provider/movie/movie_search_notifier.dart';
import '../provider/tv/tv_search_notifier.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final String type;

  SearchPage({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc>().add(OnQueryChanged(query));
                // if (type == TYPE_MOVIE) {
                //   Provider.of<MovieSearchNotifier>(context, listen: false)
                //       .fetchMovieSearch(query);
                // } else {
                //   Provider.of<TvSearchNotifier>(context, listen: false)
                //       .fetchTvSearch(query);
                // }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = result[index];
                      return MovieCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is SearchError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            }),
            // State Management Using Provider
            // type.contains(TYPE_MOVIE)
            //     ? Consumer<MovieSearchNotifier>(
            //         builder: (context, data, child) {
            //           if (data.state == RequestState.Loading) {
            //             return const Center(
            //               child: CircularProgressIndicator(),
            //             );
            //           } else if (data.state == RequestState.Loaded) {
            //             final result = data.searchResult;
            //             return Expanded(
            //               child: ListView.builder(
            //                 padding: const EdgeInsets.all(8),
            //                 itemBuilder: (context, index) {
            //                   final movie = data.searchResult[index];
            //                   return MovieCard(movie);
            //                 },
            //                 itemCount: result.length,
            //               ),
            //             );
            //           } else {
            //             return Expanded(
            //               child: Container(),
            //             );
            //           }
            //         },
            //       )
            //     : Consumer<TvSearchNotifier>(
            //         builder: (context, data, child) {
            //           if (data.state == RequestState.Loading) {
            //             return Center(
            //               child: CircularProgressIndicator(),
            //             );
            //           } else if (data.state == RequestState.Loaded) {
            //             final result = data.searchResult;
            //             return Expanded(
            //               child: ListView.builder(
            //                 padding: const EdgeInsets.all(8),
            //                 itemBuilder: (context, index) {
            //                   final tv = data.searchResult[index];
            //                   return TvCard(tv);
            //                 },
            //                 itemCount: result.length,
            //               ),
            //             );
            //           } else {
            //             return Expanded(
            //               child: Container(),
            //             );
            //           }
            //         },
            //       ),
          ],
        ),
      ),
    );
  }
}

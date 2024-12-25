import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/tv/detail/tv_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/season.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      context.read<TvDetailBloc>().add(LoadWatchlistStatusTv(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        body: BlocConsumer<TvDetailBloc, TvDetailState>(
            listener: (context, state) {
          final message = state.message;
          if (message == TvDetailBloc.watchlistAddSuccessMessage ||
              message == TvDetailBloc.watchlistRemoveSuccessMessage) {
            _scaffoldMessengerKey.currentState!.showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Text(message),
                );
              },
            );
          }
        }, listenWhen: (oldState, newState) {
          return oldState.message != newState.message && newState.message != '';
        }, builder: (_, state) {
          final tvDetailState = state.tvDetailState;
          if (tvDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (tvDetailState == RequestState.Loaded) {
            return SafeArea(
              child: DetailTvContent(
                state.tvDetail!,
                state.tvRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (tvDetailState == RequestState.Error) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}

class DetailTvContent extends StatelessWidget {
  final TvDetail tvDetail;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  DetailTvContent(this.tvDetail, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvDetail.name,
                              style: kHeading5,
                            ),
                            ElevatedButton.icon(
                              key: const Key('watchlistButton'),
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(AddWatchlistTv(tvDetail));
                                } else {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(RemoveFromWatchlistTv(tvDetail));
                                }
                              },
                              icon: isAddedWatchlist
                                  ? const Icon(Icons.check)
                                  : const Icon(Icons.add),
                              label: const Text('Watchlist'),
                            ),
                            Text(
                              _showGenres(tvDetail.genres),
                            ),
                            Text(
                              _showSeasonEpisode(tvDetail.numberOfSeasons,
                                  tvDetail.numberOfEpisodes),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvDetail.voteAverage}'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            _showRecommendationList(),
                            const SizedBox(height: 24),
                            Text(
                              'Season & Episode',
                              style: kHeading6,
                            ),
                            const SizedBox(height: 8),
                            _showSeasonList(tvDetail.seasons),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showSeasonEpisode(int numberOfSeasons, int numberOfEpisodes) {
    return "$numberOfSeasons Season, $numberOfEpisodes Episode";
  }

  Widget _showRecommendationList() {
    return BlocBuilder<TvDetailBloc, TvDetailState>(
      builder: (_, state) {
        final recommendationState = state.tvRecommendationsState;
        if (recommendationState == RequestState.Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }  else if (recommendationState == RequestState.Loaded) {
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final movie = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TvDetailPage.ROUTE_NAME,
                        arguments: movie.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
              itemCount: recommendations.length,
            ),
          );
        }else if (recommendationState == RequestState.Error) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _showSeasonList(List<Season> seasons) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    child: CachedNetworkImage(
                      width: 100,
                      height: 150,
                      fit: BoxFit.fill,
                      imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${season.name} (${season.episodeCount} episode)',
                      style: kSubtitle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: seasons.length,
      ),
    );
  }
}

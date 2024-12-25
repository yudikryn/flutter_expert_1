import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/bloc/tv/list/tv_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import '../../utils/routes.dart';
import 'sub_list_tv_page.dart';
import 'tv_detail_page.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ListTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';

  @override
  State<ListTvPage> createState() => _ListTvPageState();
}

class _ListTvPageState extends State<ListTvPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: TYPE_TV,
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Airing Today',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SubListTvPage.ROUTE_NAME,
                    arguments: TYPE_AIRING,
                  );
                },
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (_, state) {
                if (state is AiringTodayTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TvListCombinedState) {
                    return TvList(state.airingToday);
                  } else if (state is AiringTodayTvError) {
                    return Center(child: Text(state.message));
                  } else if (state is AiringTodayTvEmpty) {
                    return const Center(
                        child: Text('No Airing Today Tv Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SubListTvPage.ROUTE_NAME,
                    arguments: TYPE_POPULAR,
                  );
                },
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (_, state) {
                if (state is PopularTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TvListCombinedState) {
                    return TvList(state.popular);
                  } else if (state is PopularTvError) {
                    return Center(child: Text(state.message));
                  } else if (state is PopularTvEmpty) {
                    return const Center(
                        child: Text('No Popular Tv Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SubListTvPage.ROUTE_NAME,
                    arguments: TYPE_TOP_RATED,
                  );
                },
              ),
              BlocBuilder<TvListBloc, TvListState>(
                builder: (_, state) {
                if (state is TopRatedTvLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TvListCombinedState) {
                    return TvList(state.topRated);
                  } else if (state is TopRatedTvError) {
                    return Center(child: Text(state.message));
                  } else if (state is TopRatedTvEmpty) {
                    return const Center(
                        child: Text('No Top Rated Tv Found'));
                  } else {
                    return const SizedBox.shrink();
                  }
              }),
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> listTv;

  TvList(this.listTv);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = listTv[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: listTv.length,
      ),
    );
  }
}

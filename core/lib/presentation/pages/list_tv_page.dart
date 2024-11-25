import 'package:cached_network_image/cached_network_image.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import 'search_page.dart';
import 'sub_list_tv_page.dart';
import 'tv_detail_page.dart';
import '../provider/tv/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../utils/state_enum.dart';

class ListTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv';

  @override
  State<ListTvPage> createState() => _ListTvPageState();
}

class _ListTvPageState extends State<ListTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<TvListNotifier>(context, listen: false)
      ..fetchAiringTodayTv()
      ..fetchPopularTv()
      ..fetchTopRatedTv());
  }

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
                SearchPage.ROUTE_NAME,
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
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.airingTodayTvState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvList(data.airingToday);
                } else {
                  return Text('Failed');
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
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.popularTvState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvList(data.popularTv);
                } else {
                  return Text('Failed');
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
              Consumer<TvListNotifier>(builder: (context, data, child) {
                final state = data.topRatedTvState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvList(data.topRatedTv);
                } else {
                  return Text('Failed');
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

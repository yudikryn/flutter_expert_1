import 'package:ditonton/presentation/provider/tv/tv_popular_notifier.dart';
import 'package:ditonton/presentation/provider/tv/tv_top_rated_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/state_enum.dart';

class SubListTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-sub';
  final String type;

  SubListTvPage({required this.type});

  @override
  State<SubListTvPage> createState() => _SubListTvPageState();
}

class _SubListTvPageState extends State<SubListTvPage> {
  @override
  void initState() {
    super.initState();

    if (widget.type == TYPE_POPULAR) {
      Future.microtask(() =>
          Provider.of<TvPopularNotifier>(context, listen: false)
              .fetchPopularTv());
    } else {
      Future.microtask(() =>
          Provider.of<TvTopRatedNotifier>(context, listen: false)
              .fetchTopRatedTv());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.type.contains(TYPE_POPULAR)
            ? Text('Popular')
            : Text('Top Rated'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.type.contains(TYPE_POPULAR)
            ? _listTvPopular()
            : _listTvTopRated(),
      ),
    );
  }

  Widget _listTvPopular() {
    return Consumer<TvPopularNotifier>(
      builder: (context, data, child) {
        if (data.popularTvState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.popularTvState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = data.popularTv[index];
              return TvCard(tv);
            },
            itemCount: data.popularTv.length,
          );
        } else {
          return Center(
            key: Key('error_message'),
            child: Text(data.message),
          );
        }
      },
    );
  }

  Widget _listTvTopRated() {
    return Consumer<TvTopRatedNotifier>(
      builder: (context, data, child) {
        if (data.topRatedTvState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.topRatedTvState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = data.topRatedTv[index];
              return TvCard(tv);
            },
            itemCount: data.topRatedTv.length,
          );
        } else {
          return Center(
            key: Key('error_message'),
            child: Text(data.message),
          );
        }
      },
    );
  }
}

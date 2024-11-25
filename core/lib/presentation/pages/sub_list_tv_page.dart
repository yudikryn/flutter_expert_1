import '../provider/tv/tv_airing_today_notifier.dart';
import '../provider/tv/tv_popular_notifier.dart';
import '../provider/tv/tv_top_rated_notifier.dart';
import '../widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';

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
    } else if (widget.type == TYPE_TOP_RATED) {
      Future.microtask(() =>
          Provider.of<TvTopRatedNotifier>(context, listen: false)
              .fetchTopRatedTv());
    } else {
      Future.microtask(() =>
          Provider.of<TvAiringTodayNotifier>(context, listen: false)
              .fetchAiringTodayTv());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTitleText(widget.type))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: getContent(widget.type),
      ),
    );
  }

  String getTitleText(String type) {
    if (type == TYPE_POPULAR) {
      return 'Popular';
    } else if (type == TYPE_TOP_RATED) {
      return 'Top Rated';
    } else if (type == TYPE_AIRING) {
      return 'Airing Today';
    } else {
      return 'Unknown';
    }
  }

  Widget getContent(String type) {
    if (type == TYPE_POPULAR) {
      return _listTvPopular();
    } else if (type == TYPE_TOP_RATED) {
      return _listTvTopRated();
    } else if (type == TYPE_AIRING) {
      return _listTvAiringToday();
    } else {
      return Container();
    }
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

  Widget _listTvAiringToday() {
    return Consumer<TvAiringTodayNotifier>(
      builder: (context, data, child) {
        if (data.topAiringTvState == RequestState.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.topAiringTvState == RequestState.Loaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final tv = data.airingTodayTv[index];
              return TvCard(tv);
            },
            itemCount: data.airingTodayTv.length,
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

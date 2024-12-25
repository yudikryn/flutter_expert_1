import 'package:core/presentation/bloc/tv/airingtoday/tv_airing_today_bloc.dart';
import 'package:core/presentation/bloc/tv/popular/tv_popular_bloc.dart';
import 'package:core/presentation/bloc/tv/toprated/tv_top_rated_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      Future.microtask(
          () => context.read<TvPopularBloc>().add(const FetchPopularTv()));
    } else if (widget.type == TYPE_TOP_RATED) {
      Future.microtask(
          () => context.read<TvTopRatedBloc>().add(const FetchTopRatedTv()));
    } else {
      Future.microtask(() =>
          context.read<TvAiringTodayBloc>().add(const FetchAiringTodayTv()));
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
    return BlocBuilder<TvPopularBloc, TvPopularState>(
      builder: (_, state) {
        if (state is TvPopularLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvPopularHasData) {
          final result = state.result;
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = result[index];
              return TvCard(movie);
            },
            itemCount: result.length,
          );
        } else if (state is TvPopularError) {
          return Center(
              key: const Key('error_message'), child: Text(state.message));
        } else if (state is TvPopularEmpty) {
          return const Center(child: Text('Popular Tv Empty'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _listTvTopRated() {
    return BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
      builder: (_, state) {
        if (state is TvTopRatedLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvTopRatedHasData) {
          final result = state.result;
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = result[index];
              return TvCard(movie);
            },
            itemCount: result.length,
          );
        } else if (state is TvTopRatedError) {
          return Center(
              key: const Key('error_message'), child: Text(state.message));
        } else if (state is TvTopRatedEmpty) {
          return const Center(child: Text('Top Rated Tv Empty'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _listTvAiringToday() {
    return BlocBuilder<TvAiringTodayBloc, TvAiringTodayState>(
      builder: (_, state) {
        if (state is TvAiringTodayLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvAiringTodayHasData) {
          final result = state.result;
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = result[index];
              return TvCard(movie);
            },
            itemCount: result.length,
          );
        } else if (state is TvAiringTodayError) {
          return Center(
              key: const Key('error_message'), child: Text(state.message));
        } else if (state is TvAiringTodayEmpty) {
          return const Center(child: Text('Airing Today Tv Empty'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:flutter/material.dart';

class TvAiringTodayNotifier extends ChangeNotifier {
  final GetTvAiringToday getTvAiringToday;

  TvAiringTodayNotifier({required this.getTvAiringToday});

  var _airingTodayTv = <Tv>[];
  List<Tv> get airingTodayTv => _airingTodayTv;

  RequestState _topAiringTvState = RequestState.Empty;
  RequestState get topAiringTvState => _topAiringTvState;

  String _message = '';
  String get message => _message;

  Future<void> fetchAiringTodayTv() async {
    _topAiringTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTvAiringToday.execute();
    result.fold(
      (failure) {
        _topAiringTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topAiringTvState = RequestState.Loaded;
        _airingTodayTv = tvData;
        notifyListeners();
      },
    );
  }
}

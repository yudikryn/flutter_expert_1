
import 'package:flutter/foundation.dart';

import '../../../core.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_tv_watchlist.dart';

class TvWatchlistNotifier extends ChangeNotifier {
  var _watchlistTv = <Tv>[];
  List<Tv> get watchlistTv => _watchlistTv;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  TvWatchlistNotifier({required this.getTvWatchlist});

  final GetTvWatchlist getTvWatchlist;

  Future<void> fetchWatchlistTv() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getTvWatchlist.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTv = tvData;
        notifyListeners();
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/tv/get_tv_airing_today.dart';
import 'package:core/domain/usecases/tv/get_tv_popular.dart';
import 'package:core/domain/usecases/tv/get_tv_top_rated.dart';
import 'package:equatable/equatable.dart';

part 'tv_list_state.dart';
part 'tv_list_event.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetTvAiringToday getTvAiringToday;
  final GetTvPopular getPopularTv;
  final GetTvTopRated getTopRatedTv;

  TvListBloc(
      {required this.getTvAiringToday,
      required this.getPopularTv,
      required this.getTopRatedTv})
      : super(TvListInitial()) {

    on<FetchAllTv>((event, emit) async {
      emit(TvListInitial());

      final airingTodayResult = await getTvAiringToday.execute();
      final popularResult = await getPopularTv.execute();
      final topRatedResult = await getTopRatedTv.execute();

      List<Tv> airingToday = [];
      List<Tv> popular = [];
      List<Tv> topRated = [];

      String? errorMessage;

      airingTodayResult.fold(
        (failure) {
          emit(AiringTodayTvError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(AiringTodayTvEmpty());
          else
            airingToday = data;
        },
      );

      popularResult.fold(
        (failure) {
          emit(PopularTvError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(PopularTvEmpty());
          else
            popular = data;
        },
      );

      topRatedResult.fold(
        (failure) {
          emit(TopRatedTvError(failure.message));
          errorMessage = failure.message;
        },
        (data) {
          if (data.isEmpty)
            emit(TopRatedTvEmpty());
          else
            topRated = data;
        },
      );

      if (errorMessage == null) {
        emit(TvListCombinedState(
          airingToday: airingToday,
          popular: popular,
          topRated: topRated,
        ));
      }
    });
  }
}

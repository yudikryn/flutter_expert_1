part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final TvDetail? tvDetail;
  final RequestState tvDetailState;
  final List<Tv> tvRecommendations;
  final RequestState tvRecommendationsState;
  final String message;
  final bool isAddedToWatchlist;

  const TvDetailState({
    required this.tvDetail,
    required this.tvDetailState,
    required this.tvRecommendations,
    required this.tvRecommendationsState,
    required this.message,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object?> get props {
    return [
      tvDetail,
      tvDetailState,
      tvRecommendations,
      tvRecommendationsState,
      message,
      isAddedToWatchlist,
    ];
  }

  TvDetailState copyWith({
    TvDetail? tvDetail,
    RequestState? tvDetailState,
    List<Tv>? tvRecommendations,
    RequestState? tvRecommendationsState,
    String? message,
    bool? isAddedToWatchlist,
  }) {
    return TvDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvRecommendationsState:
          tvRecommendationsState ?? this.tvRecommendationsState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory TvDetailState.initial() {
    return const TvDetailState(
      tvDetail: null,
      tvDetailState: RequestState.Empty,
      tvRecommendations: [],
      tvRecommendationsState: RequestState.Empty,
      message: '',
      isAddedToWatchlist: false,
    );
  }
}
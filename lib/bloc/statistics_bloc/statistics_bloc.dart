import 'dart:async';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/resources/api_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {

  final ApiRepository _apiRepository ;

  StatisticsBloc(this._apiRepository) : super(null);

  @override
  StatisticsState get initialState => StatisticsInitial();

  @override
  Stream<StatisticsState> mapEventToState(
    StatisticsEvent event,
  ) async* {
    if (event is GetStatisticsList) {
      yield* mapGetDetailsEventToState(
        From: event.From,
        To: event.To
      );
    }
  }

  Stream<StatisticsState> mapGetDetailsEventToState({String From, String To}) async* {
    yield GetStatisticsDetailsInProgressState();
    try {
      yield StatisticsLoading();
      final mList = await _apiRepository.fetchStatistics(From, To);
      yield StatisticsLoaded(mList);
      if (mList.error != null) {
        yield StatisticsError(mList.error);
      }
    } on NetworkError {
      yield StatisticsError("Echec dans la récupération des données. Vérifiez votre connexion internet.");
    }
  }
}

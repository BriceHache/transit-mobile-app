part of 'statistics_bloc.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();
}

class GetStatisticsDetailsInProgressState extends StatisticsState {

  @override
  List<Object> get props => null;
}


class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
  @override
  List<Object> get props => [];
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
  @override
  List<Object> get props => null;
}

class StatisticsLoaded extends StatisticsState {
  final Statistics statistics;
  const StatisticsLoaded(this.statistics);
  @override
  List<Object> get props => [statistics];
}

class StatisticsError extends StatisticsState {
  final String message;
  const StatisticsError(this.message);
  @override
  List<Object> get props => [message];
}

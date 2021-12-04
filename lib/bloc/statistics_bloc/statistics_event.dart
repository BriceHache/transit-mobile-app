part of 'statistics_bloc.dart';

abstract class StatisticsEvent extends Equatable {
  const StatisticsEvent();
}

class GetStatisticsList extends StatisticsEvent {

  final String From;
  final String To;

  GetStatisticsList(this.From, this.To);


  @override
  List<Object> get props => null;
}

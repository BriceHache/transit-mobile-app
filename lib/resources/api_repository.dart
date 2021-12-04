import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();



  Future<Statistics> fetchStatistics(String From, String To) {
    return _provider.GetDashboardStats(From, To);
  }
}

class NetworkError extends Error {}


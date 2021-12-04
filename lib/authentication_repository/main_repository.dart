import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/dossier_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_reglement.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/services/main_service.dart';

import 'base_repository.dart';


class MainRepository extends BaseRepository  {

  MainService mainService = MainService();


  @override
  void dispose() {
    mainService.dispose();
  }

  Future<Statistics> GetDashboardStats(String From, String To) => mainService.GetDashboardStats(From, To);

  //Future<DossierDataTableResponse<GetClient>> GetClients(DataTable dossierDataTableRequest) => mainService.GetClients(dossierDataTableRequest);

  Future<DossierDataTableResponse> GetDossiers(RequestParamDataTable dossierDataTableRequest) => mainService.GetDossiers(dossierDataTableRequest);

  //Future<DataTableGenericResponse<GetReglement>> GetReglements(DataTable dossierDataTableRequest) => mainService.GetReglements(dossierDataTableRequest);

}


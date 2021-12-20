import 'package:ball_on_a_budget_planner/custom_models/UserResponse.dart';
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/dossier_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_reglement.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
//import 'package:firebase_auth/firebase_auth.dart';


abstract class BaseDossierService {
  void dispose();
}

abstract class BaseMainService extends BaseDossierService {

  Future<Statistics> GetDashboardStats(String From, String To);

  Future<DossierDataTableResponse> GetDossiers(RequestParamDataTable dossierDataTableRequest);

 // Future<DataTableGenericResponse<GetClient>> GetClients(DataTable dossierDataTableRequest);

  //Future<DataTableGenericResponse<GetReglement>> GetReglements(DataTable dossierDataTableRequest);

}


abstract class BaseDossierStorageService extends BaseDossierService {}


//import 'dart:html';

import 'package:ball_on_a_budget_planner/configs/globals.dart';
import 'package:ball_on_a_budget_planner/models/client_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/date_range.dart';
import 'package:ball_on_a_budget_planner/models/dossier_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/fee_model.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_fees.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_reglement.dart';
import 'package:ball_on_a_budget_planner/models/key_value.dart';
import 'package:ball_on_a_budget_planner/models/reglement_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';

class ApiProvider {

  static final Dio _dio = Dio();
  final String statistics_url =  "http://" + Globals.targethost + "/api/dossier/statistics";
  static final String getdossier_url =  "http://" + Globals.targethost + "/api/dossier/LoadTable";
  static final String get_pieces_jointes_url =  "http://" + Globals.targethost + "/api/dossier/DocumentsRattaches";
  static final String get_documents_non_rattaches_url =  "http://" + Globals.targethost + "/api/dossier/DocumentsNonRattaches";

  static final String get_reglements_url =  "http://" + Globals.targethost + "/api/dossier/LoadReglementTable";
  static final String get_clients_url =  "http://" + Globals.targethost + "/api/dossier/LoadCustomerTable";

  static final String frais_dossiers_url =  "http://" + Globals.targethost + "/api/dossier/GetDocumentGrid";
  static final String detail_frais_dossiers_url =  "http://" + Globals.targethost + "/api/dossier/GetTransactionDetail";
  static final String save_or_update_frais_dossiers_url =  "http://" + Globals.targethost + "/api/dossier/SaveOrUpdateTransactionDetail";
  static final String delete_frais_dossiers_url =  "http://" + Globals.targethost + "/api/dossier/DeleteDocumentLine";

  static final String get_fees =  "http://" + Globals.targethost + "/api/dossier/GetDocumentGrid";
  static final String get_dossiers =  "http://" + Globals.targethost + "/api/dossier/GetAllDossiers";
  static final String get_agents =  "http://" + Globals.targethost + "/api/dossier/GetAllEmployees";
  static final String get_articles =  "http://" + Globals.targethost + "/api/dossier/GetAllArticles";

  static final String save_fee =  "http://" + Globals.targethost + "/api/dossier/SaveOrUpdateFee";

  Future<Statistics> GetDashboardStats(String From, String To) async {

    try {

      var body  = {
        'From': From,
        'To': To
      };

      Response response = await _dio.post(statistics_url, data: body);

      return Statistics.fromJson(response.data);

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return Statistics.withError("Pas de connexion internet.");
    }
  }

  //  Ensemble des dossiers
  static Future<Tuple2<List<GetDossier>, String>> GetAllDossiers(RequestParamDataTable dossierDataTable ) async {

    try {

      DossierDataTableResponse dataTableResponse = new DossierDataTableResponse();

      var body  = dossierDataTable.toPostDossierObject();

      Response response = await _dio.post(
          getdossier_url,
          data: body);

      if (200 == response.statusCode) {
        return new Tuple2<List<GetDossier>, String>(dataTableResponse.GetDossiers(response.data), "Success");
      } else {
        return new Tuple2<List<GetDossier>, String>(List<GetDossier>.empty(growable: true), "Error");
      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<GetDossier>, String>(List<GetDossier>.empty(growable: true), "Connexion_issue.");
    }

  }

// obtenir l'ensemble des pièces jointes d'un dossier  donné

  static Future<Tuple2<List<PieceJointeDossier>, String>> GetAllPiecesJointesDossier(int dossierId ) async {

    try {

      DossierDataTableResponse dataTableResponse = new DossierDataTableResponse();

      var params  = {
        'id': dossierId,
      };

      Response response = await _dio.post(
          get_pieces_jointes_url,
          queryParameters: params);

      if (200 == response.statusCode) {

        return new Tuple2<List<PieceJointeDossier>, String>(dataTableResponse.GetPiecesJointesDossier(response.data), "Success");

      } else {

        return new Tuple2<List<PieceJointeDossier>, String>(List<PieceJointeDossier>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<PieceJointeDossier>, String>(List<PieceJointeDossier>.empty(growable: true), "Connexion_issue.");

    }


  }

// Ensemble des Documments non rattachés

  static Future<Tuple2<List<DocumentDossier>, String>> GetAllDocumentsNonRattachesDossier(int dossierId ) async {

    try {

      DossierDataTableResponse dataTableResponse = new DossierDataTableResponse();

      var params  = {
        'id': dossierId,
      };

      Response response = await _dio.post(
          get_documents_non_rattaches_url,
          queryParameters: params);

      if (200 == response.statusCode) {

        return new Tuple2<List<DocumentDossier>, String>(dataTableResponse.GetPDocumentsNonRattachesDossier(response.data), "Success");

      } else {

        return new Tuple2<List<DocumentDossier>, String>(List<DocumentDossier>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<DocumentDossier>, String>(List<DocumentDossier>.empty(growable: true), "Connexion_issue.");

    }

  }

  // Ensemble des règlements clients
  static Future<Tuple2<List<GetReglement>, String>> GetAllReglements(RequestParamDataTable reglementDataTable ) async {

    try {

      ReglementDataTableResponse dataTableResponse = new ReglementDataTableResponse();

      var body  = reglementDataTable.toPostReglementObject();

      Response response = await _dio.post(
          get_reglements_url,
          data: body);

      if (200 == response.statusCode) {
        return new Tuple2<List<GetReglement>, String>(dataTableResponse.GetReglements(response.data), "Success");
      } else {
        return new Tuple2<List<GetReglement>, String>(List<GetReglement>.empty(growable: true), "Error");
      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<GetReglement>, String>(List<GetReglement>.empty(growable: true), "Connexion_issue.");
    }

  }

  // Ensemble des clients
  static Future<Tuple2<List<GetClient>, String>> GetAllClients(RequestParamDataTable clientDataTable ) async {

    try {

      ClientDataTableResponse dataTableResponse = new ClientDataTableResponse();
      var body  = clientDataTable.toPostClientObject();

      Response response = await _dio.post(
          get_clients_url,
          data: body);

      if (200 == response.statusCode) {
        return new Tuple2<List<GetClient>, String>(dataTableResponse.GetClients(response.data), "Success");
      } else {
        return new Tuple2<List<GetClient>, String>(List<GetClient>.empty(growable: true), "Error");
      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<GetClient>, String>(List<GetClient>.empty(growable: true), "Connexion_issue.");
    }

  }


  // Ensemble des frais engagés d'un dossier donné
  static Future<Tuple2<List<GetFees>, String>> GetAllFees(int dossierId ) async {

    try {

      GetFees dataTableResponse = new GetFees();

      var params  = {
        'DossierID': dossierId
      };

      Response response = await _dio.post(
          get_fees,
          queryParameters: params);

      if (200 == response.statusCode) {

        return new Tuple2<List<GetFees>, String>(dataTableResponse.GetAllFees(response.data), "Success");

      } else {

        return new Tuple2<List<GetFees>, String>(List<GetFees>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<GetFees>, String>(List<GetFees>.empty(growable: true), "Connexion_issue.");

    }


  }

  // Ensemble des dossiers

  static Future<Tuple2<List<KeyValueModel>, String>> GetAllDossiersKV() async {

    try {

      KeyValueModel dataTableResponse = new KeyValueModel();

      Response response = await _dio.get(get_dossiers);

      if (200 == response.statusCode) {

        return new Tuple2<List<KeyValueModel>, String>(dataTableResponse.GetKeyValueMap(response.data), "Success");

      } else {

        return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Connexion_issue.");

    }


  }

  // Ensemble des agents

  static Future<Tuple2<List<KeyValueModel>, String>> GetAllEmployeesKV() async {

    try {

      KeyValueModel dataTableResponse = new KeyValueModel();

      Response response = await _dio.get(get_agents);

      if (200 == response.statusCode) {

        return new Tuple2<List<KeyValueModel>, String>(dataTableResponse.GetKeyValueMap(response.data), "Success");

      } else {

        return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Connexion_issue.");

    }


  }

  // Ensemble des articles

  static Future<Tuple2<List<KeyValueModel>, String>> GetAllArticlesKV() async {

    try {

      KeyValueModel dataTableResponse = new KeyValueModel();

      Response response = await _dio.get(get_articles);

      if (200 == response.statusCode) {

        return new Tuple2<List<KeyValueModel>, String>(dataTableResponse.GetKeyValueMap(response.data), "Success");

      } else {

        return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Error");

      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<List<KeyValueModel>, String>(List<KeyValueModel>.empty(growable: true), "Connexion_issue.");

    }

  }


  // Sauvegarder un frais

  static Future<Tuple2<String, String>> SaveFee(FeeModel fee ) async {

    try {

      Response response = await _dio.post(
          save_fee,
          data: fee);

      if (200 == response.statusCode) {
        return new Tuple2<String, String>(response.data["message"], response.data["status"]);
      } else {
        return new Tuple2<String, String>(null, "Error");
      }

    } catch (error, stacktrace) {

      print("Une exception est survenue: $error stackTrace: $stacktrace");

      return new Tuple2<String, String>(null, "Connexion_issue.");
    }

  }



  static Future<Response> createPostApi(multipartArray) async {
      var uri = Uri.parse('http://your_base_url/post');
      return await Dio()
          .post('$uri',
          data: FormData.fromMap({
            "title": "from app2",
            "description": "app upload test",
            "files": multipartArray
          }))
          .catchError((e) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      });
    }


  /* Future<String> uploadImage(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(file.path, filename:fileName),
    });
    var response = await _dio.post("/info", data: formData);
    return response.data['id'];
  } */

}

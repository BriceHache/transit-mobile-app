
import 'package:ball_on_a_budget_planner/configs/globals.dart';
import 'package:ball_on_a_budget_planner/custom_models/UserResponse.dart';
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/dossier_datatable_response.dart';
import 'package:ball_on_a_budget_planner/models/date_range.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_reglement.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ball_on_a_budget_planner/services/base_service.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'dart:convert';

import 'base_main_service.dart';


class MainService extends BaseMainService {

   // Create storage
  final _storage = new FlutterSecureStorage();

  // Get target host for http requests
  String targethost = Globals.targethost;


  @override
  void dispose() {}

  @override
  Future<Statistics> GetDashboardStats(String From, String To) async {

    Statistics response = new Statistics();

    var body = new DateRange(From: From, To: To);

    try {

          var tokenUri = new Uri(scheme: 'http',
              host: targethost,
              path: '/api/dossier/statistics');

          final request = await http
              .post(
              tokenUri,
              headers: {"Content-Type": "application/x-www-form-urlencoded"},
              body: body
          );

          if (request.statusCode == 200) {
            response.error = '200';
            final json = jsonDecode(request.body);

            response.total_dossiers = json['total_dossiers'] ;
            response.total_clients = json['total_clients'] ;
            response.chiffre_affaires = json['chiffre_affaires'] as String;
            response.reglements = json['reglements'] as String;
            response.encours = json['encours'] as String;
            response.message = json['message'] as String;
            response.status = json['status'] as String;
            response.devise = json['devise'] as String;

          }else {

            response.error = request.statusCode.toString() + ' ' + request.body;
            return response;
          }
    }catch (e){

      response.error = e.message;
      print(response.error);

    }

    return   response ;

    //throw UnimplementedError();
  }




  @override
  Future<DossierDataTableResponse> GetDossiers(RequestParamDataTable dossierDataTableRequest) {
    // TODO: implement GetDossiers
    throw UnimplementedError();
  }


}
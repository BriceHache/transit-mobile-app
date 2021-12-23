import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';

import 'get_client.dart';
import 'get_client_details.dart';
import 'get_dossier.dart';
import 'get_reglement.dart';

class ClientDetailsDataTableResponse {

     String sEcho ;
     int iTotalRecords ;
     int iTotalDisplayRecords ;
     List<GetClientDetails> aaData ;
     String error;

     ClientDetailsDataTableResponse({
        this.sEcho,
        this.iTotalRecords,
        this.iTotalDisplayRecords,
        this.aaData
       //,
      // this.error
    });


     ClientDetailsDataTableResponse.withError(String errorMessage) {
       error = errorMessage;
     }

     ClientDetailsDataTableResponse.fromJson(Map<String, dynamic> json) {

       if (json['aaData'] != null) {
         aaData =  List<GetClientDetails>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetClientDetails.fromJson(v));
         });
       }
       sEcho = json['Date'];
       iTotalRecords = json['iTotalRecords'];
       iTotalDisplayRecords = json['iTotalDisplayRecords'];
     }

     List<GetClientDetails>  GetClients (Map<String, dynamic> json){

       if (json['aaData'] != null) {
         aaData =  List<GetClientDetails>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetClientDetails.fromJson(v));
         });
         return aaData;

       }
       return null;
     }


     Map<String, dynamic> toJson() {

       final Map<String, dynamic> data = new Map<String, dynamic>();

       if (this.aaData != null) {
         data['aaData'] = this.aaData.map((v) => v.toJson()).toList();
       }

       data['sEcho'] = this.sEcho;
       data['iTotalRecords'] = this.iTotalRecords;
       data['iTotalDisplayRecords'] = this.iTotalDisplayRecords;
       return data;
     }


}
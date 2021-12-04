import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';

import 'get_dossier.dart';
import 'get_reglement.dart';

class ReglementDataTableResponse {

     String sEcho ;
     int iTotalRecords ;
     int iTotalDisplayRecords ;
     List<GetReglement> aaData ;
     String error;

     ReglementDataTableResponse({
        this.sEcho,
        this.iTotalRecords,
        this.iTotalDisplayRecords,
        this.aaData
       //,
      // this.error
    });


     ReglementDataTableResponse.withError(String errorMessage) {
       error = errorMessage;
     }

     ReglementDataTableResponse.fromJson(Map<String, dynamic> json) {

       if (json['aaData'] != null) {
         aaData =  List<GetReglement>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetReglement.fromJson(v));
         });
       }
       sEcho = json['Date'];
       iTotalRecords = json['iTotalRecords'];
       iTotalDisplayRecords = json['iTotalDisplayRecords'];
     }

     List<GetReglement>  GetReglements (Map<String, dynamic> json){

       if (json['aaData'] != null) {
         aaData =  List<GetReglement>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetReglement.fromJson(v));
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
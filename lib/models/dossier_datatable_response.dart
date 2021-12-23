import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';

import 'get_dossier.dart';

class DossierDataTableResponse {

     String sEcho ;
     int iTotalRecords ;
     int iTotalDisplayRecords ;
     List<GetDossier> aaData ;
     String error;

     DossierDataTableResponse({
        this.sEcho,
        this.iTotalRecords,
        this.iTotalDisplayRecords,
        this.aaData
       //,
      // this.error
    });


     DossierDataTableResponse.withError(String errorMessage) {
       error = errorMessage;
     }

     DossierDataTableResponse.fromJson(Map<String, dynamic> json) {

       if (json['aaData'] != null) {
         aaData =  List<GetDossier>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetDossier.fromJson(v));
         });
       }
       sEcho = json['Date'];
       iTotalRecords = json['iTotalRecords'];
       iTotalDisplayRecords = json['iTotalDisplayRecords'];
     }

     List<GetDossier>  GetDossiers (Map<String, dynamic> json){

       if (json['aaData'] != null) {
         aaData =  List<GetDossier>.empty(growable: true);
         json['aaData'].forEach((v) {
           aaData.add(new GetDossier.fromJson(v));
         });
         return aaData;

       }
       return null;
     }

     List<PieceJointeDossier>  GetPiecesJointesDossier (Map<String, dynamic> json){

       List<PieceJointeDossier> data =  List<PieceJointeDossier>.empty(growable: true)  ;

       if (json['data'] != null) {
         json['data'].forEach((v) {
           data.add(new PieceJointeDossier.fromJson(v));
         });
         return data;

       }
       return null;
     }

     List<PieceJointeDossier>  GetUniquePieceJointeDossier (Map<String, dynamic> json) {
       List<PieceJointeDossier> data = List<PieceJointeDossier>.empty(
           growable: true);
       if (json['data'] != null) {
           data.add(new PieceJointeDossier.fromJson(json['data']));
           return data;
       }else{
         return null;
       }
     }


     List<DocumentDossier>  GetPDocumentsNonRattachesDossier (Map<String, dynamic> json){

       List<DocumentDossier> data =  List<DocumentDossier>.empty(growable: true)  ;

       if (json['data'] != null) {
         json['data'].forEach((v) {
           data.add(new DocumentDossier.fromJson(v));
         });
         return data;

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
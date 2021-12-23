import 'datatable.dart';

class ClientRequestParamDataTable extends RequestParamDataTable  {

    int client_id;
    ClientRequestParamDataTable({
      int iColumns,
      int iDisplayLength,
      int iDisplayStart,
      int iSortCol_0,
      int iSortingCols,
      String sColumns,
      int sEcho,
      String sSearch,
      String sSortDir_0,
      String start_date,
      String end_date,
      this.client_id
    }) :

      super(
          iColumns : iColumns,
          iDisplayLength : iDisplayLength,
          iDisplayStart : iDisplayStart,
          iSortCol_0 : iSortCol_0,
          iSortingCols : iSortingCols,
          sColumns : sColumns ,
          sEcho : sEcho,
          sSearch : sSearch,
          sSortDir_0 : sSortDir_0,
          start_date : start_date,
          end_date : end_date
        );


    Map<String, dynamic> toPostDossierObject() {

        return {
         'iColumns': 18,
         'iDisplayLength' :  500,
         'iDisplayStart' : 0,
         'iSortCol_0' : 0,
         'iSortingCols' : 1,
         'sColumns' : 'numero_dossier,date_de_sortie_booking, ClientName, MainContactName, TransitFileObject, date_arrivee, containers,numeroBLS, numero_repertoire,frais_dossiers,nombre_de_factures,chiffre_affaires_ht,montant_taxes,montant_marge,StatusName,tfType,id',
          'sEcho' : 1,
          'sSearch' : this.sSearch,
         'sSortDir_0' : 'asc',
         'start_date' : this.start_date,
         'end_date' : this.end_date,
          'client_id' : this.client_id

        };
    }

    Map<String, dynamic> toPostReglementObject() {

      return {
        'iColumns': 11,
        'iDisplayLength' :  500,
        'iDisplayStart' : 0,
        'iSortCol_0' : 0,
        'iSortingCols' : 1,
        'sColumns' : 'reference,raison_sociale_client,date_reglement,libelle_reglement,mode_reglement,montant_reglement,total_imputation,Solde,validation,comptabilisation,id',
        'sEcho' : 1,
        'sSearch' : this.sSearch,
        'sSortDir_0' : 'asc',
        'start_date' : this.start_date,
        'end_date' : this.end_date,
        'client_id' : this.client_id

      };
    }

    Map<String, dynamic> toPostClientObject() {

      return {
        'iColumns': 9,
        'iDisplayLength' :  500,
        'iDisplayStart' : 0,
        'iSortCol_0' : 0,
        'iSortingCols' : 1,
        'sColumns' : 'tiDescription,tiCode,tiTelephone,tiEmail,chiffre_affaires_ht,montant_marge,paiements,solde,Id',
        'sEcho' : 1,
        'sSearch' : this.sSearch,
        'sSortDir_0' : 'asc',
        'start_date' : this.start_date,
        'end_date' : this.end_date,
        'client_id' : this.client_id
      };
    }


}
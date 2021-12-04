class RequestParamDataTable {
    int iColumns;
    int iDisplayLength;
    int iDisplayStart;
    int iSortCol_0;
    int iSortingCols;
    String sColumns ;
    int sEcho;
    String sSearch;
    String sSortDir_0;
    String start_date;
    String end_date;

    RequestParamDataTable({
        this.iColumns,
        this.iDisplayLength,
        this.iDisplayStart,
        this.iSortCol_0,
        this.iSortingCols,
        this.sColumns,
        this.sEcho,
        this.sSearch,
        this.sSortDir_0,
        this.start_date,
        this.end_date,
    });

    Map<String, dynamic> toPostDossierObject() {

        return {
         'iColumns': 18,
         'iDisplayLength' :  10,
         'iDisplayStart' : 0,
         'iSortCol_0' : 0,
         'iSortingCols' : 1,
         'sColumns' : 'numero_dossier,date_de_sortie_booking, ClientName, MainContactName, TransitFileObject, date_arrivee, containers,numeroBLS, numero_repertoire,frais_dossiers,nombre_de_factures,chiffre_affaires_ht,montant_taxes,montant_marge,StatusName,tfType,id',
          'sEcho' : 1,
          'sSearch' : this.sSearch,
         'sSortDir_0' : 'asc',
         'start_date' : this.start_date,
         'end_date' : this.end_date

        };
    }

    Map<String, dynamic> toPostReglementObject() {

      return {
        'iColumns': 18,
        'iDisplayLength' :  10,
        'iDisplayStart' : 0,
        'iSortCol_0' : 0,
        'iSortingCols' : 1,
        'sColumns' : 'reference,raison_sociale_client,date_reglement,libelle_reglement,mode_reglement,montant_reglement,total_imputation,Solde,validation,comptabilisation,id',
        'sEcho' : 1,
        'sSearch' : this.sSearch,
        'sSortDir_0' : 'asc',
        'start_date' : this.start_date,
        'end_date' : this.end_date

      };
    }

    Map<String, dynamic> toPostClientObject() {

      return {
        'iColumns': 18,
        'iDisplayLength' :  10,
        'iDisplayStart' : 0,
        'iSortCol_0' : 0,
        'iSortingCols' : 1,
        'sColumns' : 'tiDescription,tiCode,tiTelephone,tiEmail,chiffre_affaires_ht,montant_marge,paiements,solde,Id',
        'sEcho' : 1,
        'sSearch' : this.sSearch,
        'sSortDir_0' : 'asc',
        'start_date' : this.start_date,
        'end_date' : this.end_date

      };
    }

    RequestParamDataTable.fromMap(Map<String, dynamic> map)
      : assert(map['iColumns'] != null),
        assert(map['iDisplayLength'] != null),
        assert(map['iDisplayStart'] != null),
        assert(map['iSortCol_0'] != null),
        assert(map['iSortingCols'] != null),
        assert(map['sColumns'] != null),
        assert(map['sEcho'] != null),
        assert(map['sSearch'] != null),
        assert(map['sSortDir_0'] != null),
        assert(map['start_date'] != null),
        assert(map['end_date'] != null)
        ;
    //@override
   // String toString() => "Record: $name";

}
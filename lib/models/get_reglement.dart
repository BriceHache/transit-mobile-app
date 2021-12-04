class GetReglement{

     int id ;
     String reference ;
     String montant_reglement ;
     String total_imputation ;
     String Solde ;
     String pmtSens ;

    GetReglement({
        this.id,
        this.reference,
        this.montant_reglement,
        this.total_imputation,
        this.Solde,
        this.pmtSens,
    });

     GetReglement.fromJson(Map<String, dynamic> json) {
       id = json['id'];
       reference = json['reference'];
       montant_reglement = json['montant_reglement'];
       total_imputation = json['total_imputation'];
       Solde = json['Solde'];
       pmtSens = json['pmtSens'];
     }

     Map<String, dynamic> toJson() {
       final Map<String, dynamic> data = new Map<String, dynamic>();
       data['id'] = this.id;
       data['reference'] = this.reference;
       data['montant_reglement'] = this.montant_reglement;
       data['total_imputation'] = this.total_imputation;
       data['Solde'] = this.Solde;
       data['pmtSens'] = this.pmtSens;

       return data;
     }

}
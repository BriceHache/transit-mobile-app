class GetClient {

    int Id ;
    String tiCode ;
    String tiDescription ;

    String tiTelephone ;
    String tiEmail ;
    int nombre_factures ;
    String chiffre_affaires_ht ;
    String paiements ;
    String montant_marge ;
    String solde ;

    GetClient({
        this.Id,
        this.tiCode,
        this.tiDescription,

        this.tiTelephone,
        this.tiEmail,
        this.nombre_factures,
        this.chiffre_affaires_ht,
        this.paiements,
        this.montant_marge,
        this.solde

    });

    GetClient.fromJson(Map<String, dynamic> json) {
        Id = json['Id'];
        tiCode = json['tiCode'];
        tiDescription = json['tiDescription'];

        tiTelephone = json['tiTelephone'];
        tiEmail = json['tiEmail'];
        nombre_factures = json['nombre_factures'];
       chiffre_affaires_ht = json['chiffre_affaires_ht'];
        paiements = json['paiements'];
        montant_marge = json['montant_marge'];
        solde = json['solde'];

    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Id'] = this.Id;
        data['tiCode'] = this.tiCode;
        data['tiDescription'] = this.tiDescription;

        data['tiTelephone'] = this.tiTelephone;
        data['tiEmail'] = this.tiEmail;
        data['nombre_factures'] = this.nombre_factures;
        data['chiffre_affaires_ht'] = this.chiffre_affaires_ht;
        data['paiements'] = this.paiements;
        data['montant_marge'] = this.montant_marge;
        data['solde'] = this.solde;

        return data;
    }


}
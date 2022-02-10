class GetDossier {

     int id ;
     String ClientName ;
     String numero_dossier ;
     String TransitFileobject ;
     String numero_repertoire;
     String couleur_label;
     String StatusName ;

     String date_booking_string;
     String etd_string;
     String eta_string;
     String moyen_transport ;
     String MainContactName ;
     String montant_facture;
     String ensemble_numeros_containers;
     String frais_dossiers;
     String transporteur;
     String date_mise_en_livraison;
     String numeroBLS;

     String numeroDeclaration;
     String numeroVoyage;
     String numeroBIETC;
     String Recap_nbreColis;
     String Recap_poids;


    GetDossier({
        this.id,
        this.ClientName,
        this.numero_dossier,
        this.TransitFileobject,
        this.numero_repertoire,
        this.couleur_label,
        this.StatusName,

        this.date_booking_string,
        this.etd_string,
        this.eta_string,
        this.moyen_transport,
        this.MainContactName,
        this.montant_facture,
        this.ensemble_numeros_containers,
        this.frais_dossiers,
        this.transporteur,
        this.date_mise_en_livraison,
        this.numeroBLS

        ,this.numeroDeclaration,
        this.numeroVoyage,
        this.numeroBIETC,
        this.Recap_nbreColis,
        this.Recap_poids


    });

     GetDossier.fromJson(Map<String, dynamic> json) {
       id = json['id'];
       ClientName = json['ClientName'];
       numero_dossier = json['numero_dossier'];
       TransitFileobject = json['observations'];
       numero_repertoire = json['numero_repertoire'];
       couleur_label = json['couleur_label'];
       StatusName = json['StatusName'];

       date_booking_string = json['date_booking_string'];
       etd_string = json['etd_string'];
       eta_string = json['eta_string'];
       moyen_transport = json['moyen_transport'];
       MainContactName = json['MainContactName'];
       montant_facture = json['montant_facture'];
       ensemble_numeros_containers = json['ensemble_numeros_containers'];
       frais_dossiers = json['frais_dossiers'];
       transporteur = json['transporteur'];
       date_mise_en_livraison = json['date_mise_en_livraison'];
       numeroBLS = json['numeroBLS'];

       numeroDeclaration = json['numeroDeclaration'];
       numeroVoyage = json['numeroVoyage'];
       numeroBIETC = json['numeroBIETC'];

       Recap_nbreColis = json['Recap_nbreColis'];
       Recap_poids = json['Recap_poids'];

     }

     Map<String, dynamic> toJson() {
       final Map<String, dynamic> data = new Map<String, dynamic>();
       data['id'] = this.id;
       data['ClientName'] = this.ClientName;
       data['numero_dossier'] = this.numero_dossier;
       data['observations'] = this.TransitFileobject;
       data['numero_repertoire'] = this.numero_repertoire;
       data['couleur_label'] = this.couleur_label;
       data['StatusName'] = this.StatusName;

       data['date_booking_string'] = this.date_booking_string;
       data['etd_string'] = this.etd_string;
       data['eta_string'] = this.eta_string;
       data['moyen_transport'] = this.moyen_transport;
       data['MainContactName'] = this.MainContactName;
       data['montant_facture'] = this.montant_facture;
       data['ensemble_numeros_containers'] = this.ensemble_numeros_containers;
       data['frais_dossiers'] = this.frais_dossiers;
       data['transporteur'] = this.transporteur;
       data['date_mise_en_livraison'] = this.date_mise_en_livraison;
       data['numeroBLS'] = this.numeroBLS;

       data['numeroDeclaration'] = this.numeroDeclaration;
       data['numeroVoyage'] = this.numeroVoyage;
       data['numeroBIETC'] = this.numeroBIETC;

       data['Recap_nbreColis'] = this.Recap_nbreColis;
       data['Recap_poids'] = this.Recap_poids;

       return data;

     }

}
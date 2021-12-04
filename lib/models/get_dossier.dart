class GetDossier {

     int id ;
     String ClientName ;
     String numero_dossier ;
     String TransitFileobject ;
     String numero_repertoire;
     String couleur_label;
     String StatusName ;


    GetDossier({
        this.id,
        this.ClientName,
        this.numero_dossier,
        this.TransitFileobject,
        this.numero_repertoire,
        this.couleur_label,
        this.StatusName,
    });

     GetDossier.fromJson(Map<String, dynamic> json) {
       id = json['id'];
       ClientName = json['ClientName'];
       numero_dossier = json['numero_dossier'];
       TransitFileobject = json['observations'];
       numero_repertoire = json['numero_repertoire'];
       couleur_label = json['couleur_label'];
       StatusName = json['StatusName'];
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
       return data;
     }

}
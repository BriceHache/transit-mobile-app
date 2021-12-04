class DocumentDossier {

   int id ;
   String nom_abrege ;
   String nom_complet ;


   DocumentDossier({
        this.id,
        this.nom_abrege,
        this.nom_complet

    });

   DocumentDossier.fromJson(Map<String, dynamic> json) {

       id = json['id'];
       nom_abrege = json['nom_abrege'];
       nom_complet = json['nom_complet'];

     }

     Map<String, dynamic> toJson() {
       final Map<String, dynamic> data = new Map<String, dynamic>();
       data['id'] = this.id;
       data['nom_abrege'] = this.nom_abrege;
       data['nom_complet'] = this.nom_complet;

       return data;
     }

}
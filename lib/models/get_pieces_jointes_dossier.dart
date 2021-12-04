class PieceJointeDossier {

   int id ;
   int document_id ;
   int dossier_id ;
   String file_name ;
   String file_ext ;
   String file_base6 ;
   String numero_document ;
   String nom_abrege ;
   String nom_complet ;

   PieceJointeDossier({
        this.id,
        this.document_id,
        this.dossier_id,
        this.file_name,
        this.file_ext,
        this.file_base6,
        this.numero_document,
        this.nom_abrege,
        this.nom_complet
    });

   PieceJointeDossier.fromJson(Map<String, dynamic> json) {

       id = json['id'];
       document_id = json['document_id'];
       dossier_id = json['dossier_id'];
       file_name = json['file_name'];
       file_ext = json['file_ext'];
       file_base6 = json['file_base6'];
       numero_document = json['numero_document'];
       nom_abrege = json['nom_abrege'];
       nom_complet = json['nom_complet'];

     }

     Map<String, dynamic> toJson() {
       final Map<String, dynamic> data = new Map<String, dynamic>();
       data['id'] = this.id;
       data['document_id'] = this.document_id;
       data['dossier_id'] = this.dossier_id;
       data['file_name'] = this.file_name;
       data['file_ext'] = this.file_ext;
       data['file_base6'] = this.file_base6;
       data['numero_document'] = this.numero_document;
       data['nom_abrege'] = this.nom_abrege;
       data['nom_complet'] = this.nom_complet;
       return data;
     }

}
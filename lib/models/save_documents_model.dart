import 'dart:ffi';

class SaveDocumentsModel {

   dynamic files ;
   int fichier_id ;
   int dossier_id ;
   int document_id ;
   String numero_document ;
   int current_user_id ;

   SaveDocumentsModel({
      this.files,
      this.fichier_id,
      this.dossier_id,
      this.document_id,
      this.numero_document,
      this.current_user_id
    });

}
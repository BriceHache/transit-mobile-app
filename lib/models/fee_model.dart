import 'dart:ffi';

class FeeModel {

    int SysID ;
    String Code ;
    String Date ;
    String Description ;
    String Comment ;
    double Amount ;
    String interlocuteur ;
    String etd ;
    String eta ;
    String date_enlevement_bad ;
    int agent ;
    String eir ;
    int dossier_id ;
    int current_user_id ;

    FeeModel({
      this.SysID,
      this.Code,
      this.Date,
      this.Description,
      this.Comment,
      this.Amount,
      this.interlocuteur,
      this.etd,
      this.eta,
      this.date_enlevement_bad,
      this.agent,
      this.eir,
      this.dossier_id,
      this.current_user_id
    });

    Map<String, dynamic> toFeeObject() {

      return {
        'SysID' : this.SysID,
        'Code' : this.Code,
         'Date' : this.Date,
        'Description' : this.Description,
        'Comment' : this.Comment,
        'Amount' : this.Amount,
        'interlocuteur' : this.interlocuteur,
        'etd': this.etd,
        'eta' : this.eta,
        'date_enlevement_bad' : this.date_enlevement_bad,
        'agent' : this.agent,
        'eir' : this.eir,
        'dossier_id' : this.dossier_id,
        'current_user_id' : this.current_user_id
      };
    }

}
class GetClientDetails {

     int IdPiece ;
     int counterOrdering ;
     int clientID ;
     String CodeClient ;
     String DescriptionClient ;
     String NumeroPiece ;
     String date ;
     String Debit ;
     String Credit ;
     String TypePiece ;
     String Description ;
     String Solde ;

    GetClientDetails({
        this.IdPiece,
        this.counterOrdering,
        this.clientID,

        this.CodeClient,
        this.DescriptionClient,
        this.NumeroPiece,
        this.date,
        this.Debit,
        this.Credit,
        this.TypePiece,
        this.Description,
        this.Solde

    });

     GetClientDetails.fromJson(Map<String, dynamic> json) {
         IdPiece = json['IdPiece'];
         counterOrdering = json['counterOrdering'];
         clientID = json['clientID'];

         CodeClient = json['CodeClient'];
         DescriptionClient = json['DescriptionClient'];
         NumeroPiece = json['NumeroPiece'];
         date = json['date'];
         Debit = json['Debit'];
         Credit = json['Credit'];
         TypePiece = json['TypePiece'];
         Description = json['Description'];
         Solde = json['Solde'];

    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();

        data['IdPiece'] = this.IdPiece;
        data['counterOrdering'] = this.counterOrdering;
        data['clientID'] = this.clientID;
        data['CodeClient'] = this.CodeClient;
        data['DescriptionClient'] = this.DescriptionClient;
        data['NumeroPiece'] = this.NumeroPiece;
        data['date'] = this.date;
        data['Debit'] = this.Debit;
        data['Credit'] = this.Credit;
        data['TypePiece'] = this.TypePiece;
        data['Description'] = this.Description;
        data['Solde'] = this.Solde;
        return data;
    }
}
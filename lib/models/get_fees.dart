import 'dart:ffi';

class GetFees {

     int id ;
     String code ;
     String libelle ;
     String montant ;
     String agent ;

     GetFees({
        this.id,
        this.code,
        this.libelle,
        this.montant,
        this.agent
    });

     List<GetFees>  GetAllFees (dynamic json){

       List<GetFees> aaData =  List<GetFees>.empty(growable: true);

       if (json['aaData'] != null) {

         json['aaData'].forEach((v) {
           aaData.add(GetFees.fromJson(v));

           });
       }
         return aaData;

     }


     GetFees.fromJson(dynamic json) {
        id = int.parse(json[0]);
        code = json[1];
        libelle = json[2];
        montant = json[3];
        agent = json[4];

    }

    List<String> toJson() {
        final List<String> data = List<String>.empty(growable: true);
        data[0] = this.id.toString();
        data[1] = this.code;
        data[2] = this.libelle;
        data[3] = this.montant;
        data[4] = this.agent;
        data[5] = this.id.toString();
        return data;
    }

}
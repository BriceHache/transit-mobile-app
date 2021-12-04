import 'dart:convert';

class Statistics {
    int total_dossiers ;
    int total_clients ;
    String chiffre_affaires ;
    String reglements ;
    String encours ;
    String message ;
    String status ;
    String devise ;
    String error;

    Statistics({
        this.total_dossiers,
        this.total_clients,
        this.chiffre_affaires,
        this.reglements,
        this.encours,
        this.message,
        this.status,
        this.devise,
        this.error

    });

    Statistics.withError(String errorMessage) {
        error = errorMessage;
    }

    Statistics.fromJson(Map<String, dynamic> json){
        total_dossiers = json['total_dossiers'];
        total_clients = json['total_clients'];
        chiffre_affaires = json['chiffre_affaires'];
        reglements = json['reglements'];
        encours = json['encours'];
        message = json['message'];
        status = json['status'];
        devise = json['devise'];

    }


    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['total_dossiers'] = this.total_dossiers;
        data['total_clients'] = this.total_clients;
        data['chiffre_affaires'] = this.chiffre_affaires;
        data['reglements'] = this.reglements;
        data['encours'] = this.encours;
        data['message'] = this.message;
        data['status'] = this.status;
        data['devise'] = this.devise;

        return data;
    }


}
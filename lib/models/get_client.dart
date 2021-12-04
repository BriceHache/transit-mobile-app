class GetClient {

    int Id ;
    String tiCode ;
    String tiDescription ;


    GetClient({
        this.Id,
        this.tiCode,
        this.tiDescription,

    });

    GetClient.fromJson(Map<String, dynamic> json) {
        Id = json['Id'];
        tiCode = json['tiCode'];
        tiDescription = json['tiDescription'];

    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Id'] = this.Id;
        data['tiCode'] = this.tiCode;
        data['tiDescription'] = this.tiDescription;

        return data;
    }


}
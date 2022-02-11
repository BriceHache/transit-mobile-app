class KeyValueModel {

    String Text ;
    String Value ;

    KeyValueModel({
        this.Text,
        this.Value,

    });

    List<KeyValueModel>  GetKeyValueMap (Map<String, dynamic> json){

        List<KeyValueModel> aaData =  List<KeyValueModel>.empty(growable: true);

        if (json['data'] != null) {

            json['data'].forEach((v) {
                aaData.add(new KeyValueModel.fromJson(v));
            });
            return aaData;

        }
        return aaData;
    }

    KeyValueModel.fromJson(Map<String, dynamic> json) {
        Text = json['Text'];
        Value = json['Value'];

    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['Text'] = this.Text;
        data['Value'] = this.Value;

        return data;
    }


}
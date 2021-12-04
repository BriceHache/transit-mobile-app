class CreditCard{
  String timestamp;
  String color;
  String bank;
  String last4Digits;
  int dayOfClosingDate;
  String createDate;
  String dateUpdate;
  List monthsExp;

    CreditCard({
        this.timestamp,
        this.color,
        this.bank,
        this.last4Digits,
        this.dayOfClosingDate,
        this.createDate,
        this.dateUpdate,
        this.monthsExp
    });

     CreditCard.fromMap(Map<String, dynamic> map)
      : assert(map['timestamp'] != null),
        assert(map['color'] != null),
        assert(map['bank'] != null),
        assert(map['bank'] != null),
        assert(map['last4Digits'] != null),
        assert(map['createDate'] != null),
        assert(map['dateUpdate'] != null),
        assert(map['monthsExp'] != null),
        timestamp = map["timestamp"],
        color= map["color"],
        bank= map["bank"],
        last4Digits= map["last4Digits"],
        dayOfClosingDate= map["dayOfClosingDate"],
        dateUpdate= map["dateUpdate"],
        monthsExp= map["monthsExp"],
        createDate= map["createDate"];

}

class Income {
  String timestamp;
  double income;
  double lastValue;
  String dateCreate;
  String notes;
  int day;
  String budgetName;
  String tabMonth;
  String budgetTimestamp;

  Income({
    this.timestamp,
    this.income,
    this.dateCreate,
    this.lastValue,
    this.day,
    this.notes,
    this.budgetName,
    this.tabMonth,
    this.budgetTimestamp,
  });

  Income.fromMap(Map<String, dynamic> map)
      : assert(map['timestamp'] != null),
        assert(map['income'] != null),
        assert(map['dateCreate'] != null),
        assert(map['day'] != null),
        assert(map['tabMonth'] != null),
        assert(map['budgetName'] != null),
        assert(map['notes'] != null),
        assert(map['lastValue'] != null),
        assert(map['budgetTimestamp'] != null),
        timestamp= map["timestamp"],
        lastValue= map["lastValue"],
        income =  map["income"],
        dateCreate= map ["dateCreate"],
        notes= map ["notes"],
        day= map ["day"],
        budgetName= map ["budgetName"],
        tabMonth= map ["tabMonth"],
        budgetTimestamp= map ["budgetTimestamp"];
    
    @override
    String toString() => "Record:  $income";
   
}
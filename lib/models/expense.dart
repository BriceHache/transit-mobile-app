
class Expense {
    String timestamp;
    String tabMonthExp;
    int day;
    String dateCreate;
    String category;
    String categoryColor;
    String categoryIcon;
    String notes;
    double value;
    String place;
    String budgetTimestamp;
    String budget;
    


    Expense({
        this.timestamp,
        this.tabMonthExp,
        this.day,
        this.dateCreate,
        this.category,
        this.categoryColor,
        this.categoryIcon,
        this.notes,
        this.value,
        this.place,
        this.budgetTimestamp,
        this.budget,
    });


    Expense.fromMap(Map<String, dynamic> map)
      : assert(map['timestamp'] != null),
        assert(map['tabMonthExp'] != null),
        assert(map['day'] != null),
        assert(map['dateCreate'] != null),
        assert(map['category'] != null),
        assert(map['categoryColor'] != null),
        assert(map['categoryIcon'] != null),
        assert(map['notes'] != null),
        assert(map['value'] != null),
        assert(map['place'] != null),
        assert(map['budgetTimestamp'] != null),
        assert(map['budget'] != null),
       
        timestamp= map["timestamp"],
        tabMonthExp= map["tabMonthExp"],
        day = map["day"],
        dateCreate = map["dateCreate"],
        category= map["category"],
        categoryColor= map["categoryColor"],
        categoryIcon= map["categoryIcon"],
        notes= map["notes"],
        value= map["value"],
        place= map["place"],
        budget= map["budget"],

        budgetTimestamp= map["budgetTimestamp"];
}

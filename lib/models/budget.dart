class Budget {
    String timestamp;
    String name;
    String color;
    String description;
    double incomes;
    double initialIncome;
    double planIncome;
    double expenses;
    double balance;
    String dateCreate;
    String dateUpdate;
    String typeBudget;
    String startDate;
    bool monthlyBudget;
    String endDate;
    int monthBudget;
    List months;
    List monthsExp;

    Budget({
        this.timestamp,
        this.name,
        this.color,
        this.description,
        this.incomes,
        this.initialIncome,
        this.expenses,
        this.balance,
        this.dateCreate,
        this.dateUpdate,
        this.typeBudget,
        this.planIncome,
        this.startDate,
        this.monthlyBudget,
        this.endDate,
        this.months,
        this.monthsExp,
        this.monthBudget,
      
    });

    Budget.fromMap(Map<String, dynamic> map)
      : assert(map['timestamp'] != null),
        assert(map['name'] != null),
        assert(map['color'] != null),
        assert(map['incomes'] != null),
        assert(map['initialIncome'] != null),
        assert(map['planIncome'] != null),
        assert(map['balance'] != null),
        assert(map['expenses'] != null),
        assert(map['dateCreate'] != null),
        assert(map['dateUpdate'] != null),
        assert(map['typeBudget'] != null),
        assert(map['startDate'] != null),
        assert(map['monthlyBudget'] != null),
        assert(map['endDate'] != null),
        assert(map['months'] != null),
        assert(map['monthsExp'] != null),
        assert(map['monthBudget'] != null),
        timestamp = map["timestamp"],
        name = map["name"],
        color = map["color"],
        months = map["months"],
        monthsExp = map["monthsExp"],
        incomes = map["incomes"],
        initialIncome = map["initialIncome"],
        planIncome = map["planIncome"],
        expenses = map["expenses"],
        balance = map["balance"],
        dateCreate = map["dateCreate"],
        dateUpdate = map["dateUpdate"],
        typeBudget = map["typeBudget"],
        startDate = map["startDate"],
        monthlyBudget = map["monthlyBudget"],
        endDate = map["endDate"],
        monthBudget = map["monthBudget"]; 
    
    @override
    String toString() => "Record: $name";

}
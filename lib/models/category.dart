class Category {
  String timestamp;
  String categoryName;
  String color;
  String icon;
  String date;

  Category({this.timestamp, this.categoryName, this.color, this.icon, this.date});

  Category.fromMap(Map<String, dynamic> map)
      : assert(map['timestamp'] != null),
        assert(map['category name'] != null),
        assert(map['color'] != null),
        assert(map['icon'] != null),
        assert(map['date'] != null),
      timestamp = map["timestamp"],
      categoryName = map["category name"],
      color = map["color"],
      icon = map["icon"],
      date = map["date"];

}
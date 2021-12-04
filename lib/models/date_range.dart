class DateRange {
    String From;
    String To;

    DateRange({
        this.From,
        this.To,

    });

    DateRange.fromMap(Map<String, dynamic> map)
      : assert(map['From'] != null),
        assert(map['To'] != null)
        ;
}
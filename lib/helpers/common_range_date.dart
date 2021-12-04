
import 'package:ball_on_a_budget_planner/models/drop_list_model.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

// Aujourdhui

 Tuple2<DateTime, DateTime> Today()
{
  DateTime today = DateTime.now();

  return new Tuple2<DateTime, DateTime>(today, today);
}

// Cette semaine
 Tuple2<DateTime, DateTime> ThisWeek()
{

  DateTime mondayOfThisWeek = DateTime.now().add( Duration(days: -DateTime.now().weekday + 1 ));
  DateTime sundayOfThisWeek = mondayOfThisWeek.add(Duration(days: 6));

  return new Tuple2<DateTime, DateTime>(mondayOfThisWeek, sundayOfThisWeek);
}

// Ce mois
 Tuple2<DateTime, DateTime> ThisMonth()
{
  DateTime currentDate = DateTime.now();
  DateTime firstDate = new DateTime(currentDate.year, currentDate.month, 1);
  DateTime lastDate = new DateTime(firstDate.year, firstDate.month + 1, firstDate.day - 1);

  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}

// Cette année
 Tuple2<DateTime, DateTime> ThisYear()
{
  DateTime firstDate = new DateTime(DateTime.now().year, 1, 1);
  DateTime lastDate = new DateTime(firstDate.year + 1, firstDate.month, firstDate.day - 1);

  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}

// Hier
 Tuple2<DateTime, DateTime> Yesterday()
{
  DateTime yesterday = DateTime.now().add(Duration(days: -1));

  return new Tuple2<DateTime, DateTime>(yesterday, yesterday);
}


// Semaine dernière
 Tuple2<DateTime, DateTime> LastWeek()
{

  DateTime mondayOfLastWeek = DateTime.now().add(Duration(days: -DateTime.now().weekday - 6));
  DateTime sundayOfLastWeek = mondayOfLastWeek.add(Duration(days: 6));

  return new Tuple2<DateTime, DateTime>(mondayOfLastWeek, sundayOfLastWeek);

}


// Mois dernier
 Tuple2<DateTime, DateTime> LastMonth()
{
  DateTime today = DateTime.now();
  DateTime lastMonthDate = new DateTime(today.year, today.month - 1, today.day);
  DateTime firstDate = new DateTime(lastMonthDate.year, lastMonthDate.month, 1);
  DateTime lastDate = new DateTime(firstDate.year, firstDate.month + 1, firstDate.day - 1);


  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}

// Trois derniers Mois

 Tuple2<DateTime, DateTime> LastThreeMonths()
{
  DateTime today = DateTime.now();
  DateTime firstDate = new DateTime(today.year, today.month - 3, today.day);
  DateTime lastDate = today;

  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}


// Six derniers Mois
 Tuple2<DateTime, DateTime> LastSixMonths()
{
  DateTime today = DateTime.now();
  DateTime firstDate = new DateTime(today.year, today.month - 6, today.day);
  DateTime lastDate = today;

  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}

// L'année dernière
 Tuple2<DateTime, DateTime> LastYear()
{
  DateTime firstDate = new DateTime(DateTime.now().year - 1, 1, 1);
  DateTime lastDate = new DateTime(firstDate.year + 1, firstDate.month, firstDate.day - 1);

  return new Tuple2<DateTime, DateTime>(firstDate, lastDate);
}

List<Tuple2<DateTime, DateTime>> PredefinedRangeDates()
{
  List<Tuple2<DateTime, DateTime>> pdates = List<Tuple2<DateTime, DateTime>>.empty(growable: true);

  pdates.add(Today());
  pdates.add(ThisWeek());
  pdates.add(ThisMonth());
  pdates.add(ThisYear());
  pdates.add(Yesterday());
  pdates.add(LastWeek());
  pdates.add(LastMonth());
  pdates.add(LastThreeMonths());
  pdates.add(LastSixMonths());
  pdates.add(LastYear());

  return pdates;
}

List<Tuple2<String,Tuple2<DateTime, DateTime>>> PredefinedRangeDatesWithKeys()
{
  List<Tuple2<String,Tuple2<DateTime, DateTime>>> pdateswithk = List<Tuple2<String,Tuple2<DateTime, DateTime>>>.empty(growable: true);

  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("customized".tr(),Today()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("today".tr(),Today()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("this_week".tr(),ThisWeek()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("this_month".tr(),ThisMonth()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("this_year".tr(),ThisYear()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("yesterday".tr(),Yesterday()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("last_week".tr(),LastWeek()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("last_month".tr(),LastMonth()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("last_three_months".tr(),LastThreeMonths()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("last_six_months".tr(),LastSixMonths()));
  pdateswithk.add(new Tuple2<String,Tuple2<DateTime, DateTime>>("last_year".tr(),LastYear()));

  return pdateswithk;
}


DropListModel rangeDateListModel(){

  DropListModel dropListModel = DropListModel(
      [
       // OptionItem(id: "0", title: "Non prédéfini"),
        OptionItem(id: "1", title: "today".tr()),
        OptionItem(id: "2", title: "this_week".tr()),
        OptionItem(id: "3", title: "this_month".tr()),
        OptionItem(id: "4", title: "this_year".tr()),
        OptionItem(id: "5", title: "yesterday".tr()),
        OptionItem(id: "6", title: "last_week".tr()),
        OptionItem(id: "7", title: "last_month".tr()),
        OptionItem(id: "8", title: "last_three_months".tr()),
        OptionItem(id: "9", title: "last_six_months".tr()),
        OptionItem(id: "10", title: "last_year".tr())
      ]);

  return dropListModel;

}




Tuple2<DateTime, DateTime> GetFirstAndLastDateOfMonth(DateTime date)
{
  DateTime firstDate = new DateTime(date.year, date.month, 1);
  DateTime lastDate = new DateTime(date.year, date.month + 1, 1).add(Duration(days: -1));
  DateTime ld = new DateTime(lastDate.year, lastDate.month, lastDate.day, 23, 59, 59);
  return new Tuple2<DateTime, DateTime>(firstDate, ld);
}

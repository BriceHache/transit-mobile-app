import 'dart:collection';
import 'package:ball_on_a_budget_planner/bloc/statistics_bloc/statistics_bloc.dart';
import 'package:ball_on_a_budget_planner/dossiers/dossiers_list.dart';
import 'package:ball_on_a_budget_planner/helpers/common_range_date.dart';
import 'package:ball_on_a_budget_planner/helpers/helpers.dart';
import 'package:ball_on_a_budget_planner/models/drop_list_model.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/models/statistics.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';
import 'package:ball_on_a_budget_planner/resources/api_repository.dart';
import 'package:ball_on_a_budget_planner/widgets/button_fixe_width_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:ball_on_a_budget_planner/widgets/select_drop_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'dart:async';

import 'package:ball_on_a_budget_planner/helpers/next_screen.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/widgets/card_expense_month.dart';
import 'package:ball_on_a_budget_planner/widgets/chart_categories_list.dart';
import 'package:ball_on_a_budget_planner/widgets/circularPieChart.dart';
import 'package:ball_on_a_budget_planner/widgets/line_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'package:easy_localization/easy_localization.dart';

import '../banklin_icons.dart';
import '../helpers/utils.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'cc_expenses/add_expense.dart';
import 'home_page.dart';
import 'incomes/add_incomes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  String tabMonth, monthLabel;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  Stream<QuerySnapshot> query;
  Stream<QuerySnapshot> query2;

  List<Expense> expenses;
  List<Income> incomes;
  int month;

  String userid;
  final storage = new FlutterSecureStorage();


  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  bool isSearching;
  ApiRepository _apiRepository = new ApiRepository();

   StatisticsBloc _statisticsBloc ;

  List<Tuple2<String,Tuple2<DateTime, DateTime>>> rangeDates;

  Tuple2<String,Tuple2<DateTime, DateTime>> selectedValue;


  @override
  void initState() {
    super.initState();

    setUserid();
    isSearching = false;

    DateTime now = DateTime.now();
    tabMonth = '${now.month.toString()}${now.year.toString()}';

    monthLabel =
        '${labelMonth(tabMonth.substring(0, 3))}' + ' ${now.year.toString()}';
    month = now.month;

    DateTime nowDate = DateTime.now();
    Tuple2<DateTime, DateTime> currentMontDates = GetFirstAndLastDateOfMonth(nowDate);
    _startDate = currentMontDates.item1;
    _endDate = currentMontDates.item2;

    _statisticsBloc = StatisticsBloc(_apiRepository);

    _statisticsBloc.add(GetStatisticsList(
        DateFormat('dd/MM/yyyy').format(_startDate).toString(),
        DateFormat('dd/MM/yyyy').format(_endDate).toString()
    ));

    rangeDates = PredefinedRangeDatesWithKeys();

    selectedValue = rangeDates[0];


    print(userid);
  }

  void setUserid() async {
    userid = await storage.read(key: 'userId');
    print(userid);

    setState(() {

    });
  }

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        isSearching = true;
        _statisticsBloc.add(GetStatisticsList(
            DateFormat('dd/MM/yyyy').format(_startDate).toString(),
            DateFormat('dd/MM/yyyy').format(_endDate).toString()
        ));
      });
    }
  }

  Future setDateRange(DateTime from, DateTime to) async {
      setState(() {
        _startDate = from;
        _endDate = to;
        isSearching = true;
        _statisticsBloc.add(GetStatisticsList(
            DateFormat('dd/MM/yyyy').format(_startDate).toString(),
            DateFormat('dd/MM/yyyy').format(_endDate).toString()
        ));
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:
       SingleChildScrollView(
       scrollDirection: Axis.vertical,
             child: SingleChildScrollView(
             scrollDirection: Axis.horizontal,
                    child :
                          Column(
                            children: [
                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Column(
                                      children: [

                                        NiceText(
                                            DateFormat('dd/MM/yyyy').format(_startDate).toString(),
                                            'debut'.tr(),
                                            Colors.green, type: "date", textStyle: 12,)

                                      ],

                                    )
                                    ,
                                    Column(
                                      children: [

                                        NiceText(
                                            DateFormat('dd/MM/yyyy').format(_endDate).toString(),
                                            'fin'.tr(),
                                            Colors.green,type: "date",textStyle: 12,)

                                      ],

                                    )

                                  ]
                              ),
                              Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: DropdownButton<Tuple2<String,Tuple2<DateTime, DateTime>>>(
                                      items: rangeDates.map((Tuple2<String,Tuple2<DateTime, DateTime>> value) {
                                        return DropdownMenuItem<Tuple2<String,Tuple2<DateTime, DateTime>>>(
                                          value: value,
                                          child: Text(value.item1,
                                           // style: TextStyle(color: Colors.black)
                                            ),
                                        );
                                      }).toList(),
                                      value: selectedValue,
                                      focusColor: Colors.white,
                                    //  dropdownColor: Colors.black,
                                      dropdownColor: Colors.black,

                                      style: TextStyle(color: Colors.white),
                                      onChanged: (Tuple2<String,Tuple2<DateTime, DateTime>> value) {
                                        print(value);
                                        setState(() {
                                          selectedValue = value;
                                        });
                                        if(value.item1 != "customized".tr()) {
                                          setDateRange(value.item2.item1, value.item2.item2);
                                        }
                                        //_startDate = value.item2.item1;
                                        //_endDate = value.item2.item2;
                                      },
                                    ),
                                  )
                                  /*DropdownButton<String>(
                                    items: <String>['Agrfggyh', 'Bhhhuii', 'Chhhhu', 'Dgggghhy'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {},
                                  )*/
                                  /*Center(
                                    child:
                                   DropdownButton(
                                      hint: Text('Please choose a location'), // Not necessary for Option 1
                                      value: _selectedLocation,
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedLocation = newValue;
                                        });
                                      },
                                      items: _locations.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location),
                                          value: location,
                                        );
                                      }).toList(),
                                    )*/
                                /*  Expanded(child:
                                  _showPrefinedRangeDates(),
                                  ),*/

                              ],),

                              Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: <Widget>[

                                        //Expanded(child:
                                        Container(

                                            width:250,
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Column(
                                                children: [
                                                  Container(height: 10,),
                                                  LargeButton(
                                                    onTap: () async{
                                                      await displayDateRangePicker(context);
                                                    },
                                                    title: 'select_periode'.tr(),
                                                    fontSize: 12,
                                                  ),
                                                  Container(height: 10,),
                                                ]
                                            )
                                        ),
                                        //)
                                      ]
                                     ),
                                       //SizedBox(height: 30,),
                                    /*Container(

                                        width:250,
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                            children: [
                                              Container(height: 20,),
                                              LargeButton(
                                                onTap: () async{
                                                  await displayDateRangePicker(context);
                                                },
                                                title: 'select_periode'.tr(),
                                                fontSize: 18,
                                              ),
                                              Container(height: 20,),
                                            ]
                                        )
                                    ),*/

                                  ]),
                              _buildStatistics()
                            ],
                          ),
             ),
       ),
    );
  }

  Widget _buildStatistics() {
    return Container(

      child: BlocProvider(
        create: (_) => _statisticsBloc,

        child: BlocListener<StatisticsBloc, StatisticsState>(
          listener: (context, state) {
            if (state is StatisticsError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<StatisticsBloc, StatisticsState>(

            builder: (context, state) {
              if (state is StatisticsInitial) {
                return _buildLoading();
              } else if (state is StatisticsLoading) {

                return _buildLoading();
              } else if (state is StatisticsLoaded) {

                return _buildCard(context, state.statistics);

              } else if (state is StatisticsError) {


                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text( state.message ,
                          style: customStyleLetterSpace(Colors.white, 20, FontWeight.w800,0.338)),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                             Image.asset('assets/images/no_data2.png',height: 200)
                        ],
                      )

                    ],
                  ),
                );
               // return Container();
              }else{
                  return Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            SizedBox(height: 10,),
                            Text( "Pas de connexion internet." ,
                            style: customStyleLetterSpace(Colors.white, 14, FontWeight.w800,0.338)),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                  Image.asset('assets/images/no_data.png',height: 200)
                              ],
                            )
                        ],
                      ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  SelectDropList _showPrefinedRangeDates(){

    DropListModel dropListModel = rangeDateListModel();

    Tuple2<DateTime, DateTime> rangeDate;

    OptionItem optionItemSelected = OptionItem(id: "0", title: "Non prédéfinie");
    return
      SelectDropList(
        optionItemSelected,
        dropListModel,
            (optionItem){
          optionItemSelected = optionItem;
          setState(() {

            if(optionItem.id == "1"){
              rangeDate = Today();
            }else if(optionItem.id =="2") {
              rangeDate = ThisWeek();
            }else if(optionItem.id =="3") {
              rangeDate = ThisMonth();
            }else if(optionItem.id =="4") {
              rangeDate = ThisYear();
            }else if(optionItem.id =="5") {
              rangeDate = Yesterday();
            }else if(optionItem.id =="6") {
              rangeDate = LastWeek();
            }else if(optionItem.id =="7") {
              rangeDate = LastMonth();
            }else if(optionItem.id =="8") {
              rangeDate = LastThreeMonths();
            }else if(optionItem.id =="9") {
              rangeDate = LastSixMonths();
            }else if(optionItem.id =="10") {
              rangeDate = LastYear();
            }

            _startDate = rangeDate.item1;
            _endDate = rangeDate.item2;
            isSearching = true;
            _statisticsBloc.add(GetStatisticsList(
                DateFormat('dd/MM/yyyy').format(_startDate).toString(),
                DateFormat('dd/MM/yyyy').format(_endDate).toString()
            ));

          });
        },
      );
  }

  Widget _buildCard(BuildContext context, Statistics model) {
    print(model);
    return   Column(

      children: [
        //SizedBox(height: 10,),

        StreamBuilder(

          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> data) {

            return Column(
                children: [

                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextButton(
                          onPressed: (){

                             //nextScreen(context,  HomePage(from: _startDate, to: _endDate, selectedPage: 1, title: 'dossiers'.tr()));
                             nextScreen(context,  DossiersPage(_startDate, _endDate));
                          //  Navigator.pushReplacement(context, navegateFadein(context,  HomePage(from: _startDate, to: _endDate, selectedPage: 1, title: 'dossiers'.tr())));

                          },

                          child: Column(
                            children: [

                              _overviewExpenses(
                                  "${model.total_dossiers}", 'dossiers_s'.tr(),
                                  Colors.blue)

                            ],

                          ),
                        ),
                        TextButton(
                          onPressed: (){
                            nextScreen(context, AddIncomePage());
                          },

                          child: Column(
                            children: [

                              _overviewExpenses(
                                  "${model.total_clients}", 'clients_s'.tr(), Colors.blue, icon: BanklinIcons.settings)
                            ],
                          ),
                        ),

                      ]
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        TextButton(
                          onPressed: (){
                            nextScreen(context, AddIncomePage());
                          },

                          child: Column(
                            children: [

                              _overviewExpenses(
                                  "${model.reglements}", 'reglementsc'.tr(), Colors.green, icon: BanklinIcons.business, type: "amount")
                            ],
                          ),
                        ),
                      ]
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextButton(
                          onPressed: (){
                            nextScreen(context, AddExpensePage());
                          },

                          child: Column(
                            children: [
                              //Icon(BanklinIcons.wallet),
                              _overviewExpenses(
                                  "${model.chiffre_affaires}", 'chiffreaffaire_s'.tr(),
                                  Colors.green, icon: BanklinIcons.analytics, type: "amount")

                            ],

                          ),
                        ),

                      ]
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TextButton(
                          onPressed: (){
                            nextScreen(context, AddExpensePage());
                          },

                          child: Column(
                            children: [

                              _overviewExpenses(
                                  "${model.encours}", 'encours_s'.tr(),
                                  Colors.green, icon: BanklinIcons.pay, type: "amount")

                            ],

                          ),
                        ),

                      ]
                  ),

                ]
            );
          },
        ),

        StreamBuilder(

          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> data) {

            return Column(
              children: [


              ],
            );
          },
        )

        ,
      ],
    );

  }

 // Widget _buildLoading() => Center(child: CircularProgressIndicator());
  Widget _buildLoading() =>Center(child:SpinKitFadingCircle(size: 150, color: Theme.of(context).accentColor));

  Widget _overviewExpenses(String amount, String title, Color colorMoney ,{String type = "number", IconData icon =  BanklinIcons.wallet}) {
    return Container(

      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),),
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(

            children:
            [

              Center(
                child: Row(
                  children: [
                      Column(
                        children: [

                          if(type == "number" || type == "amount")
                            Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only( bottom: 5.0),
                                    child: Icon(icon)
                                )
                              ],

                            ),

                          Row(
                            children: [
                              Container(

                                padding: EdgeInsets.all(1),
                                child: Text(title, style: customStyle(
                                    Colors.white, 14, FontWeight.normal)
                                ),
                              ),
                              Center(
                                child: Text(
                              _getStats(amount, type: type),
                                   // "  \$${oCcy.format(amount)}",
                                    style: customStyle(colorMoney, 14, FontWeight.bold)


                                ),
                              )
                            ],
                          ),
                        ],
                      )
                  ],
                ),
              ),

            ],
          ),

        ),

      ),);
  }

  Widget _statisticCard(String title, String data) {
    return Container(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.pink,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album, size: 70),
              title: Text('title', style: TextStyle(color: Colors.white)),
              subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
            ),
            ButtonBarTheme(
              data: null,
              child: ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text(
                        'Edit', style: TextStyle(color: Colors.white)),
                    onPressed: () {

                    },
                  ),
                  TextButton(
                    child: const Text(
                        'Delete', style: TextStyle(color: Colors.white)),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStats(String value, {type = "number", devise = "FCFA"}){

    if(type == "number" || type == "date"){
      return value;
    }else{
      return value + " " + devise;
    }
  }

  Tuple2<DateTime, DateTime> GetFirstAndLastDateOfMonth(DateTime date)
  {
    DateTime firstDate = new DateTime(date.year, date.month, 1);
    DateTime lastDate = new DateTime(date.year, date.month + 1, 1).add(Duration(days: -1));
    DateTime ld = new DateTime(lastDate.year, lastDate.month, lastDate.day, 23, 59, 59);
    return new Tuple2<DateTime, DateTime>(firstDate, ld);
  }

  void navigateToLastPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String lastRoute = prefs.getString('last_route');
    if (lastRoute.isNotEmpty && lastRoute != '/') {
      Navigator.of(context).pushNamed(lastRoute);
    }
  }

}
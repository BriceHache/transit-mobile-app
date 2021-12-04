import 'dart:async';
import 'package:ball_on_a_budget_planner/dossiers/see_dossier.dart';
import 'package:ball_on_a_budget_planner/helpers/common_range_date.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

class DossiersPage extends StatefulWidget {


  //Static references to our parent widget variables
  final DateTime From_date;
  final DateTime To_date;


  DossiersPage(DateTime from,DateTime to):
        this.From_date = from,
        this.To_date = to
  ;

  @override
  _DossiersState createState() => _DossiersState();
}


class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer
          .cancel(); // when the user is continuosly typing, this cancels the timer
    }
    // then we will start a new timer looking for the user to stop
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}


class _DossiersState extends State<DossiersPage> {

  bool _isUpdating;
  String _titleProgress;
  bool _isloading;
  String response_status ;

  List<GetDossier> _dossiers;
  // this list will hold the filtered dossiers
  List<GetDossier> _filterDossiers;

  GetDossier _selectedDossier;

  //our variable to use for our dates input
  DateTime _startDate;
  DateTime _endDate;
  String _searchValue;

  // final _debouncer = Debouncer(milliseconds: 2000);

  List<Tuple2<String,Tuple2<DateTime, DateTime>>> rangeDates;

  Tuple2<String,Tuple2<DateTime, DateTime>> selectedValue;


  @override
  void initState() {

    super.initState();

    _dossiers = [];
    _filterDossiers = [];
    _isUpdating = false;
    _isloading = true;
    response_status = "ongoing";

    _startDate =  widget.From_date ;
    _endDate = widget.To_date;
    _searchValue = "";

    _getDossiers();

    rangeDates = PredefinedRangeDatesWithKeys();

    selectedValue = rangeDates[0];
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
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
        _isloading = true;

      });
    }

    _getDossiers();
  }

  Future setDateRange(DateTime from, DateTime to) async {
    setState(() {
      _startDate = from;
      _endDate = to;
      _isloading = true;
      _getDossiers();
    });
  }

  _getDossiers() {
    _showProgress('Chargement des dossiers...');
    RequestParamDataTable _dossierDataTable = new RequestParamDataTable(
      start_date :  DateFormat('dd/MM/yyyy').format(_startDate).toString(),
       end_date : DateFormat('dd/MM/yyyy').format(_endDate).toString(),
      sSearch: _searchValue
    );

    Future<Tuple2<List<GetDossier>, String>> dossiersGlobalResponse =  ApiProvider.GetAllDossiers(_dossierDataTable);
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _dossiers = _realResponse.item1;

        // Initialize to the list from Server when reloading...
        _filterDossiers = _realResponse.item1;

        //
        if(_realResponse.item2 == "Success"){
          response_status = "success";
        }else if(_realResponse.item2 == "Error"){
          response_status = "error";
        }else {
          response_status = "connexion_failed";
        }
        _isloading = false;

      });

      print("Length ${_realResponse.item1.length}");
    });
  }

  // Let's add a searchfield to search in the DataTable.
  searchField() {
    return
     // Padding(
      Row(
        mainAxisSize: MainAxisSize.min,
     // padding: EdgeInsets.all(5.0),
      children: [
        
      Flexible(
        child: TextField(

          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),

              hintText: 'Filtrer (N° de dossier / nom du client)',
              fillColor: Colors.white,
              hintStyle: TextStyle(color: Colors.grey)


          ),

          style: TextStyle(color: Colors.white),
          onChanged: (string) {
            // We will start filtering when the user types in the textfield.
            // Run the debouncer and start searching

            //  _debouncer.run(() {
            // Filter the original List and update the Filter list
            setState(() {
              _isloading = true;
              _filterDossiers = _dossiers
                  .where((u) => (u.numero_dossier
                  .toLowerCase()
                  .contains(string.toLowerCase()) ||
                  u.ClientName.toLowerCase().contains(string.toLowerCase())))
                  .toList();

              _isloading = false;

            });

            //});
          },
        ),
      ),
      ]
    );
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
                     Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              _rangeDate(),
                              _customizedRangeDateSelect(),
                              _selectPeriode(),
                              //searchField(),

                           (response_status != "connexion_failed") ?

                                // Expanded(
                                   // child:
                           Container(

                               child:

                                    _isloading ? _buildLoading() :  _dataBody()
                           )
                                   // )
                             :
                                  Container(
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
                                ),
                            ],
                          ),

                      ),
                  ),

              )

    );
   }

  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
  //Widget _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return

      SingleChildScrollView(
      scrollDirection: Axis.vertical,

        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.blue),
            child: DataTable(
              dividerThickness: 5.0,
              columnSpacing : 0,
              decoration :  BoxDecoration(
                    border:
                    Border.all(
                    width: 1,
                      color: Colors.blue,

                    )
              ),

              columns: [
                DataColumn(
                  label: Container(
                  padding: EdgeInsets.all(0.0),
                  width: 40,

                      child: Text(
                        'N°',
                        style: TextStyle(color: Colors.blue),
                        textAlign: TextAlign.left,
                      ),

                  )

                ),
                DataColumn(label: _verticalDivider),

                DataColumn(
                  label: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 130,
                    child: Center(
                      child: Text(
                        'Client',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ),
                DataColumn(label: _verticalDivider),
                // Lets add one more column to show a see button and update button
                DataColumn(
                  label: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 50,
                    child: Center(
                      child: Text(
                        'Actions',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                )
              ],
              // the list should show the filtered list now
              rows: _filterDossiers.length > 0 ? _filterDossiers
                  .map(
                    (dossier) => DataRow(cells: [

                  DataCell(
                    Container(
                      width: 40,
                      padding: EdgeInsets.all(0.0),
                      child: Text(dossier.numero_dossier,
                          textAlign: TextAlign.left,
                        style: TextStyle(
                        color: Colors.white,
                          fontSize: 10.0
                      ),
                      ),
                      alignment: Alignment.centerLeft
                    ),
                    onTap: () {
                      _seeDossier(dossier);
                      // Set the Selected employee to Update
                      _selectedDossier = dossier;
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(_verticalDivider),
                  DataCell(

                    Container(
                      width: 130,
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        dossier.ClientName.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                              fontSize: 10.0
                          ),
                        maxLines: 3,
                      ),
                    ),
                    onTap: () {
                      _seeDossier(dossier);
                      // Set the Selected employee to Update
                      _selectedDossier = dossier;
                      // Set flag updating to true to indicate in Update Mode
                      setState(() {
                        _isUpdating = true;
                      });
                    },
                  ),
                  DataCell(_verticalDivider),
                  DataCell(
                      Container(
                        width: 50,
                        padding: EdgeInsets.all(0.0),
                        //child: Expanded(
                        alignment : Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                           // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              /*Expanded(child:  IconButton(
                                  icon: Icon(Icons.remove_red_eye, color: Colors.white,),
                                  iconSize: 18.0,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(1.0),

                                  onPressed: () {
                                    _seeDossier(dossier);
                                  },

                              ), ),*/
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.green,),
                                  iconSize: 18.0,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(1.0),
                                  onPressed: () {
                                   // _editDossier(dossier);
                                  },

                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
                                  iconSize: 18.0,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(1.0),
                                  onPressed: () {
                                    // _editDossier(dossier);
                                  },

                                ),
                              )

                            ],
                          ),
                        //),
                      )
                    )
                ]),
              )
                  .toList() :
                  [
                   DataRow(cells: [
                     DataCell(

                      SizedBox.shrink()

                     ),
                     DataCell(SizedBox.shrink()),
                     DataCell( Container(
                         width: 130,
                         padding: EdgeInsets.all(0.0),
                         child: Text("Aucun dossier.",
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               color: Colors.white,
                               fontSize: 10.0
                           ),
                         ),
                         alignment: Alignment.center
                     ),),
                     DataCell(SizedBox.shrink()),
                     DataCell(SizedBox.shrink()),
                   ])
                  ]
            ),
          )
           ,
           //;

       ),

    );
  }

  _seeDossier(GetDossier dossier){

    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeDossierPage(dossier: dossier,)));

  }

  Widget _rangeDate(){

    return
      Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [

                NiceText(
                    DateFormat('dd/MM/yyyy')
                        .format(_startDate)
                        .toString(),
                    'debut'.tr(),
                    Colors.green, type: "date",textStyle: 12)

              ],

            )
            ,
            Column(
              children: [

                NiceText(
                    DateFormat('dd/MM/yyyy')
                        .format(_endDate)
                        .toString(),
                    'fin'.tr(),
                    Colors.green, type: "date",textStyle: 12)

              ],

            )

          ]
      );
  }

  Widget _selectPeriode(){

    return
      Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //SizedBox(height: 30,),
            Container(

                width: 250,
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                    children: [
                      Container(height: 10),
                      LargeButton(
                        onTap: () async {
                          await displayDateRangePicker(context);
                        },
                        title: 'select_periode'.tr(),
                        fontSize: 12,
                      ),
                      Container(height: 10,),
                    ]
                )
            ),


          ]);

  }

  Widget _customizedRangeDateSelect(){

    return
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

              },
            ),
          )

        ],);
  }

  Widget _buildLoading() =>Center(

    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Text(_titleProgress, style: TextStyle(color: Colors.white)), // we show the progress in the title...
        SpinKitFadingCircle(size: 150, color: Theme.of(context).accentColor)
      ],
    )
  );

  Widget _verticalDivider = const VerticalDivider(
    color: Colors.blue,
    thickness: 1,
  );



}
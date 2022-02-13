import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:ball_on_a_budget_planner/clients/see_files_in_directory.dart';
import 'package:ball_on_a_budget_planner/clients/see_internal_document.dart';
import 'package:ball_on_a_budget_planner/clients/see_releve.dart';
import 'package:ball_on_a_budget_planner/helpers/common_range_date.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/models/client_datatable.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_client_details.dart';
import 'package:ball_on_a_budget_planner/models/releve.dart';
import 'package:ball_on_a_budget_planner/widgets/button_fixe_width_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/button_width_flexible_dimensions.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:ball_on_a_budget_planner/widgets/profile_tile.dart';
import 'package:ball_on_a_budget_planner/widgets/recap_solde_card.dart' as cw;
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/widgets.dart' as pw ;


class ReleveDeComptePage extends StatefulWidget {

  //Static references to our parent widget variables
  final DateTime From_date;
  final DateTime To_date;
  final GetClient client;


  ReleveDeComptePage(DateTime from,DateTime to, GetClient _client):
        this.From_date = from,
        this.To_date = to,
        this.client = _client
  ;
  @override
  _ReleveDeComptePageState createState() => _ReleveDeComptePageState();
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


class _ReleveDeComptePageState extends State<ReleveDeComptePage> {

  bool _isUpdating;
  String _titleProgress;
  bool _isloading;
  bool _isloadingDoc;
  String response_status ;
  GetClient current_client = new GetClient();
  //= new GetClient();
  String downloadPath;

  List<GetClientDetails> _clients;
  // this list will hold the filtered clients
  List<GetClientDetails> _filterClients;

  GetClientDetails _selectedClient;

  //our variable to use for our dates input
  DateTime _startDate;
  DateTime _endDate;
  String _searchValue;

  // final _debouncer = Debouncer(milliseconds: 2000);

  List<Tuple2<String,Tuple2<DateTime, DateTime>>> rangeDates;

  Tuple2<String,Tuple2<DateTime, DateTime>> selectedValue;

  File currentFile;

  @override
  void initState() {

    super.initState();

    _clients = [];
    _filterClients = [];
    _isUpdating = false;
    _isloading = true;
    _isloadingDoc = false;
    response_status = "ongoing";

    _startDate =  widget.From_date ;
    _endDate = widget.To_date;
    _searchValue = "";
    current_client = widget.client;

    _getClients();

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
    _getClients();
  }

  Future setDateRange(DateTime from, DateTime to) async {
    setState(() {
      _startDate = from;
      _endDate = to;
      _isloading = true;
      _getClients();
    });
  }

  _getClients() {
    _showProgress('Chargement des transactions...');
    ClientRequestParamDataTable _clientDataTable = new ClientRequestParamDataTable(
      start_date :  DateFormat('dd/MM/yyyy').format(_startDate).toString(),
       end_date : DateFormat('dd/MM/yyyy').format(_endDate).toString(),
      sSearch: _searchValue,
      client_id: current_client.Id
    );

    Future<Tuple2<List<GetClientDetails>, String>> clientsGlobalResponse =  ApiProvider.GetRecapClient(_clientDataTable);
    clientsGlobalResponse.then((_realResponse) {
      setState(() {
        _clients = _realResponse.item1;

        // Initialize to the list from Server when reloading...
        _filterClients = _realResponse.item1;

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
      Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100,
              width: 300,
              child:
                Column(
                  children: [
                    Expanded (
                      child: TextField(

                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(5.0),

                            hintText: 'Filtrer (N° de client / nom du client)',
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.grey)

                        ),

                        style: TextStyle(color: Colors.white),
                        onChanged: (string) {

                          // Filter the original List and update the Filter list
                          setState(() {
                            _isloading = true;
                            _filterClients = _clients
                                .where((u) => (u.DescriptionClient
                                .toLowerCase()
                                .contains(string.toLowerCase()) ||
                                u.Description.toLowerCase().contains(string.toLowerCase())))
                                .toList();

                            _isloading = false;

                          });

                          //});
                        },
                      ),
                    ),
                  ],

                )
              ,
            ),
          ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text('releve_de_compte'.tr() + '-' + current_client.tiDescription,
              style:  customStyleLetterSpace(Colors.white, 10, FontWeight.w700, 0.33)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.picture_as_pdf,
                  //color: Colors.red
                  color: Theme.of(context).accentColor
              ),
              onPressed: () {

                generateReport();
                //currentFile.writeAsBytes(bytes);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye_rounded,
                  //color: Colors.red
                  color: Theme.of(context).accentColor
              ),
              onPressed: () {

                _seeDocs();
                //currentFile.writeAsBytes(bytes);
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.times,
                color: Theme.of(context).accentColor,),
              onPressed: (){Navigator.of(context).pop();},
            )],
        ),
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
                              Container(
                                  child:
                                  _isloadingDoc ? _buildLoading() :  null
                              ),
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
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                  width: MediaQuery.of(context).size.width,
                  height: (_filterClients.length  == 0 ? 100.0 : 65 + 44.0 * _filterClients.length)
              ),

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
                   // width: 40,

                        child: Text(
                          'Date',
                          style: TextStyle(color: Colors.blue, fontSize: 8.5),
                          textAlign: TextAlign.left,
                        ),

                    )

                  ),
                  DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(0.0),
                     // width: 130,
                      child: Center(
                        child: Text(
                          'Description',
                          style: TextStyle(color: Colors.blue, fontSize: 8.5),
                        ),
                      ),
                    )
                  ),
                  DataColumn(label: _verticalDivider),
                  // Lets add one more column to show a see button and update button
                  DataColumn(
                      label: Container(
                        padding: EdgeInsets.all(0.0),
                       // width: 50,
                        child: Center(
                          child: Text(
                            'Débit',
                            style: TextStyle(color: Colors.blue, fontSize: 8.5),
                          ),
                        ),
                      )
                  ),
                  DataColumn(label: _verticalDivider),
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(0.0),
                      //width: 50,
                      child: Center(
                        child: Text(
                          'Crédit',
                          style: TextStyle(color: Colors.blue, fontSize: 8.5),
                        ),
                      ),
                    )
                  )

                ],
                // the list should show the filtered list now
                rows: _filterClients.length > 0 ? _filterClients
                    .map(
                      (client_t) => DataRow(cells: [

                    DataCell(
                      Container(
                       // width: 40,
                        padding: EdgeInsets.all(0.0),
                        child: Text(client_t.date,
                            textAlign: TextAlign.left,
                          style: TextStyle(
                          color: Colors.white,
                            fontSize: 8.5
                        ),
                        ),
                        alignment: Alignment.centerLeft
                      ),
                      onTap: () {

                      },
                    ),
                    DataCell(_verticalDivider),
                    DataCell(

                      Container(
                       // width: 130,
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          (client_t.Description == null)  ? "RAS" :
                          client_t.Description,
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 8.5
                            ),
                          maxLines: 3,
                        ),
                      ),
                      onTap: () {

                      },
                    ),
                    DataCell(_verticalDivider),
                    DataCell(
                        Container(
                         // width: 50,
                          padding: EdgeInsets.all(0.0),

                            child: Text(
                              client_t.Debit,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5
                              ),
                              maxLines: 3,
                            )
                          //),
                        ),
                      onTap: () {

                      },
                      ),
                        DataCell(_verticalDivider),
                        DataCell(
                          Container(
                            // width: 50,
                              padding: EdgeInsets.all(0.0),

                              child: Text(
                                client_t.Credit,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5
                                ),
                                maxLines: 3,
                              )
                            //),
                          ),
                          onTap: () {

                          },
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
                          // width: 130,
                           width: MediaQuery.of(context).size.width,
                           padding: EdgeInsets.all(0.0),
                           child: Text("Aucune opération.",
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
                       DataCell(SizedBox.shrink()),
                       DataCell(SizedBox.shrink())
                     ])
                    ]
              ),
            ),
          )
           ,
       ),

    );
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

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }

  final _whitespaceRE = RegExp(r"\s+");
  String cleanupWhitespace(String input) =>
      input.replaceAll(_whitespaceRE, "");


  void generateReport() async {
    setState(() {
      _isloadingDoc = true;
    });

    var releve = generateReleve();  

    try {

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      String doc_name =  current_client.tiDescription + ' Du_' +
      DateFormat('dd_MM_yyyy').format(_startDate).toString() + '_au_' +
      DateFormat('dd_MM_yyyy').format(_endDate).toString() + '.pdf';
      final output = '/storage/emulated/0/Download/CTI/' +current_client.tiDescription;
      String path = output +"/" + doc_name;

      var file = new File(path).create(recursive: true)
          .then((value) async =>
              {
                await value.writeAsBytes(await releve),
               // await value.writeAsBytes(await document.save()),
                setState(() {
                  currentFile = value;
                }),


              }
           );
      setState(
              () => downloadPath = output
      );

      showDialog(
        builder: (context) =>  AlertDialog(
          title: Text( 'releve_de_compte'.tr() + '-' + current_client.tiDescription ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("Document enregistré." )),
                    )
                  ],
                ),

              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:
                  Row(
                    children: [
                      FlexibleButton(icon: FontAwesomeIcons.eye,
                          title: 'Voir', callback: _seeDocs,
                          color:Colors.deepPurpleAccent
                          , width: 150,
                      )
                    ],
                  )
              )
            ],
          ) ,
          actions: [
            MaterialButton(
                child: Text('OK'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => Navigator.pop(context)
            )
          ],
          scrollable: true,
        ),
        barrierDismissible: false,
        context: context,

      );

   //   Navigator.push(context, MaterialPageRoute(builder: (context) => SeeInternalDocument(path: path, title: 'releve_de_compte'.tr() + '-' + current_client.tiDescription)));

      print(output);
      print(doc_name);
      print(currentFile);

      setState(() {
        _isloadingDoc = false;
      });

    }catch (error, stacktrace) {
      setState(() {
        _isloadingDoc = false;
      });
      showAlert(context, "Une exception est survenue","$error stackTrace: $stacktrace");
    }

  }

  void _seeDocs() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeDirectoryFiles(targetDirectory: downloadPath, title:  current_client.tiDescription)));
  }


  //generate report

   Future<Uint8List> generateReleve() async {
  final lorem = pw.LoremText();
  PdfPageFormat pageFormat = PdfPageFormat.a4;

  final releve = Releve(
    transactions: _filterClients,
     customerName: current_client.tiDescription,
     customerAddress: current_client.tiEmail,
     periode : 'Du ' +  DateFormat('dd/MM/yyyy').format(_startDate).toString() + ' au ' +
         DateFormat('dd/MM/yyyy').format(_endDate).toString(),
     devise : "FCFA",
     paymentInfo: "",
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
    soldeGlobal: current_client.solde
  );

  return await releve.buildPdf(pageFormat);
}



String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}


}
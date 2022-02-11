import 'dart:async';
import 'package:ball_on_a_budget_planner/dossiers/see_dossier.dart';
import 'package:ball_on_a_budget_planner/dossiers/see_piece_jointe_dossier.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/models/fee_model.dart';
import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_fees.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';
import 'package:ball_on_a_budget_planner/models/key_value.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/labels.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
//import 'package:smart_select/smart_select.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../banklin_icons.dart';

class FraisDossiersPage extends StatefulWidget {

  final GetDossier dossier;
  final  bool showDossiers ;

  const FraisDossiersPage({Key key, this.dossier, this.showDossiers = false }) : super(key: key);

  @override
  _FraisDossiersPageState createState() => _FraisDossiersPageState(
      this.dossier
  );

}


class _FraisDossiersPageState extends State<FraisDossiersPage> {

  _FraisDossiersPageState(
      this.dossier
      );
  
  bool _showDossiers;
  bool _isUpdating;
  bool _isCreating;
  bool _loadDatefields;
  bool _loadinterlocuteurField;
  bool _istransporter;
  bool _hasAmount;

  String _titleProgress;
  bool _isloading;
  String response_status ;
  String response_status_docs ;

  final formkey = GlobalKey<FormState>();
  String selectDocMessage;

  GetDossier dossier = new GetDossier();

  FeeModel feeToAdd = new FeeModel();
  DateTime now = DateTime.now();
  DateTime _etaDate;
  DateTime _etdDate;

  GetFees currentFee = new GetFees();

  List<GetFees> _fraisDossiers;


  List<KeyValueModel> _ensArticles;

  DocumentDossier selectedDocument;

  String selectedDossier;
  String selectedArticle;

  List<KeyValueModel> _ensDossiers;
  List<KeyValueModel> _filterDossiers;
  List<KeyValueModel> _filterArticles;

  // this list will hold the filtered dossiers
  List<GetFees> _filterFraisDossiers;

  GetFees _selectedGetFees;

  Color textColor = Color.fromRGBO(8, 185, 198, 1);
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);

  //File picker management
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String _fileName = null;
  String _saveAsFileName = null;
  List<PlatformFile> _paths = null;
  String _directoryPath;
  String _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = true;
 // FileType _pickingType = FileType.any;
  FileType _pickingType = FileType.custom;
  TextEditingController _controller = TextEditingController();

  String userid;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {

    super.initState();
    setUserid();
    _fraisDossiers = [];
    _filterFraisDossiers = [];

    _ensDossiers = [];
    _filterDossiers = [];

    _ensArticles = [];
    _filterArticles = [];

    _isUpdating = false;
    _isCreating = false;
    _isloading = false;
    _loadDatefields = false;
    _loadinterlocuteurField = false;
    _istransporter = false;
    _hasAmount = true;
    _showDossiers =widget.showDossiers;

    response_status = "ongoing";
    response_status_docs = "ongoing";
    selectDocMessage = "aucun".tr();

    selectedDocument = null;
    _controller.addListener(() => _extension = _controller.text);

    _etaDate = now;
    _etdDate = now;
    feeToAdd.eta = DateFormat.yMd().format(_etaDate.toLocal());
    feeToAdd.etd = DateFormat.yMd().format(_etdDate.toLocal());
    feeToAdd.dossier_id = widget.dossier.id;
    feeToAdd.Comment = "";

    _getFraisDossiers();
    _getEnsDossiers();
    _getEnsArticles();

  }

  void setUserid()async{
    userid = await storage.read(key: 'userId');
    if(userid != null){
      feeToAdd.current_user_id = int.parse(userid);
    }
    print(userid);
    setState(() {

    });
  }
  Future<Null> _selectEtaDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _etaDate == null ? DateTime.now() : _etaDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked != _etaDate) {
      setState(() {
        _etaDate = picked;
        feeToAdd.eta = DateFormat.yMd().format(_etaDate.toLocal());
      });
    }
  }
  Future<Null> _selectEtdDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _etdDate == null ? DateTime.now() : _etdDate,
        firstDate: new DateTime(DateTime.now().year - 50),
        lastDate: new DateTime(DateTime.now().year + 50));
    if (picked != null && picked != _etdDate) {
      setState(() {
        _etdDate = picked;
        feeToAdd.etd = DateFormat.yMd().format(_etdDate.toLocal());
      });
    }
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getFraisDossiers() {
    _showProgress('Chargement des dossiers...');

    Future<Tuple2<List<GetFees>, String>> dossiersGlobalResponse =  ApiProvider.GetAllFees(dossier.id);
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _fraisDossiers = _realResponse.item1;

        // Initialize to the list from Server when reloading...
        _filterFraisDossiers = _realResponse.item1;

        print("Frais : ");
        print(_filterFraisDossiers);
        print("Message:  ");
        print(_realResponse.item2);

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

  _getEnsDossiers() {
    _showProgress('Chargement des dossiers...');
    Future<Tuple2<List<KeyValueModel>, String>> dossiersGlobalResponse =  ApiProvider.GetAllDossiersKV();
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _ensDossiers = _realResponse.item1;
        _filterDossiers = _realResponse.item1;
      });

      print("Length dossiers ${_realResponse.item1.length}");

    });
  }

  _getEnsArticles() {
    _showProgress('Chargement des articles...');
    Future<Tuple2<List<KeyValueModel>, String>> articlesGlobalResponse =  ApiProvider.GetAllArticlesKV();
    articlesGlobalResponse.then((_realResponse) {
      setState(() {
        _ensArticles = _realResponse.item1;
        _filterArticles = _realResponse.item1;

      });
      print("Length articles ${_realResponse.item1.length}");

    });
  }

  @override
  Widget build(BuildContext context) {

      return

      Scaffold(

    appBar:
        AppBar(
              backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: Text('Frais engagés du dossier N° '.tr() + dossier.numero_dossier,
                    style:  customStyleLetterSpace(Colors.white, 14, FontWeight.w700, 0.33)),
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
                    onPressed: (){Navigator.of(context).pop();},
                  )],
    ),
    body:
        CustomScrollView(
              slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                    Form(
                    key: formkey,
                    child:
                    Container(
                      child: Column(

                      children: [
                        _isCreating
                            ?
                      Container(
                     child:
                      Column(
                      children: [
                        Button(icon: FontAwesomeIcons.trash, title: 'ANNULER'.tr(), callback: _cancelDocument, color:Colors.grey, paddingLeft: 5, paddingRight: 5),
                        Button(icon: FontAwesomeIcons.check, title: 'VALIDER'.tr(), callback: _saveFee, color:Colors.green, paddingLeft: 5, paddingRight: 5)
                        ])
                    )

                            :
                        Container(
                            child: Column(
                                children: [
                                  Button(icon: FontAwesomeIcons.plus, title: 'add_a_fee'.tr(), callback: _addDocument, color:Colors.blueGrey,paddingLeft: 5, paddingRight: 5)
                                ]
                            )
                        )
                        ,
                        Container(

                            child:
                            _isUpdating ? _buildLoading() : null
                        ),
                        (_isCreating && _showDossiers)
                            ? Container(
                          margin: EdgeInsets.all(10.0),
                          //  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: SearchableDropdown.single(
                            items: _filterDossiers.map((KeyValueModel value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.Text,
                                  // style: TextStyle(color: Colors.black)
                                ),
                              );
                            }).toList(),
                          //  _filterDossiers,
                            value: selectedDossier,
                            menuBackgroundColor: Colors.white,
                            style: customStyle(Colors.white, 16, FontWeight.normal),
                            hint: Text('select_dossier'.tr(),style: customStyle(Colors.white, 16, FontWeight.normal)),
                            searchHint: 'select_dossier'.tr(),
                            onChanged: (selected) {
                              setState(() {
                                if(selected != null){
                                selectedDossier = selected.Text;
                                feeToAdd.dossier_id = int.parse(selected.Value);

                                widget.dossier.id = int.parse(selected.Value);

                                List<String> names = selected.Text.toString().split('-');

                                widget.dossier.numero_dossier = names.first;

                                _isloading = true;
                                _getFraisDossiers();

                                }else{
                                  selectedDossier = 'select_dossier'.tr();
                                }
                              });
                            },
                            isExpanded: true,
                            searchFn: (String keyword, items) {
                              List<int> ret = List<int>.empty(growable: true);

                              if (keyword != null && items != null && keyword.isNotEmpty) {
                                keyword.split(" ").forEach((k) {
                                  int i = 0;
                                  items.forEach((item) {
                                    if (k.isNotEmpty &&
                                        (item.value.Text
                                            .toString()
                                            .toLowerCase()
                                            .contains(k.toLowerCase()))) {
                                      ret.add(i);
                                    }
                                    i++;
                                  });
                                });
                              }
                              if (keyword.isEmpty) {
                                ret = Iterable<int>.generate(items.length).toList();
                              }
                              return (ret);
                            },
                          ),
                        )
                            : Container(),

                        (_isCreating)
                            ? Container(
                            margin: EdgeInsets.all(10.0),

                            child: SearchableDropdown.single(
                              items: _filterArticles.map((KeyValueModel value) {
                                return DropdownMenuItem(
                                  //value: value.Text,
                                  value: value,
                                  child: Text(
                                    value.Text,
                                    // style: TextStyle(color: Colors.black)
                                  ),
                                );
                              }).toList(),
                              menuBackgroundColor: Colors.white,
                              style: customStyle(Colors.white, 16, FontWeight.normal),
                              /*validator: (value){
                                if(value == null){
                                   return 'mandatory_object'.tr();
                                }
                              },*/

                              value: selectedArticle,
                              hint: Text('select_object'.tr(),style: customStyle(Colors.white, 16, FontWeight.normal)),
                              searchHint: 'select_object'.tr(),
                              onChanged: (selected) {
                                setState(() {

                                  if(selected != null){

                                    selectedArticle = selected.Text;
                                    feeToAdd.Code = selected.Value;
                                    feeToAdd.Description = selected.Text;

                                    if(selected.Value == "MISLIVR"){
                                      _loadDatefields = false;
                                      _loadinterlocuteurField = true;
                                      _istransporter = true;
                                      _hasAmount = false;
                                    }else if (selected.Value == "CHARLOC"){
                                      _loadDatefields = true;
                                      _loadinterlocuteurField = true;
                                      _istransporter = false;
                                      _hasAmount = true;
                                    }else if (selected.Value == "ACC"){
                                      _loadDatefields = true;
                                      _loadinterlocuteurField = false;
                                      _istransporter = false;
                                      _hasAmount = true;
                                    }else{
                                      _loadDatefields = false;
                                      _loadinterlocuteurField = false;
                                      _istransporter = false;
                                      _hasAmount = true;
                                    }
                                  }else{
                                    selectedArticle = 'select_object'.tr();
                                  }

                                });
                              },
                              isExpanded: true,

                              searchFn: (String keyword, items) {
                                List<int> ret = List<int>.empty(growable: true);

                                if (keyword != null && items != null && keyword.isNotEmpty) {
                                  keyword.split(" ").forEach((k) {
                                    int i = 0;
                                    items.forEach((item) {
                                      if (k.isNotEmpty &&
                                          (item.value.Text
                                              .toString()
                                              .toLowerCase()
                                              .contains(k.toLowerCase()))) {
                                        ret.add(i);
                                      }
                                      i++;
                                    });
                                  });
                                }
                                if (keyword.isEmpty) {
                                  ret = Iterable<int>.generate(items.length).toList();
                                }
                                return (ret);
                              },
                            ),

                        )
                            : Container(),

                        (_isCreating && _hasAmount)
                        ?
                        Container(
                          margin: EdgeInsets.all(10.0),
                         // padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                            //maxLength: 20,
                            onChanged: (value) {
                            setState(() {
                                if( value.isNotEmpty && !isNumeric(value)){
                                  feeToAdd.Amount = double.parse(value).abs();
                                }else {
                                  feeToAdd.Amount = 0;
                                }
                            });
                            },
                            decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(right: 20),
                            border: InputBorder.none,
                            hintText: 'Amount'.tr(),
                            hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                            icon: Icon(
                            BanklinIcons.business,
                            color:  selectedColor
                            ),

                            ),
                            style: customStyle(Colors.white, 16, FontWeight.normal),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                            // ignore: deprecated_member_use
                            BlacklistingTextInputFormatter(
                            new RegExp('[\\,|\\-]'),
                            ),
                            ],
                          ),
                        )
                            : Container(),


                        (_isCreating && _loadinterlocuteurField)
                            ? Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    //maxLength:20,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      hintText:  _istransporter ? 'transporteur'.tr()  : 'armateur'.tr(),
                                      hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                                      icon: Icon(
                                          FontAwesomeIcons.textWidth,
                                          color: textColor)
                                      ,
                                      contentPadding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                      border: InputBorder.none,
                                    ),

                                    onChanged: (String value ) => setState(() {
                                      feeToAdd.interlocuteur = value;
                                    }),
                                    style: customStyle(Colors.white, 16, FontWeight.normal),
                                  )
                                ]
                            )
                        )
                            : Container(),


                        (_isCreating && _istransporter)
                            ? Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.done,
                                    maxLength:80,
                                    textCapitalization: TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      hintText: 'numero_eir'.tr(),
                                      hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                                      icon: Icon(
                                          FontAwesomeIcons.textWidth,
                                          color: textColor)
                                      ,
                                      contentPadding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                      border: InputBorder.none,
                                    ),

                                    onChanged: (String value ) => setState(() {
                                      feeToAdd.eir = value;
                                    }),
                                    style: customStyle(Colors.white, 16, FontWeight.normal),
                                  )
                                ]
                            )
                        )
                            : Container(),

                        ( _isCreating && _loadDatefields)
                        ?
                      Container(
                        margin: EdgeInsets.all(10.0),
                        //padding: EdgeInsets.all(20),
                          child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                              _selectEtaDate(context);
                              },
                              child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                              Icon(
                              FontAwesomeIcons.calendarDay,
                              color:  selectedColor
                              ),
                              Text('eta'.tr(), style: customStyle(Colors.white, 16, FontWeight.normal),),
                              Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                              "${DateFormat.yMd().format(_etaDate.toLocal())}",
                              style: customStyle(Colors.white, 16, FontWeight.normal),
                              ),
                              )
                              ],
                              ),
                            ),
                          ],
                        ),
                      )
                         : Container(),

                        ( _isCreating && _loadDatefields)
                            ?
                        Container(
                          margin: EdgeInsets.all(10.0),
                          //padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectEtdDate(context);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                        FontAwesomeIcons.calendarDay,
                                        color:  selectedColor
                                    ),
                                    Text('etd'.tr(), style: customStyle(Colors.white, 16, FontWeight.normal),),
                                    Container(
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      child: Text(
                                        "${DateFormat.yMd().format(_etdDate.toLocal())}",
                                        style: customStyle(Colors.white, 16, FontWeight.normal),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                            : Container(),


                         _isCreating
                            ? Container(
                             margin: EdgeInsets.all(10.0),

                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                //maxLength:20,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'comment'.tr(),
                                  hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                                  icon: Icon(
                                      FontAwesomeIcons.textWidth,
                                      color: textColor)
                                  ,
                                  contentPadding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                  border: InputBorder.none,
                                )/*,
                                 validator: (value){
                                if(value.isEmpty) return 'add_document_number'.tr(); return null;
                              }*/,
                                onChanged: (String value ) => setState(() {
                                  feeToAdd.Comment = value;
                                }),
                                style: customStyle(Colors.white, 16, FontWeight.normal),
                              )
                            ]
                          )
                        )
                            : Container(),

                        SizedBox(height: 20),
                           (response_status != "connexion_failed") ?

                             Container(
                                margin: EdgeInsets.all(0.0),
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _isloading ? _buildLoading() :  _dataBody()
                                  ]
                                )
                              )
                        /*,

                              Expanded(
                              child:
                              _isloading ? _buildLoading() :  _dataBody()
                              )*/
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
                    )
                ])
              )
        ]

    ),

    );
 }

  Widget _dataBody() {
    double _width = MediaQuery.of(context).size.width;
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
                  height: (_filterFraisDossiers.length  == 0 ? 100.0 : 65 + 44.0 * _filterFraisDossiers.length)
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
                    //width: 0.6 * _width,

                        child: Text(
                          'Libellé',
                          style: TextStyle(color: Colors.blue,fontSize: 10.0),
                          textAlign: TextAlign.left,

                        ),

                    )

                  ),
                  DataColumn(label: _verticalDivider),

                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(0.0),
                     // width:  0.25 * _width,
                      child: Center(
                        child: Text(
                          'Montant',
                          style: TextStyle(color: Colors.blue,fontSize: 10.0),
                        ),
                      ),
                    )
                  ),
                  DataColumn(label: _verticalDivider),
                  // Lets add one more column to show a see button and update button
                  DataColumn(
                    label: Container(
                      padding: EdgeInsets.all(0.0),
                     // width: 0.15 * _width,
                      child: Center(
                        child: Text(
                          'Actions',
                          style: TextStyle(color: Colors.blue,fontSize: 10.0),
                        ),
                      ),
                    )
                  )
                ],

                rows: _filterFraisDossiers.length > 0 ? _filterFraisDossiers
                    .map(
                      (frais) => DataRow(cells: [
                    DataCell(
                      Container(
                      //  width: 0.6 * _width,
                        padding: EdgeInsets.all(0.0),
                        child: Text(frais.libelle,
                           // textAlign: TextAlign.left,
                          style: TextStyle(
                          color: Colors.white,
                            fontSize: 10.0
                        ),
                        ),
                        //alignment: Alignment.centerLeft
                      )
                    ),
                    DataCell(_verticalDivider),
                    DataCell(

                      Container(
                        //width: 0.25 * _width,
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          frais.montant,
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 10.0
                            ),
                          maxLines: 3,
                        ),
                      )
                    ),
                    DataCell(_verticalDivider),
                    DataCell(
                        Container(
                         // width: 0.15 * _width,
                          padding: EdgeInsets.all(0.0),
                          //child: Expanded(
                          alignment : Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                               
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red,),
                                    iconSize: 18.0,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(1.0),
                                    onPressed: () {
                                       _DeleteFrais(frais);
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
                       DataCell(
                         Container(
                           width: _width,
                           height: 50,
                           padding: EdgeInsets.all(0.0),
                           child: Text("Aucun frais.",
                             textAlign: TextAlign.center,
                             style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 10.0
                             ),
                           ),
                           alignment: Alignment.center
                       ),
                       ),
                       DataCell(SizedBox.shrink()),
                       DataCell(SizedBox.shrink()),
                     ])
                    ]
              ),
            ),
          )
          // ,
           //;
       ),
     //;
    );
  }

  void _addDocument() async {
    setState(() {
      _isCreating = true;
    });
    _resetState();
  }

  void _saveFee() async {

    if(formkey.currentState.validate()){

      formkey.currentState.validate();

      feeToAdd.Date = DateFormat.yMd().format(DateTime.now().toLocal());

         print("Frais  : ");

         print('user id : ' + feeToAdd.current_user_id.toString());
         print('Code : ' + feeToAdd.Code);
         print('Description : ' + feeToAdd.Description);
         print('Date : ' + feeToAdd.Date);
        // print('Comment : ' + feeToAdd.Comment);
         print('Amount : ' + feeToAdd.Amount.toString());
         print('interlocuteur : ' + feeToAdd.interlocuteur.toString());
         print('etd : ' + feeToAdd.etd);
         print('eta : ' + feeToAdd.eta);
         print('agent : ' + feeToAdd.agent.toString());
         print('dossier_id : ' + feeToAdd.dossier_id.toString());

      setState(() {
        _isUpdating = true;
      });

     // Future<Tuple2<String, String>>
     var globalResponse = ApiProvider.SaveFee(feeToAdd)
      //;

      //globalResponse
          .then((_realResponse) {
       print('frais enregistrés');
       setState(() {
         _isUpdating = false;
         _isCreating = false;
         _isloading = true;
         _getFraisDossiers();
       });
       showAlert(context, "Enregistrement des frais",_realResponse.item1);
      });
    }

  }

  void _DeleteFrais(GetFees fee) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ask_delete_fee'.tr()+ " :  ${fee.libelle}?"),
          content:Text('warnig_delete_fee'.tr()),
          actions: <Widget>[
            TextButton(
              child:  Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('delete_btn'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                deleteDocument(fee);
              },
            )
          ],
        );
      },
    );

  }

  void deleteDocument(GetFees fee){

    int r_user_id = int.parse(userid);

    //Future<Tuple2<String, String>>
    var globalResponse =  ApiProvider.DeleteFee(fee.id, r_user_id)
    //;

    //globalResponse
        .then((_realResponse) {
      print('frais supprimés');
      setState(() {
        _isloading = true;
        _isCreating = false;
        _getFraisDossiers();
      });

      showAlert(context, "Suppression des frais",_realResponse.item1);

    });

  }

  void _cancelDocument() async {
    setState(() {
      _isCreating = false;
    });
  }

  Widget _verticalDivider = const VerticalDivider(
    color: Colors.blue,
    thickness: 1,
  );

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
       // allowedExtensions: ['pdf','docx', 'PDF', 'DOCX','png', 'jpeg','PNG', 'JPEG']
        allowedExtensions: ['pdf', 'PDF']
       /* (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,*/
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
      _paths != null ? _paths.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      String path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      //_isLoading = true;
      _isLoading = false;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  bool isNumeric( String s) {

    if( s.isEmpty) return false;

    final n = num.tryParse(s);

    return ( n == null );
  }

  Widget _buildLoading() =>Center(

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(size: 50, color: Theme.of(context).accentColor)
        ],
      )
  );

}
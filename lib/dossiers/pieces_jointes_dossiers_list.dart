import 'dart:async';
import 'package:ball_on_a_budget_planner/dossiers/see_dossier.dart';
import 'package:ball_on_a_budget_planner/dossiers/see_piece_jointe_dossier.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/models/get_documents_non_rattaches_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';
import 'package:ball_on_a_budget_planner/models/key_value.dart';
import 'package:ball_on_a_budget_planner/models/save_documents_model.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/labels.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:ball_on_a_budget_planner/models/datatable.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


import '../banklin_icons.dart';

class PieceJointeDossiersPage extends StatefulWidget {

  final GetDossier dossier;
  final  bool showDossiers ;

  const PieceJointeDossiersPage({Key key, this.dossier,this.showDossiers = false}) : super(key: key);

  @override
  _PieceJointeDossierPageState createState() => _PieceJointeDossierPageState(
      this.dossier

  );
}


class _PieceJointeDossierPageState extends State<PieceJointeDossiersPage> {

  _PieceJointeDossierPageState(
      this.dossier
      );
  bool _showDossiers;

  bool _isUpdating;
  bool _isCreating;
  String _titleProgress;
  bool _isloading;
  String response_status ;
  String response_status_docs ;

  final formkey = GlobalKey<FormState>();
  String selectDocMessage;

  GetDossier dossier = new GetDossier();

  SaveDocumentsModel docsModel = new SaveDocumentsModel();

  List<PieceJointeDossier> _piecesJointesDossiers;

  List<DocumentDossier> _documentsDossiers;

  //DocumentDossier selectedDocument;
  String selectedDocument;

  String selectedDossier;
  List<KeyValueModel> _ensDossiers;
  List<KeyValueModel> _filterDossiers;

  List<DocumentDossier> _filterDocumentsDossiers;

  // this list will hold the filtered dossiers
  List<PieceJointeDossier> _filterPiecesJointesDossiers;

  PieceJointeDossier _selectedPieceJointeDossier;

  Color textColor = Color.fromRGBO(8, 185, 198, 1);

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


    docsModel.dossier_id = dossier.id;

    _piecesJointesDossiers = [];
    _documentsDossiers = [];
    _filterDocumentsDossiers = [];
    _filterPiecesJointesDossiers = [];
    _isUpdating = false;
    _isCreating = false;
    _isloading = true;
    response_status = "ongoing";
    response_status_docs = "ongoing";
    selectDocMessage = "aucun".tr();

    _ensDossiers = [];
    _filterDossiers = [];

    _showDossiers = widget.showDossiers;

    _controller.addListener(() => _extension = _controller.text);
    _getPiecesJointes();

    _getDocumentsNonRattaches();

    _getEnsDossiers();


  }

  void setUserid()async{
    userid = await storage.read(key: 'userId');
    if(userid != null){
      docsModel.current_user_id = int.parse(userid);
    }
    print(userid);
    setState(() {

    });
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getPiecesJointes() {
    _showProgress('Chargement des dossiers...');

    Future<Tuple2<List<PieceJointeDossier>, String>> dossiersGlobalResponse =  ApiProvider.GetAllPiecesJointesDossier(dossier.id);
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _piecesJointesDossiers = _realResponse.item1;

        // Initialize to the list from Server when reloading...
        _filterPiecesJointesDossiers = _realResponse.item1;

        print("Pièces jointes : ");
        print(_filterPiecesJointesDossiers);
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
        _isUpdating = false;

      });

      print("Length ${_realResponse.item1.length}");

    });
  }

  _getDocumentsNonRattaches() {
    _showProgress('Chargement des dossiers...');

    Future<Tuple2<List<DocumentDossier>, String>> dossiersGlobalResponse =  ApiProvider.GetAllDocumentsNonRattachesDossier(dossier.id);
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _documentsDossiers = _realResponse.item1;

        // Initialize to the list from Server when reloading...
        _filterDocumentsDossiers = _realResponse.item1;

        print("Documents non rattachés : ");
        print(_filterDocumentsDossiers);
        print("Message:  ");
        print(_realResponse.item2);


        if(_realResponse.item2 == "Success"){

          response_status_docs = "success";

        }else if(_realResponse.item2 == "Error"){

          response_status_docs = "error";

        }else {
          response_status_docs = "connexion_failed";
        }


      });

      print("Length docs non rattachés ${_realResponse.item1.length}");

    });
  }

  _getEnsDossiers() {
    _showProgress('Chargement des dossiers...');
    Future<Tuple2<List<KeyValueModel>, String>> dossiersGlobalResponse =  ApiProvider.GetAllDossiersKV();
    dossiersGlobalResponse.then((_realResponse) {
      setState(() {
        _ensDossiers = _realResponse.item1;
        _filterDossiers = _realResponse.item1;

        print("Ensemble dossiers : ");
        print(_filterDossiers);
        print("Message:  ");
        print(_realResponse.item2);

        if(_realResponse.item2 == "Success"){

          response_status_docs = "success";

        }else if(_realResponse.item2 == "Error"){

          response_status_docs = "error";

        }else {
          response_status_docs = "connexion_failed";
        }

      });

      print("Length dossiers ${_realResponse.item1.length}");

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
                title: Text('Documents du dossier N° '.tr() + dossier.numero_dossier,
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
                        Button(icon: FontAwesomeIcons.check, title: 'VALIDER'.tr(), callback: _validDocument, color:Colors.green, paddingLeft: 5, paddingRight: 5)
                        ])
                    )

                            :
                        Container(
                            child: Column(
                                children: [
                                  Button(icon: FontAwesomeIcons.plus, title: 'add_a_doc'.tr(), callback: _addDocument, color:Colors.blueGrey,paddingLeft: 5, paddingRight: 5)
                                ]
                            )
                        ),

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
                                        docsModel.dossier_id = int.parse(selected.Value);

                                        widget.dossier.id = int.parse(selected.Value);

                                        List<String> names = selected.Text.toString().split('-');

                                        widget.dossier.numero_dossier = names.first;

                                        _isloading = true;

                                        _getPiecesJointes();

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

                        _isCreating
                            ? Container(
                          //padding: EdgeInsets.only(left: 20, right: 20, top: 5,),
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                                children: [
                                  SearchableDropdown.single(
                                    items: _filterDocumentsDossiers.map((DocumentDossier value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.nom_abrege,
                                          // style: TextStyle(color: Colors.black)
                                        ),
                                      );
                                    }).toList(),
                                    //  _filterDossiers,
                                    value: selectedDocument,
                                    menuBackgroundColor: Colors.white,
                                    style: customStyle(Colors.white, 16, FontWeight.normal),
                                    hint: Text('select_doc_type'.tr(),style: customStyle(Colors.white, 16, FontWeight.normal)),
                                    searchHint: 'select_doc_type'.tr(),
                                    onChanged: (selected) {
                                      setState(() {
                                        if(selected != null){
                                          selectedDocument = selected.nom_abrege;
                                          docsModel.document_id = selected.id;
                                        }else{
                                          selectedDocument = 'select_doc_type'.tr();
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
                                                (item.value.nom_abrege
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

                                ]
                            )
                        )
                            : Container(),
                        //SizedBox(height: 20),
                         _isCreating
                            ? Container(
                             margin: EdgeInsets.all(10.0),
                          //padding: EdgeInsets.only(left: 20, right: 20, top: 5,),
                          child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              maxLength:20,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: 'numero_document'.tr(),
                                hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                                icon: Icon(
                                    FontAwesomeIcons.textWidth,
                                    color: textColor)
                                ,
                                contentPadding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                border: InputBorder.none,
                              ),
                               validator: (value){
                              if(value.isEmpty) return 'add_document_number'.tr(); return null;
                            },
                              onChanged: (String value ) => setState(() {

                                docsModel.numero_document = value;
                              }),
                              style: customStyle(Colors.white, 16, FontWeight.normal),
                            )
                          ]
                          )
                        )
                            : Container(),
                       // SizedBox(height: 10),
                         _isCreating ?
                        Container(
                          margin: EdgeInsets.all(10.0),
                          //padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                          child: Column(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => _pickFiles(),
                                child: Text(_multiPick ? 'Sélectionner le(s) fichier(s) : pdf' : 'Selectionner le document (pdf) '),
                              ),

                              SizedBox(height: 20),
                            /*  Text("Document sélectionné : ", style:  TextStyle(color: Colors.blue),),

                              (_paths == null) ?
                              Text(selectDocMessage, style: TextStyle(color: Colors.red))
                              :
                              Text(_fileName, style: TextStyle(color: Colors.green)),

                              SizedBox(height: 30),*/

                            ],
                          ) ,
                        )
                            : Container(),

                        _isCreating ?
                        _viewFile()
                       : Container()
                        ,
                           (response_status != "connexion_failed") ?
                              Container(
                                margin: EdgeInsets.all(10.0),
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

  // Let's create a DataTable and show the employee list in it.
  //SingleChildScrollView _dataBody() {
  Widget _dataBody() {
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
                  height: (_filterPiecesJointesDossiers.length  == 0 ? 100.0 : 65 + 44.0 * _filterPiecesJointesDossiers.length)
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
                   // width: 60,

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
                     // width: 130,
                      child: Center(
                        child: Text(
                          'Document',
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
                    //  width: 30,
                      child: Center(
                        child: Text(
                          'Actions',
                          style: TextStyle(color: Colors.blue)
                        ),
                      ),
                    )
                  )
                ],
                // the list should show the filtered list now
                rows: _filterPiecesJointesDossiers.length > 0 ? _filterPiecesJointesDossiers
                    .map(
                      (piecejointedossier) => DataRow(cells: [

                    DataCell(
                      Container(
                     //   width: 60,
                        padding: EdgeInsets.all(0.0),
                        child: Text(piecejointedossier.numero_document,
                           // textAlign: TextAlign.left,
                          style: TextStyle(
                          color: Colors.white,
                            fontSize: 10.0
                        ),
                        ),
                        //alignment: Alignment.centerLeft
                      ),
                      onTap: () {
                        _seePieceJointe(piecejointedossier);
                        // Set the Selected employee to Update
                        _selectedPieceJointeDossier = piecejointedossier;
                        // Set flag updating to true to indicate in Update Mode
                       /* setState(() {
                          _isUpdating = true;
                        });*/
                      },
                    ),
                    DataCell(_verticalDivider),
                    DataCell(

                      Container(
                    //    width: 130,
                        padding: EdgeInsets.all(0.0),
                        child: Text(
                          piecejointedossier.nom_abrege,
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 10.0
                            ),
                          maxLines: 3,
                        ),
                      ),
                      onTap: () {

                        _seePieceJointe(piecejointedossier);
                        // Set the Selected employee to Update
                        _selectedPieceJointeDossier = piecejointedossier;
                        // Set flag updating to true to indicate in Update Mode
                       /* setState(() {
                          _isUpdating = true;
                        });*/
                      },
                    ),
                    DataCell(_verticalDivider),
                    DataCell(
                        Container(
                    //      width: 30,

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
                                       _DeletePieceJointe(piecejointedossier);
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
                        //   width: 130,
                           width: MediaQuery.of(context).size.width,
                             height: 50,
                           padding: EdgeInsets.all(0.0),
                           child: Text("Aucun document.",
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

  Widget _viewFile(){

    return
      Builder(
        builder: (BuildContext context) =>
      _isLoading
          ? Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: const CircularProgressIndicator(),
      )
          : _userAborted
          ? Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: const Text(
          //'User has aborted the dialog',
          '',
          style: TextStyle(color: Colors.white),
        ),
      )
          : _directoryPath != null
          ? ListTile(
        title: const Text('Directory path'),
        subtitle: Text(_directoryPath),
      )
          : _paths != null
          ? Container(
        padding:
        const EdgeInsets.only(bottom: 30.0),
        height:
        MediaQuery.of(context).size.height *
            0.50,
        child: Scrollbar(
            child: ListView.separated(
              itemCount: _paths != null &&
                  _paths.isNotEmpty
                  ? _paths.length
                  : 1,
              itemBuilder: (BuildContext context,
                  int index) {
                final bool isMultiPath =
                    _paths != null &&
                        _paths.isNotEmpty;
                int realIndex = index + 1;
                final String name =
                    'Fichier $realIndex: ' +
                    //'Document : ' +
                        (isMultiPath
                            ? _paths
                            .map((e) => e.name)
                            .toList()[index]
                            : _fileName ?? '...');
                final path = kIsWeb
                    ? null
                    : _paths
                    .map((e) => e.path)
                    .toList()[index]
                    .toString();

                return ListTile(
                  title: Text(
                    //'',
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                  /*subtitle: Text(path ?? '',
                      style: TextStyle(color: Colors.green),),*/
                );
              },
              separatorBuilder:
                  (BuildContext context,
                  int index) =>
              const Divider(),
            )),
      )
          : _saveAsFileName != null
          ? ListTile(
        title: const Text('Sauvegarder le document'),
        subtitle: Text(_saveAsFileName),
      )

         : const SizedBox()
      );

  }

  void _addDocument() async {
    setState(() {
      _isCreating = true;
    });
   // _resetState();
  }

  void _seePieceJointe(PieceJointeDossier piece_jointe){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SeePieceJointePage(pieceJointe: piece_jointe)));
  }
  void _validDocument() async {

    if(formkey.currentState.validate()){
      formkey.currentState.validate();
      if( _paths != null ){
          _saveDocument();
      }else{
        openDialog(context, '', 'select_file'.tr());
      }
    }

  }

  void _saveDocument(){

    List multipartArray = [];
    //var file = fileA;
    for (var i = 0; i < _paths.length; i++) {
      multipartArray.add(MultipartFile.fromFileSync(_paths[i].path, filename:
      _paths[i].name));
      }
    print("multipartArrayContent :");
    print(multipartArray);

    docsModel.files = multipartArray;

    setState(() {
      _isUpdating = true;
    });

    //Future<Tuple2<String, String>>
    var globalResponse =

    ApiProvider.SaveDocuments(docsModel)
    //;

    //globalResponse
        .then((_realResponse) {

      setState(() {
        _isUpdating = false;
        _isCreating = false;
        _isloading = true;
        _getPiecesJointes();
      });

      showAlert(context, "Enregistrement des documents",_realResponse.item1);

    });

    }

  void _DeletePieceJointe(PieceJointeDossier piece_jointe) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ask_delete_doc'.tr()+ " :  ${piece_jointe.file_name}?"),
          content:Text('warnig_delete_doc'.tr()),
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
                deleteDocument(piece_jointe);
                Navigator.of(context).pop();
                //Navigator.of(context).pop();
                setState(() {
                   _isloading = true;
                });
              },
            )
          ],
        );
      },
    );
  }

  void deleteDocument(PieceJointeDossier document){

          int rUserId = int.parse(userid);
          var globalResponse =  ApiProvider.DeleteDocument(document.id, rUserId)
              .then((_realResponse) {
            print('documents supprimés');
            setState(() {
              _isloading = true;
              _isUpdating = false;
              _isCreating = false;
              _getPiecesJointes();
            });
            showAlert(context, "Suppression des documents",_realResponse.item1);
          });
    }

  void _cancelDocument() async {
    setState(() {
      _isCreating = false;
    });
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
      //_isCreating = false;
      _isLoading = false;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }


}

import 'dart:convert';
import 'dart:io';


import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:ball_on_a_budget_planner/dossiers/pieces_jointes_dossiers_list.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/models/budget.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/get_pieces_jointes_dossier.dart';
import 'package:ball_on_a_budget_planner/models/income.dart';
import 'package:ball_on_a_budget_planner/resources/api_provider.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/budgets_card.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
//import 'package:universal_html/html.dart';

class SeeReleve extends StatefulWidget {

  final String path;
  final String title;
  final File file;

  const SeeReleve({Key key, this.path, this.title, this.file}) : super(key: key);

  @override
  _SeeRelevePageState createState() => _SeeRelevePageState(
     this.path,
     this.title,
    this.file
  );
}

class _SeeRelevePageState extends State<SeeReleve> {

  _SeeRelevePageState(
    this._path,
    this._title,
      this._file
  );

  bool _isLoading = true;
  PDFDocument document;
  File currentFile;

  String _path;
  String _title;
  File _file;

   @override
  void initState() {
    super.initState();
     _path = widget.path;
     _title = widget.title;
    _file = widget.file;
    loadDocument();
  }

  loadDocument() async {

    //s var g_file =  File(_path);
    document = await PDFDocument.fromFile(_file);
  //  document = await PDFDocument.fromFile(g_file);
    setState(
            () => _isLoading = false
    );

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
       // title: Text('piece_jointe'.tr() + pieceJointe.nom_abrege,
        title: Text(_title,
        style:  customStyleLetterSpace(Colors.white, 14, FontWeight.w700, 0.33)),
        centerTitle: true,
         actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
            onPressed: (){Navigator.of(context).pop();},
        )],
      ),
      body: Center(
                child: _isLoading
                ? Center(
                    child: CircularProgressIndicator()
                )
                    : PDFViewer(
                        document: document,
                        zoomSteps: 1,
                          //uncomment below line to preload all pages
                        lazyLoad: false,
                          // uncomment below line to scroll vertically
                        scrollDirection: Axis.vertical,
                  
                )
      )

      );
  }

}

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

class SeePieceJointePage extends StatefulWidget {

  final PieceJointeDossier pieceJointe;

  const SeePieceJointePage({Key key, this.pieceJointe}) : super(key: key);

  @override
  _SeePieceJointeDossierPageState createState() => _SeePieceJointeDossierPageState(
     this.pieceJointe
  );
}

class _SeePieceJointeDossierPageState extends State<SeePieceJointePage> {

  _SeePieceJointeDossierPageState(
    this.pieceJointe
  );

  bool _isLoading = true;
  PDFDocument document;
  File currentFile;

  PieceJointeDossier pieceJointe = new PieceJointeDossier();
  PieceJointeDossier downloadPJ;

   @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {

    Future<Tuple2<List<PieceJointeDossier>, String>> dossiersGlobalResponse =  ApiProvider.GetDocument(pieceJointe.id);
    dossiersGlobalResponse.then((_realResponse) async {

        List<PieceJointeDossier>  _currentdoc = _realResponse.item1;

        if(_realResponse.item2 == "Success"){

          final fDoc = _currentdoc.first;
          downloadPJ = fDoc;
          String fileName = pieceJointe.file_name;
          var bytes = base64Decode(fDoc.file_base6.replaceAll('\n', ''));
          final output = await getTemporaryDirectory();
          final file = File("${output.path}/$fileName.pdf");
          await file.writeAsBytes(bytes.buffer.asUint8List());
          currentFile = file;

          document = await PDFDocument.fromFile(file);
          setState(
                  () => _isLoading = false
          );

        }else if(_realResponse.item2 == "Error"){

          setState(
                  () => _isLoading = false
          );

          showAlert(context, "Echec du chargement.","Temps d'attente dépassé.");

        }else {
          setState(
                  () => _isLoading = false
          );
          showAlert(context, "Problème de connexion.","Vérifiez votre connexion internet.");

        }

    });

  }
  downloadDocument() async {

    String fileName = downloadPJ.file_name;
    var bytes = base64Decode(downloadPJ.file_base6.replaceAll('\n', ''));
    //final output = await getDownloadsDirectory();
    //final output = await getApplicationDocumentsDirectory();
    //final file = File("${output.path}/$fileName.pdf");

    //Directory root = await getTemporaryDirectory();
   // String directoryPath = root.path + '/Documents/CTI/Documents_Dossier_Numero_'+downloadPJ.dossier_id.toString()+ "/"+fileName;
    String directoryPath = '/storage/emulated/0/Download/' + 'CTI/Documents_Dossier_Numero_'+downloadPJ.dossier_id.toString()+ "/"+fileName;
    final file =  new File(directoryPath).create(recursive: true)
    .then((File file) async {
        await file.writeAsBytes(bytes);
    });

     //await file.writeAsBytes(bytes);
    print('path :' + directoryPath );

    showAlert(context, pieceJointe.nom_abrege, "Document téléchargé avec succès.");

  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
       // title: Text('piece_jointe'.tr() + pieceJointe.nom_abrege,
        title: Text('' + pieceJointe.nom_abrege,
        style:  customStyleLetterSpace(Colors.white, 14, FontWeight.w700, 0.33)),
        centerTitle: true,
         actions: <Widget>[
           IconButton(
             icon: Icon(Icons.file_download),
             onPressed: () {
               downloadDocument();
               //currentFile.writeAsBytes(bytes);
             },
           ),
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
                   /* navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                          },
                        ),

                      ],
                    );
                  },*/

                )
      )

      );
  }


 /* void createFileRecursively(String filename) {
    // Create a new directory, recursively creating non-existent directories.
    new Directory.fromPath(new Path(filename).directoryPath)
        .createSync(recursive: true);
    new File(filename).createSync();
  }*/
}
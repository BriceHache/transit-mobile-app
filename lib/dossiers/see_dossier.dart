import 'dart:io';
import 'dart:typed_data';

import 'package:ball_on_a_budget_planner/clients/see_files_in_directory.dart';
import 'package:ball_on_a_budget_planner/dossiers/pieces_jointes_dossiers_list.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/models/budget.dart';
import 'package:ball_on_a_budget_planner/models/dossier_detail.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/income.dart';
import 'package:ball_on_a_budget_planner/models/key_value.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/budgets_card.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:ball_on_a_budget_planner/widgets/button_width_flexible_dimensions.dart';
import 'package:ball_on_a_budget_planner/widgets/nice_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw ;

import 'frais_dossiers_list.dart';

class SeeDossierPage extends StatefulWidget {

  final GetDossier dossier;

  const SeeDossierPage({Key key, this.dossier}) : super(key: key);

  @override
  _SeeDossierPageState createState() => _SeeDossierPageState(
     this.dossier

  );
}

class _SeeDossierPageState extends State<SeeDossierPage> {

  _SeeDossierPageState(
    this.dossier
  );

  //bool  _isUpdate = false;
  final formkey = GlobalKey<FormState>();

  GetDossier dossier = new GetDossier();
  Color editColor = Color(0xff07A82D);
  Color desactiveColor = Colors.grey;
  Color seeDossierColor = Colors.black;
  Color pieceJointeColor = Colors.deepPurpleAccent;
  //Color(0xff07A82D);
  Color fraisDeDossierColor = Colors.blueGrey;
  bool _isloadingDoc;
  String downloadPath;
  List<KeyValueModel> _dossierDetails;

  String userid;
  final storage = new FlutterSecureStorage();
  

   @override
  void initState() {
    super.initState();
    _isloadingDoc = false;
  }

  void setUserid()async{
     userid = await storage.read(key: 'userId');
   print(userid);
   setState(() {
     
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('details_dossier_number'.tr() + dossier.numero_dossier,
        style:  customStyleLetterSpace(Colors.white, 18, FontWeight.w700, 0.33)),
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
            icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
            onPressed: (){Navigator.of(context).pop();},
        )],
      ),
      body: CustomScrollView(
         slivers: <Widget>[
           SliverList(
              delegate: SliverChildListDelegate([
                 Form(
                   key: formkey,
                   child: Column(
                     children: [
                       Container(
                           child:
                           _isloadingDoc ? _buildLoading() :  null
                       ),
                      _dossierCard(),

                    // Button(icon: FontAwesomeIcons.eye, title: 'voir_dossier'.tr(), callback: _edit, color:desactiveColor),
                    // Button(icon: FontAwesomeIcons.pen, title: 'edit_dossier'.tr(), callback: _edit, color:editColor),
                     Button(icon: FontAwesomeIcons.file, title: 'piece_jointe_dossier'.tr(), callback: _pieces_jointes, color:pieceJointeColor),
                     Button(icon: FontAwesomeIcons.dollarSign, title: 'frais_sur_dossier'.tr(), callback: _frais_dossiers, color:fraisDeDossierColor),
                     ],
                   ),
                 )
              ])
           )
         ]

      ),
    );
  }

  Widget _dossierCard(){
    double width = MediaQuery.of(context).size.width * 0.60;
    print(dossier.id);
    return Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      child : Column(
        children: <Widget>[
              SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    children: [

                      NiceText(
                          (dossier.date_booking_string == null && dossier.date_booking_string != "")  ? "RAS" :
                          dossier.date_booking_string,
                          'DATE DE RECEPTION : ',
                          Colors.green, type: "date")

                    ],

                  )
                ]
            ),
          ),
              SingleChildScrollView(
      scrollDirection: Axis.horizontal,
              child: Row(
              mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      children: [

                        NiceText(
                            dossier.numero_dossier,
                            'N° DOSSIER : ',
                            Colors.green, type: "date")

                      ],

                    )
                  ]
              ),
      ),
              SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:  Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Column(
                  children: [
                    (dossier.ClientName.isNotEmpty && dossier.ClientName.length < 25) ?
                    NiceText(dossier.ClientName, 'CLIENT : ', Colors.green, type: "date") :
                    NiceText(dossier.ClientName, 'CLIENT : ', Colors.green, type: "date", goToLine: true,)

                  ],

                )

              ]
          ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                mainAxisSize: MainAxisSize.max,

                children: <Widget>[

                 Column(
                      children: [
                          Container(
                            child:
                    (dossier.TransitFileobject.isNotEmpty && dossier.TransitFileobject.length < 7) ?
                            NiceText(dossier.TransitFileobject.trim(), 'NATURE DE LA MARCHANDISE : ', Colors.green, type: "date")
                     :   NiceText(dossier.TransitFileobject.trim(), 'NATURE DE LA MARCHANDISE : ', Colors.green, type: "date", goToLine: true)

                            ,)
                      ],

                    ),


                ]
          ),
              ),
              SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child : Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  children: [

                    NiceText(
                        (dossier.numero_repertoire == null && dossier.numero_repertoire != "")  ? "RAS" :
                        dossier.numero_repertoire,
                        'N° DE REPERTOIRE : ',
                        Colors.green, type: "date")
                  ],

                )

              ]
          ),
             ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.numeroBLS == null && dossier.numeroBLS != "")  ? "RAS" :
                              dossier.numeroBLS,
                              'N° BL/LTA : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.numeroDeclaration == null && dossier.numeroDeclaration != "")  ? "RAS" :
                              dossier.numeroDeclaration,
                              'N° DECLARATION : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.montant_facture == null && dossier.montant_facture != "")  ? "RAS" :
                              dossier.montant_facture,
                              'MONTANT FACTURE : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          (dossier.ensemble_numeros_containers.isNotEmpty && dossier.ensemble_numeros_containers.length < 25) ?
                          NiceText((dossier.ensemble_numeros_containers == null && dossier.ensemble_numeros_containers != "")  ? "AUCUN CONTENEUR" : dossier.ensemble_numeros_containers, 'N° CONTENEURS : ', Colors.green, type: "date") :
                          NiceText((dossier.ensemble_numeros_containers == null && dossier.ensemble_numeros_containers != "")  ? "AUCUN CONTENEUR" : dossier.ensemble_numeros_containers, 'N° CONTENEURS : ', Colors.green, type: "date",goToLine: true)
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.Recap_nbreColis == null && dossier.Recap_nbreColis != "")  ? "RAS" :
                              dossier.Recap_nbreColis,
                              'NOMBRE DE COLIS : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.Recap_poids == null && dossier.Recap_poids != "")  ? "RAS" :
                              dossier.Recap_poids,
                              'POIDS : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.frais_dossiers == null && dossier.frais_dossiers != "")  ? "0" :
                              dossier.frais_dossiers,
                              'TOTAL FRAIS : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              (dossier.date_mise_en_livraison == null && dossier.date_mise_en_livraison != "")  ? "RAS" :
                              dossier.date_mise_en_livraison,
                              'DATE LIVRAISON : ',
                              Colors.green, type: "date")
                        ],

                      )

                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child : Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Column(
                        children: [

                          NiceText(
                              dossier.StatusName.toUpperCase(),
                              'STATUT : ',
                              Color(int.parse(dossier.couleur_label.replaceAll('#', '0xff'))), type: "date")
                        ],

                      )

                    ]
                ),
              )

        ],
      ),
    );
  }

   void _edit() async {
     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditDossierPage(GetDossier: dossier)));
  }

  void _pieces_jointes() async {
     Navigator.push(context, MaterialPageRoute(builder: (context) => PieceJointeDossiersPage(dossier: dossier)));
  }

  void _frais_dossiers() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FraisDossiersPage(dossier: dossier)));
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

  void generateReport() async {
    setState(() {
      _isloadingDoc = true;
    });

    var releve = generateDetailDossier();

    try {

      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      String doc_name = "Dossier N° "+ dossier.numero_dossier + "-" + dossier.ClientName
          + ' Au ' +
          DateFormat('dd_MM_yyyy').format(DateTime.now()).toString();
      final output = '/storage/emulated/0/Download/CTI/Dossiers';
      String path = output +"/" + doc_name;

      var file = new File(path).create(recursive: true)
          .then((value) async =>
      {
        await value.writeAsBytes(await releve),

      }
      );
      setState(
              () => downloadPath = output
      );

      showDialog(
        builder: (context) =>  AlertDialog(
          title: Text( 'Situation du dossier N° ' + dossier.numero_dossier ),
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

      //   Navigator.push(context, MaterialPageRoute(builder: (context) => SeeInternalDocument(path: path, title: 'releve_de_compte'.tr() + '-' + dossier.tiDescription)));

      print(output);
      print(doc_name);

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
    Navigator.push(context, MaterialPageRoute(builder: (context) => SeeDirectoryFiles(targetDirectory: downloadPath, title: 'Dossier N° ' + dossier.numero_dossier + ' - ' + dossier.ClientName)));
  }

  Future<Uint8List> generateDetailDossier() async {
    final lorem = pw.LoremText();
    PdfPageFormat pageFormat = PdfPageFormat.a4;

    _dossierDetails = List<KeyValueModel>.empty(growable: true);

    _dossierDetails
        .add(new KeyValueModel(
        Text: 'DATE DE RECEPTION : ',
       Value :
       (dossier.date_booking_string == null && dossier.date_booking_string != "")  ? "RAS" :
        dossier.date_booking_string)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° DOSSIER : ',
        Value :
        dossier.numero_dossier)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° DOSSIER : ',
        Value :
        dossier.numero_dossier)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'NATURE DE LA MARCHANDISE : ',
        Value :
        dossier.TransitFileobject.trim())
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° DE REPERTOIRE : ',
        Value :
        (dossier.numero_repertoire == null && dossier.numero_repertoire != "")  ? "RAS" :
        dossier.numero_repertoire)
    );

    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° BL/LTA : ',
        Value :
        (dossier.numeroBLS == null && dossier.numeroBLS != "")  ? "RAS" :
        dossier.numeroBLS)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° DECLARATION : ',
        Value :
        (dossier.numeroDeclaration == null && dossier.numeroDeclaration != "")  ? "RAS" :
        dossier.numeroDeclaration)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'MONTANT FACTURE : ',
        Value :
        (dossier.montant_facture == null && dossier.montant_facture != "")  ? "RAS" :
        dossier.montant_facture)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'N° CONTENEURS : ',
        Value :
        (dossier.ensemble_numeros_containers == null && dossier.ensemble_numeros_containers != "")  ? "AUCUN CONTENEUR" : dossier.ensemble_numeros_containers
      )
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'NOMBRE DE COLIS : ',
        Value :
        (dossier.Recap_nbreColis == null && dossier.Recap_nbreColis != "")  ? "RAS" :
        dossier.Recap_nbreColis)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'POIDS : ',
        Value :
        (dossier.Recap_poids == null && dossier.Recap_poids != "")  ? "RAS" :
        dossier.Recap_poids)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'TOTAL FRAIS : ',
        Value :
        (dossier.frais_dossiers == null && dossier.frais_dossiers != "")  ? "0" :
        dossier.frais_dossiers)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'DATE DE LIVRAISON : ',
        Value :
        (dossier.date_mise_en_livraison == null && dossier.date_mise_en_livraison != "")  ? "RAS" :
        dossier.date_mise_en_livraison)
    );
    _dossierDetails
        .add(new KeyValueModel(
        Text: 'STATUT : ',
        Value :
        dossier.StatusName.toUpperCase()
        )
    );


    final detail_dossier = DossierDetail(
        details: _dossierDetails,
        customerName: dossier.ClientName,
        numeroDossier: dossier.numero_dossier,
        periode : DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
        baseColor: PdfColors.teal,
        accentColor: PdfColors.blueGrey900
    );

    return await detail_dossier.buildPdf(pageFormat);
  }



}
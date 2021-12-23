
import 'package:ball_on_a_budget_planner/dossiers/pieces_jointes_dossiers_list.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/models/budget.dart';
import 'package:ball_on_a_budget_planner/models/get_dossier.dart';
import 'package:ball_on_a_budget_planner/models/income.dart';
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

  String userid;
  final storage = new FlutterSecureStorage();
  

   @override
  void initState() {
    super.initState();

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

     /* child: Card(
        color: Colors.black,
        shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        'N° DOSSIER : ',
                        style: customStyle(
                            //Colors.grey[100]
                            Colors.blue
                            , 13, FontWeight.normal)
                      ),
                    ),
                    //SizedBox(width: 10,),
                      Text(
                        dossier.numero_dossier,
                        style: customStyle(Colors.grey[100], 13, FontWeight.normal)
                      
                    ),
                  ],
                ),
                
              ),
              SizedBox(height: 15,),

            ],
          ),
        ),
      ),*/

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


}
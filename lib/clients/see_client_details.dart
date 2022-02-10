
import 'package:ball_on_a_budget_planner/clients/releve_de_compte.dart';
import 'package:ball_on_a_budget_planner/helpers/common_range_date.dart';
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/models/budget.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
import 'package:ball_on_a_budget_planner/models/get_client.dart';
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
import 'package:tuple/tuple.dart';


class SeeClientPage extends StatefulWidget {

  final GetClient client;

  const SeeClientPage({Key key, this.client}) : super(key: key);

  @override
  _SeeClientPageState createState() => _SeeClientPageState(
     this.client

  );
}

class _SeeClientPageState extends State<SeeClientPage> {

  _SeeClientPageState(
    this.client
  );

  //bool  _isUpdate = false;
  final formkey = GlobalKey<FormState>();

  GetClient client = new GetClient();
  Color editColor = Color(0xff07A82D);
  Color desactiveColor = Colors.grey;
  Color seeClientColor = Colors.black;
  Color pieceJointeColor = Colors.deepPurpleAccent;
  //Color(0xff07A82D);
  Color fraisDeClientColor = Colors.blueGrey;

  DateTime _startDate;
  DateTime _endDate;
  List<Tuple2<String,Tuple2<DateTime, DateTime>>> rangeDates;

  String userid;
  final storage = new FlutterSecureStorage();


   @override
  void initState() {
    super.initState();

    rangeDates = PredefinedRangeDatesWithKeys();

    _startDate =  rangeDates[3].item2.item1 ;
    _endDate = rangeDates[3].item2.item2 ;

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
        title: Text('' + client.tiDescription,
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

                      _clientCard(),

                     Button(icon: FontAwesomeIcons.list, title: 'releve_de_compte'.tr(), callback: _releve_de_compte, color:fraisDeClientColor),
                     ],
                   ),
                 )
              ])
           )
         ]

      ),
    );
  }

  Widget _clientCard(){

    return Container (
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
                            client.solde,
                            'Encours : ',
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
                          client.chiffre_affaires_ht,
                          'Factures et redevances (HT) : ',
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
                          client.paiements,
                          'Paiements : ',
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
                        (client.tiTelephone != null) ?
                        NiceText(client.tiTelephone, 'Télephone : ', Colors.green, type: "date")
                       : NiceText('Non renseigné', 'Télephone : ', Colors.green, type: "date")
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
                      (client.tiEmail != null) ?
                      NiceText(client.tiEmail, 'Email : ', Colors.green, type: "date")
                    :  NiceText('Non renseigné', 'Email : ', Colors.green, type: "date")
                    ],
                  )
                ]
            ),
          ),

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
                        client.numero_client,
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
     // Navigator.push(context, MaterialPageRoute(builder: (context) => EditClientPage(GetClient: client)));
  }

  void _releve_de_compte() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ReleveDeComptePage(_startDate,_endDate,client)));
  }


}
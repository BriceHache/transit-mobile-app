import 'package:ball_on_a_budget_planner/models/img.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/budgets_card.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


import '../../models/budget.dart';


class BudgetsPage extends StatefulWidget {
  BudgetsPage({Key key}) : super(key: key);

  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  List<Budget> budgets;
  Stream<QuerySnapshot> _query;
  final storage = new FlutterSecureStorage();
  String userid;

  @override
  void initState() {
    super.initState();
    setUserid();
  }

  void setUserid()async{
     userid = await storage.read(key: 'userId');
   print(userid);
   setState(() {
     
   });
  }


  @override
  Widget build(BuildContext context) {

    
   _query = FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .collection('budgets')
            .orderBy('dateUpdate', descending: true)
            .snapshots();
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 700,
              child: StreamBuilder<QuerySnapshot>(
                stream: _query ,
                builder: (_, AsyncSnapshot<QuerySnapshot> data){
                  if (data.connectionState == ConnectionState.active) {
                    if (data.data.docs.length > 0  ){
                      budgets = data.data.docs.map((doc) => Budget.fromMap(doc.data())).toList();
                      return ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder:(_, int index){
                         
                          return Container( 
                            //padding: EdgeInsets.only(left: 18, right: 18, top: 10),
                            child: Hero(tag: budgets[index].timestamp, 
                            child: InkWell(
                              onTap: () =>  Navigator.pushNamed(context, 'budgetOpt',  arguments: budgets[index]),
                              child: budgets[index].monthlyBudget ? BudgetCard(budget: budgets[index], selectedColor: Color( int.parse(budgets[index].color),) , context: context, oCcy: oCcy) :
                              BudgetTempCard(budget: budgets[index], selectedColor:  Color( int.parse(budgets[index].color),), context: context, oCcy: oCcy, startDate: budgets[index].startDate, endDate: budgets[index].endDate)
                              
                            )
                            ),
                          );
                        }
                      );
                    }
                    return Center(
                        child: Column(
                          children: <Widget>[
                          SizedBox(height: 10,),
                          Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                              elevation: 3.0,
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(Img.get('no_data2.png')),
                                ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30,),
                            Text(
                                'add_budget'.tr(),
                                style: TextStyle( color: Theme.of(context).accentColor, letterSpacing: 1.5, fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    );
                  }
                  return Center( child: SpinKitFadingCircle(
                          size: 50,
                          color: Theme.of(context).accentColor,
                        ), );
                },
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}


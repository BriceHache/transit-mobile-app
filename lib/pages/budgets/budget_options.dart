

import 'package:ball_on_a_budget_planner/models/expense.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/budgets_card.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/budget.dart';
import '../../models/income.dart';

class BudgetOptPage extends StatefulWidget {
  const BudgetOptPage({Key key}) : super(key: key);

  @override
  _BudgetOptPageState createState() => _BudgetOptPageState();
}

class _BudgetOptPageState extends State<BudgetOptPage> {
  final formkey = GlobalKey<FormState>();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Budget budget = new Budget();
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);

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
    final Budget budgetEdit  = ModalRoute.of(context).settings.arguments;
    budget = budgetEdit;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        
        title: Text(budget.name, 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: "montserrat-Regular", fontSize: 22.0, letterSpacing: 0.338,) ),
        centerTitle: true,
      ),
      body: Column(
        children: [
           budget.monthlyBudget ? BudgetCard(budget: budget, selectedColor: Color( int.parse(budget.color),) , context: context, oCcy: oCcy) :
              BudgetTempCard(budget: budget, selectedColor:  Color( int.parse(budget.color),), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate),
          
        Button(icon: FontAwesomeIcons.solidEdit, title: 'edit_btn'.tr(), callback: (){
            if( budget.monthlyBudget ){
                                 Navigator.pushNamed(context, 'mBudget',  arguments: budget);
                               }else{
                                  Navigator.pushNamed(context, 'tBudget',  arguments: budget);
                               }
          }, color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))),
        Button(icon: FontAwesomeIcons.trash, title: 'delete'.tr(), callback: _delete, color: budget.color == null ? selectedColor : Color( int.parse(budget.color))),
  

        ],
      ),
    );
  }



  void _delete() async {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ask_delete'.tr()+ " ${budget.name}?"),
          content:Text('warnig_delete'.tr()),
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
                  deleteExpenses();
                deleteIncomes();
                FirebaseFirestore.instance
                              .collection('users')
                              .doc(userid)
                              .collection('budgets')
                              .doc(budget.timestamp)
                              .delete();
                
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void deleteExpenses() async{
    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('users/$userid/expenses').where('budgetTimestamp', isEqualTo: budget.timestamp).get();
    List<Expense> expenses = snap.docs.map((data) => Expense.fromMap(data.data())).toList();
    print('se eliminaran ${expenses.length} gastos');

    for (var i = 0; i < expenses.length; i++) {
       FirebaseFirestore.instance
                              .collection('users')
                              .doc(userid)
                              .collection('expenses')
                              .doc(expenses[i].timestamp)
                              .delete(); 
    }

  }

  void deleteIncomes() async{
    final QuerySnapshot snap = await FirebaseFirestore.instance.collection('users/$userid/incomes').where('budgetTimestamp', isEqualTo: budget.timestamp).get();
    List<Income> incomes = snap.docs.map((data) => Income.fromMap(data.data())).toList();
   

     for (var i = 0; i < incomes.length; i++) {
       FirebaseFirestore.instance
                              .collection('users')
                              .doc(userid)
                              .collection('incomes')
                              .doc(incomes[i].timestamp)
                              .delete(); 
    }
    
  }
}
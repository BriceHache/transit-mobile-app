
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/models/budget.dart';
import 'package:ball_on_a_budget_planner/models/income.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/budgets_card.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditIncomePage extends StatefulWidget {

  final Budget budget;
  final Income income;

  const EditIncomePage({Key key, this.budget, this.income}) : super(key: key);

  @override
  _EditIncomePageState createState() => _EditIncomePageState(
     this.budget,
     this.income
  );
}

class _EditIncomePageState extends State<EditIncomePage> {

  _EditIncomePageState(
    this.budget,
    this.income
  );

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();

  Income income = new Income();
  bool  _saving = true;
  double newIncomeValue = 0;
  Stream<QuerySnapshot> _query;
  Budget budget = new Budget();
  Color colorIncome = Color(0xff07A82D);
  double currentIncome;

  String userid;
  final storage = new FlutterSecureStorage();
  

   @override
  void initState() {
    super.initState();

    currentIncome = income.income;
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
        title: Text('income_edit'.tr(), 
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
                      InkWell(
                        onTap: (){},
                        child:  budget.monthlyBudget ?  BudgetCard(budget: budget, selectedColor: Color(int.parse(budget.color)), context: context, oCcy: oCcy) : 
                      BudgetTempCard(budget: budget, selectedColor: Color(int.parse(budget.color)), context: context, oCcy: oCcy, startDate: budget.startDate, endDate: budget.endDate),
                      ),
                      _incomeCard(),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                            initialValue: income.income.toString(),
                                  maxLength: 7,
                                  onChanged: (value) {
                                    setState(() {
                                        if( value.isNotEmpty && !isNumeric(value)){
                                        income.income = double.parse(value).abs();
                                        
                                      }else {
                                          income.income = 0;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: 20),
                                    border: InputBorder.none,
                                    hintText: 'enter_income'.tr(),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                      color: Color( int.parse(budget.color))
                                    ),
                                    
                                  ),
                                  style: customStyle(Colors.white, 16, FontWeight.normal),
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.black,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    // ignore: deprecated_member_use
                                    BlacklistingTextInputFormatter(
                                      new RegExp('[\\,|\\-]'),
                                    ),
                                  ],
                          ),
                        ),
                        Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          initialValue: income.notes,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          maxLength:35,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'notes'.tr(),
                            hintStyle: customStyle(Colors.grey[400], 12, FontWeight.normal),
                            icon: Icon(
                              FontAwesomeIcons.edit,
                              color: Color( int.parse(budget.color))
                            ),
                            
                            contentPadding: EdgeInsets.only(left: 5, right: 5),
                            border: InputBorder.none,
                            ),
                            validator: (value){
                              if(value.isEmpty) return 'some_notes'.tr(); return null;
                            },
                            onChanged: (String value ) => setState(() {
                              income.notes = value;
                            }),
                            style: customStyle(Colors.white, 16, FontWeight.normal),
                          ),
                      ),
                       _saving ? Button(icon: FontAwesomeIcons.save, title: 'update'.tr(), callback: _submit, color:Color(int.parse(budget.color))):  Center(
                          child: SpinKitFadingCircle(
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                      ),
                      _saving ? Button(icon: FontAwesomeIcons.trash, title: 'delete'.tr(), callback: _deleteIncome, color:Color(int.parse(budget.color))):  Center(
                          child: SpinKitFadingCircle(
                            size: 50,
                            color: Theme.of(context).accentColor,
                          ),
                      ),
                     ],
                   ),
                 )
              ])
           )
         ]

      ),
    );
  }

  Widget _incomeCard(){
    double width = MediaQuery.of(context).size.width * 0.60;
    return Container(
      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
      child: Card(
        color: Colors.black,
        shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
        elevation: 10.0,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        income.dateCreate,
                        style: customStyle(Colors.grey[100], 13, FontWeight.normal)
                      ),
                    ),
                    SizedBox(width: 10,),
                      Text(
                        '\$${oCcy.format(income.lastValue)} + \$${oCcy.format(income.income)}, \$${oCcy.format( income.lastValue + income.income)}',
                        style: customStyle(Colors.grey[100], 13, FontWeight.normal)
                      
                    ),
                  ],
                ),
                
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Container(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                          color: colorIncome
                        ),
                        height: 45,
                        width: 45,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Image(
                            image: AssetImage("icons/ic_money.png"),
                            color: Colors.black,
                          ),
                        ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  'income'.tr(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: customStyle(Colors.white, 16, FontWeight.normal),
                                ),
                              ),
                            ),
                            Text(
                              '+ \$${oCcy.format(income.income)}',
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color( int.parse(budget.color)),
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                             
                          ],
                        ),
                        
                       
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.edit, color: Colors.white),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  income.notes == null ? 'notes'.tr() : income.notes,
                                  style: customStyle(Colors.grey[200], 14, FontWeight.normal)
                                ),
                              ),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),

    );
  }

   void _submit() async {
     setState(() { _saving = false; });
    if(currentIncome != income.income){
      
      if(income.income > 0){
        await updateIncome().then((_) {
          updateBudgetIncomes();
          openDialog(context, '', 'income_updated'.tr());
        }
        );
      }
    }else{
      await updateIncome();
    } 
  }

  Future updateIncome() async {

    String budgetTimestamp = budget.timestamp;

    await FirebaseFirestore.instance.collection('users').doc(userid).collection('incomes').doc(income.timestamp).update({
       
        'income'          : income.income,
        'notes'           : income.notes,
        'lastValue'       : income.lastValue,
        'budgetTimestamp' : budgetTimestamp,
        'budgetName'      : budget.name,
    });
    Navigator.of(context).pop();
  }

  Future updateBudgetIncomes() async {
    budget.incomes = budget.incomes -currentIncome + income.income;
    budget.balance = budget.incomes - budget.expenses;
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
   
    await FirebaseFirestore.instance.collection('users').doc(userid).collection('budgets').doc(budget.timestamp).update({
       
        'incomes'       : budget.incomes,
        'dateUpdate'   : _timestamp,
        'balance'      : budget.balance,
        
    });
  }

  void _deleteIncome()async{
    setState(() { _saving = false; });
    budget.incomes = budget.incomes - currentIncome;
    budget.balance = budget.balance -currentIncome;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: Text('delete_income'.tr() +"\$${income.income.toString()}?" ),
          
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() { _saving = true; });
              },
            ),
            TextButton(
              child: Text('delete'.tr()),
              onPressed: deleteIncome
            )
          ],
        );
      },
    );


  }

  Future deleteIncome()async{
    updateBudgetIncomes();
    await FirebaseFirestore.instance.collection('users').doc(userid).collection('incomes').doc(income.timestamp).delete();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
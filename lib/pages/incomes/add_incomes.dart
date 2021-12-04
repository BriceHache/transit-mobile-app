
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
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();

  Income income = new Income();
  bool  _saving = true;
  String startDate = '', endDate = '', date, timestamp, dateCreate, dateUpdate, notes;
  double incomeValue = 0;
  double budgetCurrentIncomes = 0;
  Stream<QuerySnapshot> _query;
  Budget budget = new Budget();
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);
  Color colorIncome = Color(0xff07A82D);
  int day, month, year;
  String tabMonth;
    String userid;
  final storage = new FlutterSecureStorage();

   @override
  void initState() {
    super.initState();
    setUserid();
     if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => onWidgetBuild());
    }

    budget.monthlyBudget = true;
    budget.incomes = 0;
     DateTime now = DateTime.now();
    date = DateFormat.yMMMd().format(now.toLocal());
  }

  void setUserid()async{
     userid = await storage.read(key: 'userId');
   print(userid);
   setState(() {
     
   });
  }

 /*  void setCurrentBudget()async{
     budgetSelected = await storage.read(key: 'currentBudget');
   print(budgetSelected);
   setState(() {
     
   });
  } */

   Future getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat.yMMMd().format(now.toLocal());
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    
    setState(() {
      date = _date;
      timestamp = _timestamp;
      dateCreate = date;
      dateUpdate = _timestamp;
      day = now.day;
      tabMonth = '${now.month.toString()}${now.year.toString()}';
      
    });
  }

  void onWidgetBuild() {
    _showBudgets();
  }


   void _showBudgets(){
    income.budgetTimestamp = null;
    setState(() {});
    
     List<Budget> budgets;

    showModalBottomSheet(
      context: (context),
      builder: (context){
        return Container(
          height: 500,
          color: Theme.of(context).accentColor,
          child: Column(
           
            children: [
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2),
                  child: Column(
                    
                    children: <Widget>[
                      Text(
                        'choose_budget'.tr(),
                        style: customStyle(Colors.white, 16, FontWeight.bold),
                      ),
                      Divider(),
                      SizedBox(
                        height: 335,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _query = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userid)
                        .collection('budgets')
                        .orderBy('dateUpdate', descending: true)
                        .snapshots() ,
                          builder: (_, AsyncSnapshot<QuerySnapshot> data){
                            if (data.connectionState == ConnectionState.active) {
                              if (data.data.docs.length > 0  ){
                                budgets = data.data.docs.map((data) => Budget.fromMap(data.data())).toList();
                                return ListView.builder(
                                  itemCount: budgets.length,
                                  itemBuilder: (_, int index){
                                    return Container(
                                      child: Hero(tag: budgets[index].timestamp, 
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            budget = budgets[index];
                                            Navigator.pop(context);
                                          });                             
                                        },
                                        child: budgets[index].monthlyBudget ? BudgetCard(budget: budgets[index], selectedColor: Color( int.parse(budgets[index].color),) , context: context, oCcy: oCcy) :
                                        BudgetTempCard(budget: budgets[index], selectedColor:  Color( int.parse(budgets[index].color),), context: context, oCcy: oCcy, startDate: budgets[index].startDate, endDate: budgets[index].endDate)
                                        
                                      )
                                      ),
                                    );
                                  }
                                );
                              }
                              return Center(
                                child: Text(
                                'add_budget'.tr(),
                                style: TextStyle( color: Theme.of(context).accentColor, letterSpacing: 1.5, fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                              );
                            }return Center( child: SpinKitFadingCircle(
                              size: 50,
                              color: Theme.of(context).accentColor,
                            ), );
                          }

                        ),
                      ),

                    ],
                  ),
                ),
            ],
          ),
        );
      }
      );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        title: Text('new_income'.tr(), 
        style:  customStyleLetterSpace(Colors.white, 18, FontWeight.w700, 0.33),),
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
                        onTap: _showBudgets,
                        child:  budget.monthlyBudget ?  BudgetCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy) : 
                      BudgetTempCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy, startDate: startDate, endDate: endDate),
                      ),
                      _incomeCard(),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                                  maxLength: 7,
                                  onChanged: (value) {
                                    setState(() {
                                        if( value.isNotEmpty && !isNumeric(value)){
                                        incomeValue = double.parse(value).abs();
                                        
                                      }else {
                                        incomeValue = 0;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: 20),
                                    border: InputBorder.none,
                                    hintText: 'enter_income'.tr(),
                                    hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                                    icon: Icon(
                                      FontAwesomeIcons.moneyBill,
                                      color: budget.color == null ? selectedColor : Color( int.parse(budget.color))
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
                            
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            maxLength:35,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'notes'.tr(),
                              hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                              icon: Icon(
                                FontAwesomeIcons.edit,
                                color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))
                              ),
                              
                              contentPadding: EdgeInsets.only(left: 5, right: 5),
                              border: InputBorder.none,
                              ),
                              
                              onChanged: (String value ) => setState(() {
                                notes = value;
                              }),
                              style: customStyle(Colors.white, 16, FontWeight.normal),
                            ),
                          ),
                       _saving ? Button(icon: FontAwesomeIcons.save, title: 'submit'.tr(), callback: _submit, color:budget.color == null ? selectedColor : Color(int.parse(budget.color))):  Center(
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
                        date,
                        style: customStyle(Colors.grey[400], 12, FontWeight.normal)
                      ),
                    ),
                    SizedBox(width: 10,),
                      Text(
                        '\$${oCcy.format(budget.incomes)} + \$${oCcy.format(incomeValue)}, \$${oCcy.format(budgetCurrentIncomes = budget.incomes + incomeValue)}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      
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
                              '+ \$${oCcy.format(incomeValue)}',
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: budget.color == null ? selectedColor : Color( int.parse(budget.color)),
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
                        notes == null ? Container(padding: EdgeInsets.only( right: 5, top: 5, bottom: 5),height: 30, child: Text('income_note'.tr(),style: TextStyle(color: Colors.grey[600], fontSize: 14),),):Container(
                          padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.edit,  color: Colors.white),
                              Container(
                                width: width,
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  notes == null ? 'notes'.tr() : notes,
                                  style: customStyle(Colors.grey[600], 14, FontWeight.normal)
                                  
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
    if(formkey.currentState.validate()){
      formkey.currentState.validate();
      if( incomeValue > 0){
        await getDate().then((value) => uploadIncome().then((_) {
          updateBudgetFound();
          openDialog(context, '', 'income_saved'.tr());
          
        }));
      }else{
        openDialog(context, '', 'income_value_valid'.tr());
      }
    } 
  }

  Future uploadIncome() async {
    setState(() { _saving = false; });
    double lastValue = budget.incomes;
    String budgetTimestamp = budget.timestamp;
    if(notes == null){notes = 'note';}

    await FirebaseFirestore.instance.collection('users').doc(userid).collection('incomes').doc(timestamp).set({
       
        'timestamp'       : timestamp,
        'income'          : incomeValue,
        'notes'           : notes,
        'lastValue'       : lastValue,
        'dateCreate'      : dateCreate,
        'day'             : day,
        'tabMonth'        : tabMonth,
        'budgetTimestamp' : budgetTimestamp,
        'budgetName'      : budget.name,
        
    });
    Navigator.of(context).pop();
  }

  Future updateBudgetFound() async {
    double newIncomeValue = budget.incomes + incomeValue ;
    double balance = newIncomeValue - budget.expenses;
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
   
    if(budget.months.isEmpty){
      budget.months.add(tabMonth);
      
    }else{
      budget.months.forEach((e) { 
        if(!budget.months.contains(tabMonth)){
          budget.months.add(tabMonth);
           FirebaseFirestore.instance.collection('users').doc(userid).collection('budgets').doc(budget.timestamp).update({
       
        'incomes'       : newIncomeValue,
        'dateUpdate'   : _timestamp,
        'months'       : budget.months,
        'balance'      : balance,
        
        });
        }
      });
      
    }

    await FirebaseFirestore.instance.collection('users').doc(userid).collection('budgets').doc(budget.timestamp).update({
       
        'incomes'       : newIncomeValue,
        'dateUpdate'   : _timestamp,
        'months'       : budget.months,
        'balance'      : balance,
        
    });
  }
}
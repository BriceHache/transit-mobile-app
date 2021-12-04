
import 'package:ball_on_a_budget_planner/helpers/dialog.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/helpers/utils.dart';
import 'package:ball_on_a_budget_planner/widgets/budget_temp_card.dart';
import 'package:ball_on_a_budget_planner/widgets/button_widget.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/budget.dart';

class AddTempBudgetPage extends StatefulWidget {
  AddTempBudgetPage({Key key}) : super(key: key);

  @override
  _AddTempBudgetPageState createState() => _AddTempBudgetPageState();
}
class _AddTempBudgetPageState extends State<AddTempBudgetPage> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Budget budget = new Budget();

  String name, color, typeBudget, timestamp, date, dateCreate, dateUpdate, startDate = '', endDate = '';
  double initIncome = 0, balance = 0, expenses = 0, planIncome= 0; 
  bool monthlyBudget, _saving = true;
  int selectedColorIndex = 0, monthBudget;
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  Color selectedColor = Color.fromRGBO(8, 185, 198, 1);
  String userid;
  final storage = new FlutterSecureStorage();

  Future getDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat.yMMMd().format(now.toLocal());
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      date = _date;
      timestamp = _timestamp;
      dateCreate = date;
      dateUpdate = _timestamp;
    });

  }

  @override
  void initState() {
    super.initState();
    color = selectedColor.value.toString();
    monthBudget = 1;
    monthlyBudget = false;
    typeBudget = 'temp';
     startDate = DateFormat.yMMMd().format(_selectedStartDate.toLocal());
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
    if(budgetEdit != null){ budget = budgetEdit; }
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        
        automaticallyImplyLeading: false,
        title: Text('temp_budget'.tr(), 
        style: customStyleLetterSpace(Colors.white, 18, FontWeight.w700, 0.338)),
        centerTitle: true,
         actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.times, color: Theme.of(context).accentColor,),
            onPressed: (){ Navigator.of(context).pop(); },
        )],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                key: formkey,
                child: Column(
                children: <Widget>[
                  BudgetTempCard(budget: budget, selectedColor: selectedColor, context: context, oCcy: oCcy, startDate: startDate, endDate: endDate),
                  colorsListWidget(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      initialValue: budget.name == null ? '' : budget.name,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'budget_name'.tr(),
                        hintStyle: customStyle(Colors.grey[400], 16, FontWeight.normal),
                        icon: Icon(
                          Icons.edit,
                          color: budget.color == null ? selectedColor : Color( int.parse(budget.color))
                        ),
                        
                        contentPadding: EdgeInsets.only(left: 5, right: 5),
                        border: InputBorder.none,
                        ),
                        validator: (value){
                          if(value.isEmpty) return 'empty_value'.tr(); return null;
                        },
                        onChanged: (String value ) => setState(() {
                           name = value;
                           budget.name = name;
                        }),
                        style: customStyle(Colors.white, 16, FontWeight.normal)
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                            maxLength: 7,
                            initialValue: budget.initialIncome == null ? '': budget.initialIncome.toString(),
                            onChanged: (value) {
                              setState(() {
                                  if( value.isNotEmpty && !isNumeric(value)){
                                  initIncome = double.parse(value).abs();
                                  budget.initialIncome = initIncome;
                                }else {
                                  initIncome = 0;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: 20),
                              border: InputBorder.none,
                              hintText: 'hint_initial_income'.tr(),
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectStarDate(context);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: budget.color == null ? selectedColor : Color( int.parse(budget.color))
                                ),
                                Text('start_date'.tr(), style: customStyle(Colors.white, 16, FontWeight.normal),),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(

                                    budget.startDate == null
                                        ? "${DateFormat.yMMMd().format(_selectedStartDate.toLocal())}"
                                        : budget.startDate,
                                    style: customStyle(Colors.white, 16, FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _selectEndDate(context);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.date_range,
                                  color: budget.color == null ? selectedColor : Color( int.parse(budget.color))
                                ),
                                Text('end_date'.tr(), style: customStyle(Colors.white, 16, FontWeight.normal)),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: Text(
                                   
                                    budget.endDate == null
                                        ? "${DateFormat.yMMMd().format(_selectedEndDate.toLocal())}"
                                        : budget.endDate,
                                      style: customStyle(Colors.white, 16, FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
                  _saving ? Button( title: 'submit'.tr(), callback: _submit, color:  budget.color == null ? selectedColor : Color( int.parse(budget.color))) :  Center(
                      child: SpinKitFadingCircle(
                        size: 50,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                ],
              ))
            ])
          )
        ]
      )
    );
  }

  Widget colorsListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: EdgeInsets.only(left: 14, right: 10),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              selectedColor = colorsList[index];
              selectedColorIndex = index;
              setState(() {
                color = selectedColor.value.toString();
                budget.color = color;
               
              });
            },
            child: colorWidget(index, colorsList[index]),
          );
        },
        itemCount: colorsList.length,
      ),
    );
  }

  Widget colorWidget(int index, Color color) {
    if (index == selectedColorIndex) {
      return Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              color: colorsList[index],
            ),
            Container(
              height: 40,
              width: 40,
              color: Colors.black12,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.done,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(5),
        height: 40,
        width: 40,
        color: colorsList[index],
      );
    }
  }

  Future<Null> _selectStarDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _selectedStartDate == null ? DateTime.now() : _selectedStartDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2022));
      if (picked != null && picked != _selectedStartDate) {
        setState(() {
          _selectedStartDate = picked;
         startDate = DateFormat.yMMMd().format(_selectedStartDate.toLocal());
         
          
        });
      }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: _selectedEndDate == null ? DateTime.now() : _selectedEndDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2022));
      if (picked != null && picked != _selectedEndDate) {
        setState(() {
          _selectedEndDate = picked;
          endDate =  DateFormat.yMMMd().format(_selectedEndDate.toLocal());
         
        });
      }
  }


  void _submit() async {

     if(formkey.currentState.validate()){
      formkey.currentState.validate();

      setState(() { _saving = false; });

      if( budget.timestamp == null){
         if( name != null ){
        await getDate().then((value) => uploadTempBudget().then((_) {
          
          openDialog(context, '', 'saved_budget_successfully'.tr());
          
        }));
         
      }else{
        openDialog(context, '', 'valid_name'.tr());
      }
      }else{
        await updateTempBudget().then((_) async{
           await _saveCurrentBudget(budget.timestamp);
           
          openDialog(context, 'updated'.tr(), '');
          
        });
      }
     }
  }

  Future _saveCurrentBudget( String currentBudget ) async {

    // Write value 
    await storage.write(key: 'currentBudget', value: currentBudget);
    return;

  }

  Future uploadTempBudget() async {
   
    endDate = DateFormat.yMMMd().format(_selectedEndDate.toLocal());
    
    await FirebaseFirestore.instance.collection('users').doc(userid).collection('budgets').doc(timestamp).set({
       
        'timestamp'    : timestamp,
        'name'         : name,
        'color'        : color,
        'incomes'      : initIncome,
        'initialIncome': initIncome,
        'planIncome'   : planIncome,
        'expenses'     : expenses,
        'balance'      : initIncome,
        'dateCreate'   : dateCreate,
        'dateUpdate'   : dateUpdate,
        'typeBudget'   : typeBudget,
        'startDate'    : startDate,
        'monthlyBudget': monthlyBudget,
        'endDate'      : endDate,
        'monthBudget'  : monthBudget,
        'months'       : [],
        'monthsExp'    : []
    });
     await _saveCurrentBudget(timestamp);
    Navigator.of(context).pop();
  }

  Future updateTempBudget() async {
   
     DateTime now = DateTime.now();
    String _update = DateFormat('yyyyMMddHHmmss').format(now);
    budget.dateUpdate =  _update;
    await FirebaseFirestore.instance.collection('users').doc(userid).collection('budgets').doc(budget.timestamp).update({
       
        'timestamp'    : budget.timestamp,
        'name'         : budget.name,
        'color'        : budget.color,
        'initialFound' : budget.initialIncome,
        'expenses'     : budget.expenses,
        'planIncome'   : budget.planIncome,
        'balance'      : budget.balance,
        'dateCreate'   : budget.dateCreate,
        'dateUpdate'   : budget.dateUpdate,
        'typeBudget'   : budget.typeBudget,
        'startDate'    : budget.startDate,
        'monthlyBudget': budget.monthlyBudget,
        'endDate'      : budget.endDate,
        'monthBudget'  : budget.monthBudget,
        'months'       : budget.months
    });
     await _saveCurrentBudget(budget.timestamp);
    
    Navigator.of(context).pop();
  }
}


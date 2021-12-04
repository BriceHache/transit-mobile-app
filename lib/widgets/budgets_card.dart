import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/widgets/profile_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/budget.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    Key key,
    @required this.budget,
    @required this.selectedColor,
    @required this.context,
    @required this.oCcy,
   
  }) : super(key: key);

  final Budget budget;
  final Color selectedColor;
  final BuildContext context;
  final NumberFormat oCcy;

  
  @override
  Widget build(BuildContext context) {
    Color color = budget.color == null ? selectedColor : Color( int.parse(budget.color));
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.20,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 13, right: 13, top: 5),
        child: Card(
          color: color,
          shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
          elevation: 10.0,
          child: Stack(
            children: [
            Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text( 
                      budget.name == null ? 'budget_name'.tr(): budget.name, 
                      style: customStyle(Colors.white, 18, FontWeight.w700), 
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[ 
                          ProfileTile( textColor: Colors.white, title: 'incomes'.tr(), subtitle:  " \$${oCcy.format(budget.incomes == null ? 0 : budget.incomes)}"), 
                       
                          ProfileTile( textColor: Colors.white,title: 'expense'.tr(), subtitle: " \$${oCcy.format(budget.expenses == null ? 0 : budget.expenses)}"),
                         
                          ProfileTile( textColor: Colors.white,title: 'balance'.tr(), subtitle: " \$${oCcy.format(budget.balance == null ? 0 : budget.balance)}"),
                        ]
                    ),
                    SizedBox(height: 18,),
                     Row(
                       children: [
                         Text( 'monthly_budget'.tr(),
                            style: customStyle(Colors.white, 13, FontWeight.bold,)
                            
                          ),
                         
                       ],
                     ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
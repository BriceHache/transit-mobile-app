import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/widgets/profile_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/budget.dart';

class RecapSoldeCard extends StatelessWidget {
  final String total_credit;
  final String total_debit;
  final String solde;
  final Color selectedColor;
  final BuildContext context;
  final NumberFormat oCcy;
  final String startDate;
  final String endDate;

   RecapSoldeCard({
     this.total_credit,
     this.total_debit,
     this.solde,
     this.selectedColor,
     this.context,
     this.oCcy,
     this.startDate,
     this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    Color color =  selectedColor == null ? Color.fromRGBO(8, 185, 198, 1) : selectedColor;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.20,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Card(
          color: color,
          shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),),
          elevation: 10.0,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40, right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[ 
                          ProfileTile( textColor: Colors.white, title: 'incomes'.tr(), subtitle:  "\$${oCcy.format(total_credit == null ? 0 : total_credit)}"),
                          
                          ProfileTile( textColor: Colors.white,title: 'expense'.tr(), subtitle: "\$${oCcy.format(total_debit == null ? 0 : total_debit)}"),
                         
                          ProfileTile( textColor: Colors.white,title: 'balance'.tr(), subtitle: "\$${oCcy.format(solde == null ? 0 : solde)}"),
                        ]
                    ),
                    SizedBox(height: 15,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: <Widget>[ 
                          SizedBox(),
                          ProfileTile( textColor: Colors.white, title: 'start_date'.tr(), subtitle: startDate == null ? '' : startDate),
                          SizedBox( width: 40.0,),
                          ProfileTile( textColor: Colors.white,title: 'end_date'.tr(), subtitle: endDate == null ? '' : endDate),
                          SizedBox(),
                        ]
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
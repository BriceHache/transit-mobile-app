import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

import '../banklin_icons.dart';

class NiceText extends StatelessWidget {
  final String amount;
  final String title;
  final Color colorMoney;
  final String type;
  final IconData icon;
  final bool goToLine;
  final double textStyle;

  NiceText(this.amount, this.title, this.colorMoney, {this.type = "number", this.icon = BanklinIcons.wallet, this.goToLine = false, this.textStyle = 14});

  String _getStats(String value, {type = "number", devise = "FCFA"}){

    if(type == "number" || type == "date"){
      return value;
    }else{
      return value + " " + devise;
    }
  }

  @override
  Widget build(BuildContext context) {

    return
           Container(
            margin: EdgeInsets.only(right: 5.0),

          child: Card(
           // margin: EdgeInsets.only( right: 2.0),

            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),),
             elevation: 10.0,
              child: Container(

                padding: EdgeInsets.all(10),
                child: Column(

                  children:
                  [

                    Center(
                      child: Row(
                        children: [
                          Column(
                            children: [

                              if(type == "number" || type == "amount")
                                Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only( bottom: 5.0),
                                        child: Icon(icon)
                                    )
                                  ],

                                ),

                              Row(

                                children: [
                                  Container(

                                    padding: EdgeInsets.all(1),
                                    child: Text(title, style: customStyle(
                                        Colors.white, textStyle, FontWeight.normal)
                                    ),
                                  ),
                                  if(!goToLine)
                                  Center(
                                    child: Text(
                                        _getStats(amount, type: type),
                                        // "  \$${oCcy.format(amount)}",
                                        style: customStyle(colorMoney, textStyle, FontWeight.bold)


                                    ),
                                  )
                                ],
                              ),
                              if(goToLine)
                                Row(
                                  children: [
                                     Text(
                                          _getStats(amount, type: type),
                                          textAlign: TextAlign.left,
                                          style: customStyle(colorMoney, textStyle, FontWeight.bold)
                                      ),

                                  ],

                                ),
                            ],
                          )
                        ],
                      ),
                    ),

                  ],
                ),

              ),

          ),

        );

  }
}

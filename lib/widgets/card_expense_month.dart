


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../banklin_icons.dart';


class CardExpenseMonth extends StatefulWidget {
  final List<Map> cardExpnses;

  const CardExpenseMonth({@required this.cardExpnses});

  @override
  _CardExpenseMonthState createState() => _CardExpenseMonthState();
}

class _CardExpenseMonthState extends State<CardExpenseMonth> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        String bank = widget.cardExpnses[index]['bank'];
        double expend = widget.cardExpnses[index]['expend'];
        return Container(
          padding: EdgeInsets.only(left: 12, right: 20,  bottom: 10),
          child: Row(
            children: <Widget>[
              Icon(BanklinIcons.pay, color: Colors.white,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Expanded(
                        child: Text(
                          bank,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                             ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
               'amount'.tr()+ "  \$${oCcy.format(expend)}",
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  
                ),
              )
            ],
          ),
        );
      },
      itemCount: widget.cardExpnses.length,
    );
  }
}

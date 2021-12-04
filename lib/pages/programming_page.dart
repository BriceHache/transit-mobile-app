import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class ProgrammingPage extends StatelessWidget {
  const ProgrammingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Card(
            clipBehavior: Clip.antiAlias,
          shape:RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          elevation: 3.0,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Image.asset('assets/images/code.png'),
              SizedBox(height: 10),
              Text(
                'Programming...',
                style: customStyle(Colors.black87, 18, FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],
        ),
          ),
    );
  }
}
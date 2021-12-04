import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  
  final String title;
  final Function onTap;
  final double fontSize;
  final double height;

  const LargeButton({
    Key key, 
    @required this.title, 
    @required this.onTap, 
    this.fontSize = 16,
    this.height = 55
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        //height: 55,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Center(
          child: Text(
            this.title,
            style: customStyle(Colors.white, fontSize, FontWeight.bold),
          ),
        ),
      ),
    );
  }

  
}

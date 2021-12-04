import 'dart:io';

import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';
class TitleAppbar extends StatelessWidget {

  final String title;
  final IconData icon;
  
  const TitleAppbar({
    Key key, 
    @required this.title, 
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        children: [
          Platform.isIOS ? SizedBox(height: 20,)
          : Container(),
          Row(
            children: <Widget>[
              Platform.isIOS 
              ? Container()
              : Icon(
                icon,
                color: Colors.blue[700],
                size: 20,
              ),
              Platform.isIOS 
              ? Container(): SizedBox(width: 10,),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style:  customStyle(Colors.black, 25, FontWeight.bold,)
                
              )
            ],
          ),
        ],
      ),
    );
  }
}
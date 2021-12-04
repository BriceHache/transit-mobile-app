import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';



class OnBordingPages extends StatelessWidget {
  const OnBordingPages({
    Key key,
    @required this.context, 
    @required this.urlImg, 
    @required this.title, 
    @required this.msg,
  
  }) : super(key: key);

  final BuildContext context;
  final String urlImg;
  final String title;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(height: 10,),
        Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 50),
          height:MediaQuery.of(context).size.height * .42,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(urlImg),
            fit: BoxFit.cover,
            ),
            
          ),
        ),
        
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: MediaQuery.of(context).size.height * .15),
            child: Text(
              title,
              style: customStyle(Colors.white, 24, FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 15, top: MediaQuery.of(context).size.height * .38),
            child: Text(
              msg,
              style: customStyle(Colors.grey[200], 14, FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ),

      ],
    );
  }
}
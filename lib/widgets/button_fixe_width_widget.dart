import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class FixeWidthButton extends StatelessWidget {
  const FixeWidthButton({
    Key key,
    this.icon,
    @required this.title,
    @required this.callback,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 90,
      height: 65,
      padding: EdgeInsets.only( top: 20, left: 20, right: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ) ,
        ),
        
      
        onPressed: callback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
            SizedBox(width: 10,),
            Text(
                title,
                style: customStyleLetterSpace(Colors.white, 18, FontWeight.bold, 1)
                
                
              ),
          ],
        ),
      ),
    );
  }
}
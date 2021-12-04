import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class IconButtonCustom extends StatelessWidget {
  final String title;
  final Function onTap;
  IconButtonCustom({
    @required this.title,
    @required this.onTap,
 
  });
  @override
  Widget build(BuildContext context) {
    return 
    ElevatedButton(
      style:  ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
         backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).accentColor),
         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            
          )
        )
      ),
      onPressed: onTap,
      

      child: Container(
        height: 55,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
              Icon(Icons.email, color: Colors.white),
              SizedBox(
                width: 10,
              ),
              Text(
                this.title,
                style: customStyle(Colors.white, 18, FontWeight.bold)
              )

          ],
        ),
      ),
    );
    
  }
}

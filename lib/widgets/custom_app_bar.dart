import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {

  final String title;
  final Function onTap;
  final IconData icon;

  const CustomAppBar({
    Key key, 
    @required this.title, 
    this.onTap, 
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      height: _size.height * .1,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 10.0,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        color:  Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
              
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(width: 25,),
            
            ],
          ),
        
      ),
    );
  }
}
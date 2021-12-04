import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;

  final String hintText;
  final TextEditingController textEditingController;
  final TextInputType kyboardType;
  final bool isPassword;
  final TextCapitalization textCapitalization;
  final Widget suffixIcon;
  final double height;
  final bool enable;
  final TextStyle hintStyle;
  final Function validator;


  const CustomInput({
    Key key, 
    @required this.icon, 
    
    @required this.hintText, 
    @required this.textEditingController, 
    this.kyboardType = TextInputType.text, 
    this.isPassword = false,
    this.textCapitalization = TextCapitalization.none, 
    this.suffixIcon, 
    this.height, 
    this.enable = true, 
    this.hintStyle, 
    this.validator , 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(247, 247, 255, 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        validator: validator,
        textAlignVertical: TextAlignVertical.center,
        textCapitalization: textCapitalization,
        controller: textEditingController,
        autocorrect: false,
        keyboardType: kyboardType,
        obscureText: isPassword,
        style: customStyle(Colors.grey[800], 16, FontWeight.normal),
        decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor,),
        suffixIcon: suffixIcon,
        hintText: this.hintText,
        
        
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.white),
        ),
        
        filled: !enable,
      ),
       
      ),
    );
  }
}
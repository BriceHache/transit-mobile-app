// Who knows? Not me,
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
//me
import 'package:ball_on_a_budget_planner/widgets/custom_input.dart';
import 'package:ball_on_a_budget_planner/widgets/labels.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/logo.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body:  SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
         padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage('assets/images/bgl.jpg'),
          fit: BoxFit.fill
          )
        ),
        child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Logo(title: 'appbar_label_reset'.tr(),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(
                  height: _height,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      _Form(),
                      SizedBox(height: 80,),
                      Labels(
                      title:'Ready? ', 
                      subtitle:'success_button'.tr(), 
                      route: 'email',
                    ),
                      
                    ],
                  ),
                ),
              ),
            
          ],),
      ),
      ),
    );
  }
}

class _Form extends StatefulWidget {

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.center,
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'reset_title'.tr(),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'reset_subtitle'.tr(),
                        style: TextStyle(color: Colors.grey[200], fontWeight: FontWeight.w400, fontSize: 14),
                        
                      ),
                    ],
                  ),
                ),
            ),

          CustomInput(
          icon: Icons.email,
          hintText: 'email_hint'.tr(),
          kyboardType: TextInputType.emailAddress,
          textEditingController: emailCtrl,
          validator: (String val) {
            if (val.trim().isEmpty) {
              return 'email_required'.tr();
            }
            if (!RegExp(
                    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                .hasMatch(val)) {
              return 'valid_email'.tr();
            }
            return null;
          },
        ),
          
      
          LargeButton(
            onTap: (){}, 
            title: 'reset_button'.tr(),
          ),

        ],),
      ),
    );
  }
}


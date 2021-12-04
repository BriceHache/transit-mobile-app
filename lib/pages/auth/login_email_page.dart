// Who knows? Not me,
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//me
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/helpers/helpers.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/pages/auth/on_boarding.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';
import 'package:ball_on_a_budget_planner/widgets/labels.dart';
import 'package:ball_on_a_budget_planner/widgets/custom_input.dart';
import 'package:ball_on_a_budget_planner/widgets/logo.dart';

import '../home_page.dart';


class LoginEmailPage extends StatefulWidget {
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
 final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldMessengerKey,
      body:  SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Logo(title: 'Email_Login'.tr(),),
                    ),
                    Container(
                      height: _height,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          _Form(),
                          SizedBox(height: 80,),
                         /* Labels(
                            title:'not_account'.tr(), 
                            subtitle:'register_btn'.tr(), 
                            route: 'register',
                          ),
                          SizedBox(height: 80,),
                          Labels(
                            title:'', 
                            subtitle:'register_btn_label'.tr(), 
                            route: 'welcome',
                          ),*/
                        ],
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
  final usernameCtrl = TextEditingController();
  bool _obscurePassword = true;
  SignInBloc signinBloc;
  bool inProgress;

  @override
  void initState() {
    super.initState();
    inProgress = false;
    signinBloc = BlocProvider.of<SignInBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SignInBloc, SignInBlocState>(
        listener: (_, state) {
          if (state is SignInEmailProgressState) {
            print('sign in with email in progress');

            setState((){
              inProgress = true;
            });

          }
          if (state is SignInEmailFailedState) {
            //failed
            showAlert(context, 'L\'authentification a échoué!','${state.res} ');
            print('sign in with email failed');
            setState(() {
              inProgress = false;
            });
      
          }
          if (state is SignInEmailCompletedState) {
            Navigator.pushReplacement(context, navegateFadein(context, OnBoardingPage()));
           // Navigator.pushReplacement(context, navegateFadein(context, HomePage()));
          }
        },
        child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: Column(children: [
              CustomInput(
             // icon: Icons.email,
              icon: Icons.verified_user,
             // hintText: 'email_hint'.tr(),
              hintText: 'username'.tr(),
              kyboardType: TextInputType.text,
             // kyboardType: TextInputType.emailAddress,
              textEditingController: usernameCtrl,
             // textEditingController: emailCtrl,
              validator: (String val) {

                if (val.trim().isEmpty) {
                  return 'username_required'.tr();
                }
                /* if (!RegExp(
                        r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$")
                    .hasMatch(val)) {
                  return 'valid_email'.tr();
                } */
                return null;
              },
            ),
             CustomInput(
              icon: Icons.lock,
              hintText: 'password'.tr(),
              kyboardType: TextInputType.text,
              textEditingController: passwordCtrl,
              isPassword: _obscurePassword,
              validator: (String val) {
                
                if (val.trim().isEmpty) {
                  return 'password_required'.tr();
                }
                if(val.length < 6){
                  return 'valid_password'.tr();
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: _obscurePassword ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye),
                onPressed: (){
                  setState(() {
                    _obscurePassword = _obscurePassword ? false : true;
                  });
                },
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () => Navigator.pushReplacementNamed(context, 'reset'),
                child: Text(
                  'forgot_label'.tr(),
                   style: customStyle(Colors.white, 16, FontWeight.w400),
                ),
              ),
            ),
            Container(height: 40,),

            inProgress
            ? CircularProgressIndicator()
            :LargeButton(
              onTap: (){
               
                 if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    signinBloc.add(SignInWithEmailEvent(usernameCtrl.text, passwordCtrl.text));

                    setState(() {
                      inProgress = true;
                    });
                  }
              }, 
              title: 'login'.tr(),
              fontSize: 18,
            ),
          ],),
        ),
      ),
    );
  }
}


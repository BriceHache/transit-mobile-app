// Who knows? Not me,
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//me
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/helpers/helpers.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/pages/auth/on_boarding.dart';
import 'package:ball_on_a_budget_planner/widgets/custom_input.dart';
import 'package:ball_on_a_budget_planner/widgets/labels.dart';
import 'package:ball_on_a_budget_planner/widgets/large_button.dart';


class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
       
        child: Column(
            children: [
              SizedBox(height: 60,),
              Text('register_label'.tr(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white ),),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                    child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white
                        ),
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/img_user_template.jpg'),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              Container(
              height: _height,
              width: double.infinity,
              child: _Form(),
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
  bool _obscurePassword = true;
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final userNameCtrl = TextEditingController();
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

    return BlocListener <SignInBloc, SignInBlocState>(
      listener: (_, state) {
        if (state is SignUpEmailProgressState) {
          print('sign up in progress');

          setState((){
            inProgress = true;
            
          });
        }
        if (state is SignUpEmailFailedState) {
          //failed
          showAlert(context, 'Sign up with Email failed!','${state.res} ');
          print('sign in with email failed');
          setState(() {
            inProgress = false;
          });
    
        }
       /* if (state is SignUpEmailCompletedState) {
            //proceed to save details
         
          String email = state.firebaseUser.email;

          signinBloc.add(SaveToFirebase(
            name: userNameCtrl.text,
            email: email,
            firebaseUser: state.firebaseUser,
            loggedInVia: 'Email',
          ));
        */
       /* if (state is CompletedSavingToFirebase) {
              print(state.user.email);
              //proceed to home
              //close signupBloc
              

              Navigator.pushReplacement(context, navegateFadein(context, OnBoardingPage()));
            }*/

      },
      child: Form(
        key: _formKey,
        child: Container(
           margin: EdgeInsets.only(top: 40),
          
          child: Column(children: [
            
            CustomInput(
              icon: Icons.account_circle,
              hintText: 'user_name_hint'.tr(),
              kyboardType: TextInputType.text,
              textEditingController: userNameCtrl,
              textCapitalization: TextCapitalization.sentences,
              validator: (String val) {
                
                if (val.trim().isEmpty) {
                  return 'name_required'.tr();
                }
                if(val.length < 2){
                  return 'valid_name'.tr();
                }
                return null;
              },
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
                icon: _obscurePassword ?  Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye),
                onPressed: (){
                  setState(() {
                    _obscurePassword = _obscurePassword ? false : true;
                  });
                },
              ),
            ),
            SizedBox(height: 50,),
            inProgress
            ? CircularProgressIndicator()
            : LargeButton(
              onTap: (){
                if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(emailCtrl.text);
                    signinBloc.add(SignUpWithEmailEvent(userNameCtrl.text, emailCtrl.text, passwordCtrl.text));
                    setState(() {
                      inProgress = true;
                    });
                  }

              }, 
              title: 'register_label'.tr(),
            ),
            SizedBox(height: 50,),
            Labels(
              title:'accountAlt'.tr(), 
              subtitle:'login_btn_Alt'.tr(), 
              route: 'email', 
            ),

          ],),
        ),
      ),
    );
  }
}


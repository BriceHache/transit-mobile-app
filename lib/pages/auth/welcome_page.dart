import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:ball_on_a_budget_planner/widgets/icon_button_connexion.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//me
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/helpers/helpers.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/pages/auth/on_boarding.dart';
import 'package:ball_on_a_budget_planner/widgets/custom_divider.dart';
import 'package:ball_on_a_budget_planner/widgets/icon_button.dart';


import '../../helpers/styles_custom.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String email, name;
  SignInBloc signinBloc;
  bool inProgress;
  bool inProgressFace;
  
  @override
  void initState() {
    super.initState();
    inProgress = false;
    inProgressFace = false;
    signinBloc = BlocProvider.of<SignInBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      body: Container(
        padding: EdgeInsets.only(left: 25, right: 25),
        
        child: BlocListener <SignInBloc, SignInBlocState>(
          listener: (BuildContext context, state) {
           /* if (state is SignInInGoogleProgressState) {
              print('sign in with google in progress');

              setState((){
                inProgress = true;
               
              });
            }
            if (state is SigninGoogleFailedState) {
              //failed
              showAlert(context, 'Sign in with Google failed!','Error with Google login! Please try with Facebook');
              print('sign in with google failed');
              setState(() {
                inProgress = false;
              });
        
            }
            if (state is SigInGoogleCompletedState) {
                //proceed to save details
              name = state.firebaseUser.displayName;
              email = state.firebaseUser.email;

              signinBloc.add(SaveToFirebase(
                name: name,
                email: email,
                firebaseUser: state.firebaseUser,
                loggedInVia: 'GOOGLE',
              ));
            }
            if (state is SignInFacebookProgressState) {
              print('sign in with google in progress');

              setState((){
                inProgressFace = true;
               
              });
            }
            if (state is SignInFacebookFailedState) {
              //failed
              print('sign in with facebook failed');
              setState(() {
                inProgressFace = false;
              });
              showAlert(context, 'Sign in with facebook failed!','Error with Facebook login! Please try with google');
            }
            if (state is SignInFacebookCompletedState) {
                //proceed to save details
              name = state.firebaseUser.displayName;
              email = state.firebaseUser.email;

              signinBloc.add(SaveToFirebase(
                name: name,
                email: email,
                firebaseUser: state.firebaseUser,
                loggedInVia: 'FACEBOOK',
              ));
            }
            if (state is CompletedSavingToFirebase) {
              print(state.user.email);
              //proceed to home
              //close signupBloc
              

              Navigator.pushReplacement(context, navegateFadein(context, OnBoardingPage()));
            }
            if (state is FailedSavingProcess) {
              //failed saving user details
              print('failed to save');
              showAlert(context, 'Failed to save user details!','Error with DB please contact admin');
              setState(() {
                inProgressFace = true;
              });
            }*/
            

           },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
            children: [
              SizedBox(height: 50,),
              Text(
                'company_name'.tr(),
                style: customStyle(Colors.white, 22, FontWeight.bold),
              ),
              Padding(
                      padding: const EdgeInsets.only( bottom: 15, left: 30, right: 30, top: 10,),
                      child: Image.asset('assets/images/login_icon.png', fit: BoxFit.fill,),
                    ),
              Text(
                'login'.tr() ,
                  style: customStyleLetterSpace(Colors.white, 22,  FontWeight.w900, 0.338)
              ),
              Container(
                padding: EdgeInsets.only(top: 5, left: 25, right: 25),
                child: Text(
                  'message_login'.tr(),
                  textAlign: 
                  TextAlign.center,
                  style: customStyle(Colors.white, 14, FontWeight.w500)
                ),
              ),
              
              SizedBox(height: 25,),
              
           //   _buildSocialBtnRow(context),
           //   SizedBox(height: 30,),
              Row(
                children: [
                  CustomDivider(),
                  Text('login_comp_name'.tr(), style: TextStyle(color: Colors.grey),),
                  CustomDivider(),
                ],
              ),
              SizedBox(height: 25,),
           //   IconButtonCustom(title: 'connexion'.tr(), onTap: (){
              IconButtonCustomConnexion(title: 'connexion'.tr(), onTap: (){
                Navigator.pushReplacementNamed(context, 'email');
              }),

            ],
        ),
          ),
          
        )
        
        
        
      ),
    );
  }

 
 /* Widget _buildSocialBtnRow(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          inProgressFace
          ? CircularProgressIndicator()
          :_socialBtn(
            () => signinBloc.add(SignupWithFacebook()),
            AssetImage('assets/images/facebook.jpg'),
          ),
           inProgress
          ? CircularProgressIndicator()
          : _socialBtn(
             () => signinBloc.add(SignupWithGoogle()),
            AssetImage('assets/images/ic_google.png'),
          ),
        ],
      ),
    );
  }*/

  /* Widget _socialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.0,
        width: 70.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage( image: logo),
        ),
      ),
    );
  }*/


}
import 'package:ball_on_a_budget_planner/custom_models/user.dart';
import 'package:ball_on_a_budget_planner/helpers/styles_custom.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//me
import 'package:ball_on_a_budget_planner/bloc/profile_bloc/profile_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/bloc/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:ball_on_a_budget_planner/helpers/helpers.dart';
import 'package:ball_on_a_budget_planner/helpers/show_alert.dart';
import 'package:ball_on_a_budget_planner/models/user.dart';
import 'package:ball_on_a_budget_planner/pages/auth/welcome_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   SignInBloc signinBloc;
   bool isSigningOut;
   ProfileBloc profileBloc;
   User currentUser;
   UserModel user;
   bool haveUser;
   FlutterSecureStorage _storage;


    @override
  void initState() {
    super.initState();
    _storage = new FlutterSecureStorage();
     signinBloc = BlocProvider.of<SignInBloc>(context);
     profileBloc = BlocProvider.of<ProfileBloc>(context);
     isSigningOut = false;
     haveUser = false;
     signinBloc.add(GetCurrentUser());
     signinBloc.listen((state) {
      if (state is GetCurrentUserCompleted) {
        //currentUser = state.firebaseUser;
        String userId =  _storage.read(key: 'userId') as String;
       // profileBloc.add(GetProfileDetailsEvent(currentUser.uid));
        profileBloc.add(GetProfileDetailsEvent(userId));
      }
      });


  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(

        body: BlocListener<SignInBloc, SignInBlocState>(
        listener: (context, state) {
          print('state: ' + isSigningOut.toString());
          if (state is SignOutProgressState) {
            isSigningOut = true;
          }
          if (state is SignOutFailedState) {
            //show failed dialog
            if (isSigningOut) {
              showAlert(context,'Failed to sign out!', '' );
              isSigningOut = false;
            }
          }
          if (state is SignoutCompletedState) {
            //take to splash screen
            if (isSigningOut) {
              isSigningOut = false;
               Navigator.pushReplacement(context, navegateFadein(context, WelcomePage()));
            }
          }

        },
        child: BlocBuilder(
          cubit: profileBloc,
          builder: (context, state){

            if( state is GetProfileDetailsInProgressState ){

              user = new UserModel(name: '', profileImageUrl: 'https://res.cloudinary.com/manidevs/image/upload/v1578013055/Portrait_Placeholder_zkqinn.png', email: '', loggedInVia: '');
              return buildBody(user);
            }
            if( state is GetProfileDetailsCompletedState ){
              user = state.user;
              return buildBody(user);
            }
            return SizedBox();
          } ,
        )
      )
    );
  }


  Widget buildBody( UserModel user){
    
    return SingleChildScrollView(
      child: Center(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:  Theme.of(context).accentColor
                  ),
                  padding: EdgeInsets.all(45),
                  child: CircleAvatar(
                  radius: 200,
                  backgroundColor: Colors.white,
                    child: Container(
                    height: 100,
                    width: 100,
                    
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.white
                        ),
                        
                        color: Colors.grey[500],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(user.loggedInVia == 'Email' ? "https://res.cloudinary.com/manidevs/image/upload/v1578013055/Portrait_Placeholder_zkqinn.png": user.profileImageUrl),
                            fit: BoxFit.cover)),
                    
                  ),
                  
                ),
                
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.white, size: 35,),
                    title: Text('user_name'.tr(), style: customStyle(Colors.white, 14, FontWeight.normal),),
                    subtitle: Text(user.name, style: customStyle(Colors.white, 16, FontWeight.normal),),
                  ),
                ),
                Divider(color: Colors.white,),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    leading: Icon(Icons.email, color: Colors.white, size: 35),
                    title: Text('Email', style: customStyle(Colors.white, 14, FontWeight.normal),),
                    subtitle: Text(user.email, style: customStyle(Colors.white, 16, FontWeight.normal),),
                  ),
                ),
                Divider(color: Colors.white,),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    leading: Icon(Icons.login, color: Colors.white, size: 35),
                    title: Text('Logged In via', style: customStyle(Colors.white, 14, FontWeight.normal),),
                    subtitle: Text(user.loggedInVia, style: customStyle(Colors.white, 16, FontWeight.normal),),
                  ),
                ),
                
                
                ],
              ),
            ),
          ),
    );
  }

 

  showSignoutConfimationDialog(Size size) {
    return showDialog(
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        elevation: 5.0,
        contentPadding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 20.0, bottom: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Do you want to sign out?',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: TextButton(
                    
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 50.0,
                  child: TextButton(
                    
                    onPressed: () {
                      Navigator.pop(context);
                      signinBloc.add(SignoutEvent());
                      isSigningOut = true;
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), barrierDismissible: false,
      context: context,
    );
  }

}
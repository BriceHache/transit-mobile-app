
import 'package:ball_on_a_budget_planner/configs/globals.dart';
import 'package:ball_on_a_budget_planner/custom_models/UserResponse.dart';
import 'package:ball_on_a_budget_planner/custom_models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:ball_on_a_budget_planner/services/base_service.dart';
import 'package:http/http.dart' as http;

import 'dart:async';

import 'dart:convert';


class AuthService extends BaseAuthService {
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //final GoogleSignIn googleSignIn = GoogleSignIn();
  //final FirebaseFirestore db = FirebaseFirestore.instance;
  //final FacebookLogin facebookLogin = new FacebookLogin();

   // Create storage
  final _storage = new FlutterSecureStorage();

  // Get target host for http requests
  String targethost = Globals.targethost;


  @override
  void dispose() {}

  @override
  Future<User> getCurrentUser() async{
   // return firebaseAuth.currentUser;
  }


  //@override
  /* Future<User> signInWithGoogle() async{
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );
    await firebaseAuth.signInWithCredential(authCredential);
     User user = firebaseAuth.currentUser;
     print(user.uid);
     await this._saveUserId( user.uid );
        DocumentSnapshot snapshot =
        await db.collection('Users').doc(user.uid).get();

      if (snapshot.exists) {
        if (snapshot.data()['isBlocked']) {
          await googleSignIn.signOut();
          await firebaseAuth.signOut();
         // await facebookLogin.logOut();
          
          print( 'Your account has been blocked');
        }
      } 
    
    return firebaseAuth.currentUser;
  }*/

   //@override
  /*Future<User> signInWitFacebook() async{
    final FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email', 'public_profile']);
      if(facebookLoginResult.status == FacebookLoginStatus.cancelledByUser){
        print( 'cancel by user');
        return null;
      } else if(facebookLoginResult.status == FacebookLoginStatus.error){
        print( 'error');
        return null;
      }else {
        try {
          if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
            FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
            final AuthCredential credential = FacebookAuthProvider.credential(facebookAccessToken.token);
            await firebaseAuth.signInWithCredential(credential);
            print('here');
            User user = firebaseAuth.currentUser;
            DocumentSnapshot snapshot =
            await db.collection('Users').doc(user.uid).get();
            if (snapshot.exists) {
              if (snapshot.data()['isBlocked']) {
                await googleSignIn.signOut();
                await firebaseAuth.signOut();
                print( 'Your account has been blocked');
              }
            } 
          await this._saveUserId( user.uid );
          return user;
            
          }
        } catch (e) {
          print(e);
          return null;
        }

      } 
      return null;
  }*/

 /* @override
  Future<User> signInWithApple() {
  
    throw UnimplementedError();
  }*/

  @override
  Future<bool> checkIfSignedIn() async{
    //final user = firebaseAuth.currentUser;
    final user_id = getUserId();

   // print(user.email);
   // if (user != null) {
    if (user_id != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> signOutUser()async {
    try {
      Future.wait([
       // firebaseAuth.signOut(),
       // googleSignIn.signOut(),
        this.logOut()
      ]);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserResponse> signIn(String email, String password) async {

    UserResponse resp = new UserResponse();
    var queryParameters = {
      'username': email,
      'password': password,

    };
    //we are using asp.net Identity for login/registration. the first time we
    //login we must obtain an OAuth token which we obtain by calling the Token endpoint
    //and pass in the email and password that the user registered with.
    try {

      var gettokenuri = new Uri(scheme: 'http',
          //port: 8086,
          host: targethost,
          path: '/Token');

      //the user name and password along with the grant type are passed the body as text.
      //and the contentype must be x-www-form-urlencoded
      var loginInfo = 'UserName=' + email + '&Password=' + password +
          '&grant_type=password';

      final response = await http
          .post(
          gettokenuri,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: loginInfo
      );

      print(response.statusCode);
      // alice.onHttpResponse(response);
      if (response.statusCode == 200) {
        resp.error = '200';
        final json = jsonDecode(response.body);
        Globals.token = json['access_token'] as String;

        // store user id
        await this._saveUserId(json['Id'] as String);
        await this._saveUserRole(json['Role'] as String);

      }
      else {
        //this call will fail if the security stamp for user is null
        resp.error = response.statusCode.toString() + ' ' + response.body;
        return resp;
      }

    }

    catch (e){
      resp.error = e.message;
    }
    return   resp ;

  }


  // SignIn using Firebase
  /*@override
  Future signInWithEmail(String email, String password) async{
     try {
      UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      if (authResult.user != null) {
       await this._saveUserId( authResult.user.uid );
        return authResult.user;
      } 
    } catch (e) {
      print(e);
      return e.code;
    }
  }*/

 /* @override
  Future signUpWithEmail(String userName, String email, String password )async {
    String photoUrl = "https://res.cloudinary.com/manidevs/image/upload/v1583175320/img_user_template_smqb3m.jpg";
    try {
      UserCredential authResult = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email, password: password);
      User user;
      await this._saveUserId( authResult.user.uid );
      if (authResult.user != null)  {
        user = authResult.user;
        await user.updateProfile(
          displayName: userName,
          photoURL: photoUrl
        );
        authResult.user.uid;
        return user;
      }   
    } catch (e) {
      print(e);
      return e.code;
    }
  }*/
  
  //@override
  /*Future<bool> resetEmail(String email) async{
     try {
       await firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((result) {
          return true;
      }).catchError((e) {
        print(e);
         return false;
      });
    } catch (e) {
       print(e);
         return false;
    }
    return false;
    
  }*/

  Future _saveUserId( String userId ) async {

    // Write value 
    await _storage.write(key: 'userId', value: userId);
    return;

  }

  Future _saveUserRole( String role ) async {

    // Write value
    await _storage.write(key: 'role', value: role);
    return;

  }

  Future logOut() async {
    // Delete value 
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'role');

  }

  //static getters U
  static Future<String> getUserId() async {
    final _storage = new FlutterSecureStorage();
    final userId = await _storage.read(key: 'userId');
    return userId;
  }


  static Future<String> getRole() async {
    final _storage = new FlutterSecureStorage();
    final role = await _storage.read(key: 'role');
    return role;
  }



}
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:ball_on_a_budget_planner/authentication_repository/base_repository.dart';
import 'package:ball_on_a_budget_planner/custom_models/user.dart';
import 'package:ball_on_a_budget_planner/services/auth_service.dart';

class AuthenticationRepository extends BaseRepository{
  AuthService authService = AuthService();

   @override
  void dispose() {
    authService.dispose();
  }

  /*Future<User> signInWithGoogle() =>
      authService.signInWithGoogle();*/
  
  /*Future<User> signInWithFacebook() =>
      authService.signInWitFacebook();*/
  
  Future signInWithEmail(
    String email, 
    String password) =>
     // authService.signInWithEmail(email, password);
      authService.signIn(email, password);

  /*Future signUpWithEmail(
    String userName, 
    String email, 
    String password) =>
      authService.signUpWithEmail(userName, email, password);*/

  Future<bool> signOutUser() => authService.signOutUser();

  Future<bool> checkIfSignedIn() => authService.checkIfSignedIn();

  Future<User> getCurrentUser() => authService.getCurrentUser();

 
}

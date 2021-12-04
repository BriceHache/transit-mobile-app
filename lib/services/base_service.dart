import 'package:ball_on_a_budget_planner/custom_models/UserResponse.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:ball_on_a_budget_planner/models/user.dart';

abstract class BaseService {
  void dispose();
}

abstract class BaseAuthService extends BaseService {
  Future<bool> checkIfSignedIn();
  //Future<User> signInWithGoogle();
 // Future<User> signInWitFacebook();
  //Future<User> signInWithApple();
 // Future signInWithEmail(String email, String password);
  Future<UserResponse> signIn(String email, String password);
 // Future signUpWithEmail(String userName, String email, String password, );
 // Future<bool> resetEmail(String email);
  Future<bool> signOutUser();
  //Future<User> getCurrentUser();
}

abstract class BaseUserDataService extends BaseService {
  Future<UserModel> getUserProfile(String uid);
  Future<UserModel> saveToFirebase({
    String uid,
    String name,
    String email,
    String profileImageUrl,
    String tokenId,
    String loggedInVia,
  });
  
}

abstract class BaseStorageService extends BaseService {}

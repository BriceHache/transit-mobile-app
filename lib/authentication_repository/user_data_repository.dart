import 'package:ball_on_a_budget_planner/models/user.dart';
import 'package:ball_on_a_budget_planner/services/user_data_service.dart';

class UserDataRepository  {
  UserDataService userDataService = UserDataService();

  Future<UserModel> getUserProfile(String uid) => userDataService.getUserProfile(uid);

  Future<UserModel> saveToFirebase(
    String uid,
    String name,
    String email,
    String profileImageUrl,
    String tokenId,
    String loggedInVia,
  ) =>
      userDataService.saveToFirebase(
        email: email,
        name: name,
        profileImageUrl: profileImageUrl,
        tokenId: tokenId,
        uid: uid,
        loggedInVia: loggedInVia,
      );

  void dispose() {
    userDataService.dispose();
  }
}


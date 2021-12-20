part of 'sign_in_bloc_bloc.dart';

@immutable
abstract class SignInBlocState {}

class SignInBlocInitial extends SignInBlocState {}

//get user
class GetCurrentUserInProgress extends SignInBlocState {
  @override
  String toString() => 'GetCurrentUserInProgressState';
}
class GetCurrentUserFailed extends SignInBlocState {
  @override
  String toString() => 'GetCurrentUserFailedState';
}
class GetCurrentUserCompleted extends SignInBlocState {
  final User commonUser;
  GetCurrentUserCompleted(this.commonUser);

  @override
  String toString() => 'GetCurrentUserCompletedState';
}

//save to Firestore database 
/*class SavingUserDb extends SignInBlocState {}
class FailedSavingProcess extends SignInBlocState {
  @override
  String toString() => 'FailedSavingUserDetailsState';
}
class CompletedSavingToFirebase extends SignInBlocState {
  final UserModel user;
  CompletedSavingToFirebase(this.user);
}*/


//google 
/*class SignInInGoogleProgressState extends SignInBlocState {}
class SigninGoogleFailedState extends SignInBlocState {
  @override
  String toString() => 'SigninGoogleFailedState';
}
class SigInGoogleCompletedState extends SignInBlocState {
  final User firebaseUser;
  SigInGoogleCompletedState(this.firebaseUser);
  String toString() => 'SigInGoogleCompletedState';
}*/

//facebook
/*class SignInFacebookProgressState extends SignInBlocState {}
class SignInFacebookFailedState extends SignInBlocState {
  @override
  String toString() => 'SignInFacebookFailedState';
}
class SignInFacebookCompletedState extends SignInBlocState {
  final User firebaseUser;
  SignInFacebookCompletedState(this.firebaseUser);
  String toString() => 'SignInFacebookCompletedState';
}*/

//sign in email
class SignInEmailProgressState extends SignInBlocState {}
class SignInEmailFailedState extends SignInBlocState {
   final String res;

  SignInEmailFailedState(this.res);
  @override
  String toString() => 'SignInEmailFailedState';
}
class SignInEmailCompletedState extends SignInBlocState {
  String toString() => 'SignInFacebookCompletedState';
}

//sign up email
class SignUpEmailProgressState extends SignInBlocState {}
class SignUpEmailFailedState extends SignInBlocState {
  final String res;
  SignUpEmailFailedState(this.res);

  @override
  String toString() => 'SignInEmailFailedState';
}
/*
class SignUpEmailCompletedState extends SignInBlocState {
  final User firebaseUser;

  SignUpEmailCompletedState(this.firebaseUser);
  String toString() => 'SignInFacebookCompletedState';
}*/

//check is user is logged 
class CheckIfSignedInInProgressState extends SignInBlocState {
  @override
  String toString() => 'CheckIfSignedInInProgressState';
}
class CheckIfSignedInFailedState extends SignInBlocState {
  @override
  String toString() => 'CheckIfSignedInFailedState';
}
class CheckIfSignedInCompletedState extends SignInBlocState {
  final bool res;
  CheckIfSignedInCompletedState(this.res);
  @override
  String toString() => 'CheckIfSignedInCompleted';
}

//sign out 
class SignOutProgressState extends SignInBlocState {
  @override
  String toString() => 'SignOutEventInProgressState';
}
class SignOutFailedState extends SignInBlocState {
  @override
  String toString() => 'SignOutEventFailedState';
}
class SignoutCompletedState extends SignInBlocState {
  @override
  String toString() => 'SignoutCompletedStateState';
}






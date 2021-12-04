part of 'sign_in_bloc_bloc.dart';

@immutable
abstract class SignInBlocEvent {}

class GetCurrentUser extends SignInBlocEvent {
  @override
  String toString() => 'GetCurrentUserEvent';
}

/*class SignupWithGoogle extends SignInBlocEvent {
  @override
  String toString() => 'SignupWithGoogleEvent';
}

class SignupWithFacebook extends SignInBlocEvent {
  @override
  String toString() => 'SignupWithFacebook';
}*/

class SignInWithEmailEvent extends SignInBlocEvent {
  final String email;
  final String password;

  SignInWithEmailEvent(this.email, this.password);
  @override
  String toString() => 'SignInWithEmailEvent';
}

class SignUpWithEmailEvent extends SignInBlocEvent {
  final String userName;
  final String email;
  final String password;

  SignUpWithEmailEvent(this.userName, this.email, this.password);
  @override
  String toString() => 'SignInWithEmailEvent';
}

/*class SaveToFirebase extends SignInBlocEvent {
  final String name;
  final String email;
  final User firebaseUser;
  final String loggedInVia;

  SaveToFirebase({
    @required this.name,
    @required this.email,
    @required this.firebaseUser,
    @required this.loggedInVia,
  });

  @override
  String toString() => 'SaveToFirebaseEvent';
}*/

class CheckIfSignedIn extends SignInBlocEvent {}

class SignoutEvent extends SignInBlocEvent {
  @override
  String toString() => 'SignoutEvent';
}



import 'dart:async';

import 'package:ball_on_a_budget_planner/custom_models/UserResponse.dart';
import 'package:bloc/bloc.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
//me
import 'package:ball_on_a_budget_planner/authentication_repository/user_data_repository.dart';
import 'package:ball_on_a_budget_planner/models/user.dart';
import 'package:ball_on_a_budget_planner/authentication_repository/authentication_repository.dart';

part 'sign_in_bloc_event.dart';
part 'sign_in_bloc_state.dart';

class SignInBloc extends Bloc<SignInBlocEvent, SignInBlocState> {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;

  SignInBloc({
    this.authenticationRepository, 
    this.userDataRepository
  }) : super(null);

  SignInBlocInitial get initialState => SignInBlocInitial();

  @override
  Stream<SignInBlocState> mapEventToState(
    SignInBlocEvent event,
  ) async* {
    if(event is CheckIfSignedIn){
      yield*mapCheckIfSignedInToState();
    }
   /* else  if (event is GetCurrentUser) {
      yield* mapGetCurrentUserToState();
    }*/
    /*else if (event is SignupWithGoogle) {
      yield* mapSignInWithGoogleEventToState();
    }*/
    /*else if (event is SignupWithFacebook) {
      yield* mapSignInFacebookEventToState();
    }*/else if (event is SignInWithEmailEvent) {
      yield* mapSignInEmailEventToState(
        email: event.email,
        password: event.password
      );
    }
    /*else if (event is SignUpWithEmailEvent) {
      yield* mapSignUpEmailEventToState(
        userName: event.userName,
        email: event.email,
        password: event.password
      );
    }else if (event is SaveToFirebase) {
      yield* mapSaveToFirebaseToState(
        email: event.email,
        name: event.name,
        firebaseUser: event.firebaseUser,
        loggedInVia: event.loggedInVia,
      );
    }
    if (event is SignoutEvent) {
      yield* mapSignoutEventToState();
    }*/
  }

  Stream<SignInBlocState> mapCheckIfSignedInToState() async* {
    try {
      bool res = await authenticationRepository.checkIfSignedIn();
      if (res != null) {
        yield CheckIfSignedInCompletedState(res);
      } else {
        yield CheckIfSignedInFailedState();
      }
    } catch (e) {
      print(e);
      yield CheckIfSignedInFailedState();
    }
  }

   /*Stream<SignInBlocState> mapGetCurrentUserToState() async* {
    try {
      User currentUser = await authenticationRepository.getCurrentUser();
      
      if (currentUser != null) {
        yield GetCurrentUserCompleted(currentUser);
      } else {
        yield GetCurrentUserFailed();
      }
    } catch (e) {
      print(e);
      yield GetCurrentUserFailed();
    }
  }*/

 /* Stream<SignInBlocState> mapSignInWithGoogleEventToState() async* {
    yield SignInInGoogleProgressState();

    try {
      User firebaseUser = await authenticationRepository.signInWithGoogle();
      if (firebaseUser != null) {
        yield SigInGoogleCompletedState(firebaseUser);
      } else {
        yield SigninGoogleFailedState();
      }
    } catch (e) {
      print(e);
      yield SigninGoogleFailedState();
    }
  }*/
  
  /*Stream<SignInBlocState> mapSignInFacebookEventToState() async* {
    yield SignInFacebookProgressState();

    try {
      User firebaseUser = await authenticationRepository.signInWithFacebook();
      if (firebaseUser != null) {
        yield SignInFacebookCompletedState(firebaseUser);
      } else {
        yield SignInFacebookFailedState();
      }
    } catch (e) {
      print(e);
      yield SignInFacebookFailedState();
    }
  }*/

  Stream<SignInBlocState> mapSignInEmailEventToState({
    String email,
    String password,
  }) async* {
      yield SignInEmailProgressState();
      try {
        /*dynamic res =
            await authenticationRepository.signInWithEmail(email, password);
        if (res is User) {
          yield SignInEmailCompletedState();
        } else {
          yield SignInEmailFailedState(res);
        }*/

        UserResponse resp =
        await authenticationRepository.signInWithEmail(email, password);
        if (resp.error == '200') {
          yield SignInEmailCompletedState();
        } else {
          yield SignInEmailFailedState(resp.error);
        }

      } catch (e) {
        print(e);
        yield SignInEmailFailedState(e);
      }
  }

 /* Stream<SignInBlocState> mapSignUpEmailEventToState({
    String userName,
    String email,
    String password,
  }) async* {
      yield SignUpEmailProgressState();
      try {
        dynamic res =
            await authenticationRepository.signUpWithEmail(userName, email, password);
        
        if (res is User) {
          User firebaseUser = res;
          yield SignUpEmailCompletedState(firebaseUser);
        } else {
          yield SignUpEmailFailedState(res);
        }
      } catch (e) {
        print(e);
        yield SignUpEmailFailedState(e);
      }
  }

  Stream<SignInBlocState> mapSaveToFirebaseToState({
    String name,
    String email,
    User firebaseUser,
    String loggedInVia,
  }) async* {
    yield SavingUserDb();
    try {
      UserModel user = await userDataRepository.saveToFirebase(
        firebaseUser.uid,
        name,
        email,
        firebaseUser.photoURL,
        '',
        
        loggedInVia,
      );

      if (user != null) {
        yield CompletedSavingToFirebase(user);
      } else {
        yield FailedSavingProcess();
      }
    } catch (e) {
      print(e);
      yield FailedSavingProcess();
    }
  }*/

  Stream<SignInBlocState> mapSignoutEventToState() async* {
  yield SignOutProgressState();
    try {
      bool isSignedOut = await authenticationRepository.signOutUser();
      if (isSignedOut) {
        yield SignoutCompletedState();
      } else {
        yield SignOutFailedState();
      }
    } catch (e) {
      print(e);
      yield SignOutFailedState();
    }
  }

  
}

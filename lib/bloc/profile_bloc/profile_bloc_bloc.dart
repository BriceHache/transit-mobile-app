import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ball_on_a_budget_planner/authentication_repository/user_data_repository.dart';
import 'package:ball_on_a_budget_planner/models/user.dart';
import 'package:meta/meta.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
   final UserDataRepository userDataRepository;
  ProfileBloc(this.userDataRepository) : super(null);

  @override
  Stream<ProfileBlocState> mapEventToState(
    ProfileBlocEvent event,
  ) async* {
    if (event is GetProfileDetailsEvent) {
      yield* mapGetProfileDetailsEventToState(
        uid: event.uid,
      );
    }
  }

  Stream<ProfileBlocState> mapGetProfileDetailsEventToState({String uid}) async* {
    yield GetProfileDetailsInProgressState();
    try {
      UserModel user = await userDataRepository.getUserProfile(uid);
      if (user != null) {
        yield GetProfileDetailsCompletedState(user);
      } else {
        yield GetProfileDetailsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetProfileDetailsFailedState();
    }
  }
}

part of 'profile_bloc_bloc.dart';

@immutable
abstract class ProfileBlocState {}

class ProfileBlocInitial extends ProfileBlocState {}

class GetProfileDetailsInProgressState extends ProfileBlocState {}

class GetProfileDetailsFailedState extends ProfileBlocState {
  @override
  String toString() => 'GetProfileDetailsFailedState';
}

class GetProfileDetailsCompletedState extends ProfileBlocState {
  final UserModel user;
  GetProfileDetailsCompletedState(this.user);
  @override
  String toString() => 'GetProfileDetailsCompletedState';
}
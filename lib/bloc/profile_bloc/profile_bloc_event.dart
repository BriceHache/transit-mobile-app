part of 'profile_bloc_bloc.dart';

@immutable
abstract class ProfileBlocEvent {}

class GetProfileDetailsEvent extends ProfileBlocEvent {
  final String uid;
  GetProfileDetailsEvent(this.uid);

  @override
  String toString() => 'GetProfileDetailsEvent';
}

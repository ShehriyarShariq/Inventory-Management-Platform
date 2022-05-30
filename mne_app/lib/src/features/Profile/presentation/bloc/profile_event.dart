part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final Function eventFunc;

  LoadProfileEvent({required this.eventFunc}) : super([eventFunc]);
}

class SaveProfileImageEvent extends ProfileEvent {
  final Function eventFunc;

  SaveProfileImageEvent({required this.eventFunc}) : super([eventFunc]);
}

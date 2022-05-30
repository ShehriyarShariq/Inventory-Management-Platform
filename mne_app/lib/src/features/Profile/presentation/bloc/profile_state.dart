part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends ProfileState {}

class Loading extends ProfileState {}

class Loaded extends ProfileState {
  final Profile profile;

  Loaded({required this.profile}) : super([profile]);
}

class Error extends ProfileState {}

class Saving extends ProfileState {}

class Saved extends ProfileState {}

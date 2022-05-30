part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends HomeState {}

class Loading extends HomeState {}

class Loaded extends HomeState {
  final Map<String, String> basicProfile;
  final String entriesCount;

  Loaded({required this.basicProfile, required this.entriesCount})
      : super([basicProfile, entriesCount]);
}

class ProfileLoadError extends HomeState {}

class EntriesCountLoadError extends HomeState {}

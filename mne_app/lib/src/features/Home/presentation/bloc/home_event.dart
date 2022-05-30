part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadHomeInitialEvent extends HomeEvent {
  final Function profileFunc;
  final Function countFunc;

  LoadHomeInitialEvent({
    required this.profileFunc,
    required this.countFunc,
  }) : super([profileFunc, countFunc]);
}

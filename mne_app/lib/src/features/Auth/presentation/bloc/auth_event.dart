part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoginWithCredentialsEvent extends AuthEvent {
  final Function func;

  LoginWithCredentialsEvent({required this.func}) : super([func]);
}

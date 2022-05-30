part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends AuthState {}

class LoggingIn extends AuthState {}

class LoggedIn extends AuthState {}

class Error extends AuthState {
  final String errorMessage;

  Error(this.errorMessage) : super([errorMessage]);
}

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class AuthFailure extends Failure {}

class DBLoadFailure extends Failure {}

class DBSaveFailure extends Failure {}

class NetworkFailure extends Failure {}

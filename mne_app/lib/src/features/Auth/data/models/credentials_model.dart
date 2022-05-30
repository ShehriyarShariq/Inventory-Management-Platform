import 'package:equatable/equatable.dart';

class CredentialsModel extends Equatable {
  final String email, password;

  const CredentialsModel({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

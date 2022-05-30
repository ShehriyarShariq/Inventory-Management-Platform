import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/credentials_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> signInWithCredentials(
      CredentialsModel credentials);
  Future<Either<Failure, bool>> logoutUser();
}

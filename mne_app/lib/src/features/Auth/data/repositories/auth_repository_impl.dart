import '../../../../core/network/network_info.dart';
import '../../../../core/utils/firebase.dart';
import '../models/credentials_model.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/respositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, bool>> signInWithCredentials(
      CredentialsModel credentials) async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseInit.auth.signInWithEmailAndPassword(
            email: credentials.email, password: credentials.password);

        return Right(FirebaseInit.auth.currentUser != null);
      } catch (e) {
        return Left(AuthFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    try {
      await FirebaseInit.auth.signOut();

      return Right(FirebaseInit.auth.currentUser == null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}

import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/firebase.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, String>> getEntryCount() async {
    try {
      String entriesCount = await FirebaseInit.dbRef
          .collection("entries")
          .where("user_id", isEqualTo: FirebaseInit.auth.currentUser?.uid)
          .get()
          .then((value) => "${value.size}");

      return Right(entriesCount);
    } catch (e) {
      return const Right("0");
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getNameAndProfileImg() async {
    try {
      Map<String, String> basicProfile = await FirebaseInit.dbRef
          .collection("users")
          .doc(FirebaseInit.auth.currentUser?.uid)
          .get()
          .then((value) => {
                "name": value['name'],
                'profileImg': value.data()!.containsKey('profileImg')
                    ? value['profileImg']
                    : ""
              });

      return Right(basicProfile);
    } catch (e) {
      return Left(DBLoadFailure());
    }
  }
}

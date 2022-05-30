import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/firebase.dart';
import '../models/chilli.dart';
import '../models/entry.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/party.dart';
import '../../domain/entry_repository.dart';

class EntryRepositoryImpl extends EntryRepository {
  final NetworkInfo networkInfo;

  EntryRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, List<Chilli>>> getChillies() async {
    List<Chilli> chillies = [];

    try {
      await FirebaseInit.dbRef
          .collection("chillies")
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((chilli) {
          chillies.add(Chilli(
            id: chilli.id,
            label: chilli['label'],
          ));
        });
      });

      return Right(chillies);
    } catch (e) {
      print(e);
      return Left(DBLoadFailure());
    }
  }

  @override
  Future<Either<Failure, List<Party>>> getParties() async {
    List<Party> parties = [];

    try {
      await FirebaseInit.dbRef
          .collection("parties")
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((party) {
          parties.add(Party(
            id: party.id,
            name: party['name'],
          ));
        });
      });

      return Right(parties);
    } catch (e) {
      print(e);
      return Left(DBLoadFailure());
    }
  }

  @override
  Future<Either<Failure, num>> getSerialNum() async {
    try {
      num _serialNum = 1;
      await FirebaseInit.dbRef
          .collection("entries")
          .where("user_id", isEqualTo: FirebaseInit.auth.currentUser?.uid)
          .orderBy("date", descending: true)
          .limit(1)
          .get()
          .then(
            (value) => value.docs.forEach(
              (element) {
                _serialNum = element['serialNum'] + element['bagCount'];
              },
            ),
          );
      return Right(_serialNum);
    } catch (e) {
      print(e);
      return const Right(1);
    }
  }

  @override
  Future<Either<Failure, String>> saveEntry({required Entry entry}) async {
    if (await networkInfo.isConnected) {
      try {
        String entryId = entry.id;
        if (entry.id == "") {
          entryId = await FirebaseInit.dbRef
              .collection("entries")
              .add(entry.toJson())
              .then((value) => value.id);
        } else {
          await FirebaseInit.dbRef
              .collection("entries")
              .doc(entryId)
              .set(entry.toJson());
        }

        return Right(entryId);
      } catch (e) {
        return Left(DBSaveFailure());
      }
    } else {
      try {
        var entryRef = entry.id == ""
            ? FirebaseInit.dbRef.collection("entries").doc()
            : FirebaseInit.dbRef.collection("entries").doc(entry.id);
        entryRef.set(entry.toJson());

        return Right(entry.id == "" ? entryRef.id : "");
      } catch (e) {
        return Left(DBSaveFailure());
      }
    }
  }
}

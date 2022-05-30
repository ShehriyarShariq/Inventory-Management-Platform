import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mne_app/src/core/network/network_info.dart';
import 'package:mne_app/src/core/utils/firebase.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/chilli.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:mne_app/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/party.dart';
import 'package:mne_app/src/features/Entries/domain/repositories/entries_repository.dart';

class EntriesRepositoryImpl extends EntriesRepository {
  final NetworkInfo networkInfo;

  EntriesRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, List<Entry>>> getEntries() async {
    try {
      Map<String, Chilli> chillies = {};
      await FirebaseInit.dbRef
          .collection("chillies")
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((chilli) {
          chillies[chilli.id] = Chilli(
            id: chilli.id,
            label: chilli['label'],
          );
        });
      });

      Map<String, Party> parties = {};
      await FirebaseInit.dbRef
          .collection("parties")
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((party) {
          parties[party.id] = Party(
            id: party.id,
            name: party['name'],
          );
        });
      });

      List<Entry> entries = [];
      await FirebaseInit.dbRef
          .collection("entries")
          .where("user_id", isEqualTo: FirebaseInit.auth.currentUser?.uid)
          .get()
          .then((QuerySnapshot value) {
        value.docs.forEach((entry) {
          Map<String, dynamic> entryObj = entry.data() as Map<String, dynamic>;
          entryObj['id'] = entry.id;
          entryObj['party'] = parties[entryObj['party_id']];
          entryObj['chilli'] = chillies[entryObj['mark_id']];
          entries.add(Entry.fromJson(entryObj));
        });
      });

      entries.sort((a, b) => a.date.compareTo(b.date));
      entries = List.from(entries.reversed);

      return Right(entries);
    } catch (e) {
      print(e);
      return Left(DBLoadFailure());
    }
  }
}

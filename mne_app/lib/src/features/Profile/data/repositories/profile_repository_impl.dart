import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mne_app/src/core/network/network_info.dart';
import 'package:mne_app/src/core/utils/firebase.dart';
import 'package:mne_app/src/features/Profile/data/models/profile.dart';
import 'package:mne_app/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mne_app/src/features/Profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      Profile profile = await FirebaseInit.dbRef
          .collection("users")
          .doc(FirebaseInit.auth.currentUser?.uid)
          .get()
          .then(
            (value) => Profile(
              name: value['name'],
              email: value['email'],
              phoneNum: value['mobileNum'],
              gender: value['gender'],
              dob: DateTime.parse(value['dob']),
              profileImg: value.data()!.containsKey('profileImg')
                  ? value['profileImg']
                  : "",
            ),
          );

      return Right(profile);
    } catch (e) {
      print(e);
      return Left(DBLoadFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> uploadProfileImage(
      {required File imageFile}) async {
    if (await networkInfo.isConnected) {
      try {
        UploadTask imageUploadTask = FirebaseInit.storageRef
            .child(
                "${FirebaseInit.auth.currentUser?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg")
            .putFile(imageFile);
        String imageDownloadUrl =
            await imageUploadTask.then((res) => res.ref.getDownloadURL());

        await FirebaseInit.dbRef
            .collection("users")
            .doc(FirebaseInit.auth.currentUser?.uid)
            .update({"profileImg": imageDownloadUrl});

        await FirebaseInit.auth.currentUser!.updatePhotoURL(imageDownloadUrl);

        return Right(true);
      } catch (e) {
        return Left(DBSaveFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

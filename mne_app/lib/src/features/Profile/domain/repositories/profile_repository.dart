import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mne_app/src/core/error/failures.dart';
import 'package:mne_app/src/features/Profile/data/models/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, bool>> uploadProfileImage({required File imageFile});
}

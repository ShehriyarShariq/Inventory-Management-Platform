import 'package:dartz/dartz.dart';
import 'package:mne_app/src/core/error/failures.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/chilli.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/party.dart';

abstract class ReportsRepository {
  Future<Either<Failure, Map<String, dynamic>>> getData();
}

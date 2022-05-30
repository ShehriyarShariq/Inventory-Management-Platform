import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../AddEditEntry/data/models/entry.dart';

abstract class EntriesRepository {
  Future<Either<Failure, List<Entry>>> getEntries();
}

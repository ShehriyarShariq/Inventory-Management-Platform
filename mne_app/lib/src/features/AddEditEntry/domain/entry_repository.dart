import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../data/models/chilli.dart';
import '../data/models/entry.dart';
import '../data/models/party.dart';

abstract class EntryRepository {
  Future<Either<Failure, List<Party>>> getParties();
  Future<Either<Failure, List<Chilli>>> getChillies();
  Future<Either<Failure, num>> getSerialNum();
  Future<Either<Failure, String>> saveEntry({required Entry entry});
}

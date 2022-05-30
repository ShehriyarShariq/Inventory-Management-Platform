part of 'entry_bloc.dart';

abstract class EntryState extends Equatable {
  const EntryState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends EntryState {}

class LoadingEntryBasicData extends EntryState {}

class LoadedEntryBasicData extends EntryState {
  final List<Party> parties;
  final List<Chilli> chillies;
  final num startingSerialNum;

  LoadedEntryBasicData({
    required this.chillies,
    required this.parties,
    required this.startingSerialNum,
  }) : super([chillies, parties, startingSerialNum]);
}

class Saving extends EntryState {}

class PartialSaved extends EntryState {
  final String id;

  PartialSaved({required this.id}) : super([id]);
}

class Saved extends EntryState {}

class Error extends EntryState {
  final String errorMessage;

  Error(this.errorMessage) : super([errorMessage]);
}

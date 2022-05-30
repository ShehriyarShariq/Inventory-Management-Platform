part of 'entries_bloc.dart';

abstract class EntriesEvent extends Equatable {
  const EntriesEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadUserEntriesEvent extends EntriesEvent {
  final Function func;

  LoadUserEntriesEvent({required this.func}) : super([func]);
}

class GetFilteredEntriesEvent extends EntriesEvent {
  final List<Entry> allEntries;
  final String fromDate, toDate;

  GetFilteredEntriesEvent({
    required this.allEntries,
    required this.fromDate,
    required this.toDate,
  }) : super([allEntries, fromDate, toDate]);
}

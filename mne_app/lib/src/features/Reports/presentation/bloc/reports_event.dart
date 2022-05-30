part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadBasicDataEvent extends ReportsEvent {
  final Function eventFunc;

  LoadBasicDataEvent({
    required this.eventFunc,
  }) : super([eventFunc]);
}

class GetFilteredEntriesEvent extends ReportsEvent {
  final List<Entry> allEntries;
  final Party selectedParty;
  final Chilli selectedChilli;
  final String fromDate, toDate;

  GetFilteredEntriesEvent({
    required this.allEntries,
    required this.selectedParty,
    required this.selectedChilli,
    required this.fromDate,
    required this.toDate,
  }) : super([allEntries, selectedParty, selectedChilli, fromDate, toDate]);
}

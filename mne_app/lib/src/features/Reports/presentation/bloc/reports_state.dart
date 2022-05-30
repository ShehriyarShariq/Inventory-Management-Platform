part of 'reports_bloc.dart';

abstract class ReportsState extends Equatable {
  const ReportsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends ReportsState {}

class Loading extends ReportsState {}

class Loaded extends ReportsState {
  final List<Chilli> chillies;
  final List<Party> parties;
  final List<Entry> entries;

  Loaded({required this.chillies, required this.parties, required this.entries})
      : super([chillies, parties, entries]);
}

class Searching extends ReportsState {}

class SearchResults extends ReportsState {
  final List<Entry> queriedEntries;

  SearchResults({required this.queriedEntries}) : super([queriedEntries]);
}

class Error extends ReportsState {}

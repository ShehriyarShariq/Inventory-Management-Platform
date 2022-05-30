part of 'entries_bloc.dart';

abstract class EntriesState extends Equatable {
  const EntriesState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class Initial extends EntriesState {}

class Loading extends EntriesState {}

class Loaded extends EntriesState {
  final List<Entry> entries;

  Loaded({required this.entries}) : super([entries]);
}

class Searching extends EntriesState {}

class SearchResults extends EntriesState {
  final List<Entry> queriedEntries;

  SearchResults({required this.queriedEntries}) : super([queriedEntries]);
}

class Error extends EntriesState {}

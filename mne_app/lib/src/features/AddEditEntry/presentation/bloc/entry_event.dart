part of 'entry_bloc.dart';

abstract class EntryEvent extends Equatable {
  const EntryEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class LoadEntryBasicDataEvent extends EntryEvent {
  final Function chilliesFunc, partiesFunc, serialNumFunc;

  LoadEntryBasicDataEvent({
    required this.chilliesFunc,
    required this.partiesFunc,
    required this.serialNumFunc,
  }) : super([chilliesFunc, partiesFunc, serialNumFunc]);
}

class InitEntrySaveEvent extends EntryEvent {
  final Function saveFunc;
  final bool isFinalSave;

  InitEntrySaveEvent({
    required this.saveFunc,
    this.isFinalSave = false,
  }) : super([saveFunc, isFinalSave]);
}

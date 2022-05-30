import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/chilli.dart';
import '../../data/models/entry.dart';
import '../../data/models/party.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  EntryBloc() : super(Initial()) {
    on<LoadEntryBasicDataEvent>((event, emit) async {
      emit(LoadingEntryBasicData());

      final failureOrChillies = await event.chilliesFunc();
      final failureOrParties = await event.partiesFunc();
      final failureOrSerialNum = await event.serialNumFunc();

      failureOrChillies.fold(
        (failure) => emit(Error("Failed to load chillies!")),
        (chillies) => (failureOrParties.fold(
          (failure) => emit(Error("Failed to load parties!")),
          (parties) => (failureOrSerialNum.fold(
            (failure) => emit(Error("Failed to load serial num!")),
            (serialNum) => emit(
              LoadedEntryBasicData(
                chillies: chillies,
                parties: parties,
                startingSerialNum: serialNum,
              ),
            ),
          )),
        )),
      );
    });

    on<InitEntrySaveEvent>((event, emit) async {
      emit(Saving());

      final failureOrSaved = await event.saveFunc();

      failureOrSaved.fold(
        (failure) => emit(Error("Failed to save entry!")),
        (entryId) =>
            emit(!event.isFinalSave ? PartialSaved(id: entryId) : Saved()),
      );
    });
  }
}

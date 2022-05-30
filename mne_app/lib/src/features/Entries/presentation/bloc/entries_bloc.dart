import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:intl/intl.dart';

part 'entries_event.dart';
part 'entries_state.dart';

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  EntriesBloc() : super(Initial()) {
    on<LoadUserEntriesEvent>((event, emit) async {
      emit(Loading());
      final failureOrEntries = await event.func();
      failureOrEntries.fold(
        (failure) => emit(Error()),
        (entries) => emit(Loaded(entries: entries)),
      );
    });

    on<GetFilteredEntriesEvent>((event, emit) {
      emit(Searching());

      List<Entry> filteredEntries = [];

      List<Map<String, dynamic>> checkFor = [];

      if (event.fromDate != "None") {
        checkFor.add({
          "type": "from_date",
          "value": DateFormat("dd/MM/yyyy").parse(event.fromDate)
        });
      }

      if (event.toDate != "None") {
        DateTime toDateCheckFor = DateFormat("dd/MM/yyyy").parse(event.toDate);

        toDateCheckFor = toDateCheckFor
            .add(const Duration(hours: 23, minutes: 59, seconds: 59));

        checkFor.add({
          "type": "to_date",
          "value": toDateCheckFor,
        });
      }

      for (Entry entry in event.allEntries) {
        bool isValid = true;
        for (int i = 0; i < checkFor.length; i++) {
          String type = checkFor[i]['type'];
          if (type == "from_date" &&
              entry.date.compareTo(checkFor[i]['value'] as DateTime) == -1) {
            isValid = false;
            break;
          } else if (type == "to_date" &&
              entry.date.compareTo(checkFor[i]['value'] as DateTime) == 1) {
            isValid = false;
            break;
          }
        }

        if (isValid) {
          filteredEntries.add(entry);
        }
      }

      emit(SearchResults(queriedEntries: filteredEntries));
    });
  }
}

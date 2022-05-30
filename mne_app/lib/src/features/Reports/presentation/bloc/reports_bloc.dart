import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/chilli.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/party.dart';
import 'package:intl/intl.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc() : super(Initial()) {
    on<LoadBasicDataEvent>((event, emit) async {
      emit(Loading());

      final failureOrData = await event.eventFunc();

      failureOrData.fold(
        (failure) => emit(Error()),
        (data) => emit(
          Loaded(
            chillies: data['chilli'] as List<Chilli>,
            parties: data['party'] as List<Party>,
            entries: data['entry'] as List<Entry>,
          ),
        ),
      );
    });

    on<GetFilteredEntriesEvent>((event, emit) {
      emit(Searching());

      List<Entry> filteredEntries = [];

      List<Map<String, dynamic>> checkFor = [];

      String selectedPartyName = event.selectedParty.name.toLowerCase();
      String selectedChilliLabel = event.selectedChilli.label.toLowerCase();

      if (event.selectedParty.name != "None") {
        checkFor.add({"type": "party", "value": selectedPartyName});
      }

      if (event.selectedChilli.label != "None") {
        checkFor.add({"type": "chilli", "value": selectedChilliLabel});
      }

      if (event.fromDate != "None") {
        checkFor.add({
          "type": "from_date",
          "value": DateFormat("dd/MM/yyyy").parse(event.fromDate)
        });
      }

      if (event.toDate != "None") {
        DateTime toDateCheckFor = DateFormat("dd/MM/yyyy").parse(event.toDate);

        toDateCheckFor =
            toDateCheckFor.add(Duration(hours: 23, minutes: 59, seconds: 59));

        checkFor.add({
          "type": "to_date",
          "value": toDateCheckFor,
        });
      }

      for (Entry entry in event.allEntries) {
        String partyName = entry.party.name.toLowerCase();
        String chilliName = entry.chilli.label.toLowerCase();

        bool isValid = true;
        for (int i = 0; i < checkFor.length; i++) {
          String type = checkFor[i]['type'];
          if (type == "party" && !partyName.contains(checkFor[i]['value'])) {
            isValid = false;
            break;
          } else if (type == "chill" &&
              !chilliName.contains(checkFor[i]['value'])) {
            isValid = false;
            break;
          } else if (type == "from_date" &&
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

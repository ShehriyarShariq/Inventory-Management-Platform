import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:mne_app/src/features/AddEditEntry/presentation/widgets/entry_input_field_widget.dart';
import 'package:mne_app/src/features/Entries/domain/repositories/entries_repository.dart';
import 'package:mne_app/src/features/Entries/presentation/bloc/entries_bloc.dart';
import '../../../../../injection_container.dart';
import '../../../../core/ui/top_bar_widget.dart';
import '../widgets/entry_item_widget.dart';
import '../widgets/search_bar_widget.dart';
import 'package:intl/intl.dart';

class MyEntriesScreen extends StatefulWidget {
  const MyEntriesScreen({Key? key}) : super(key: key);

  @override
  _MyEntriesScreenState createState() => _MyEntriesScreenState();
}

class _MyEntriesScreenState extends State<MyEntriesScreen> {
  late EntriesBloc _entriesBloc;

  List<Entry> _entries = [];

  late TextEditingController _searchController,
      _filterFromDateController,
      _filterToDateController;

  String _searchTerm = "";

  bool _isFiltersVisible = false;

  String _fromDate = "None", _toDate = "None";
  List<String> _selectedDayFilters = [];

  @override
  void initState() {
    super.initState();
    _entriesBloc = sl<EntriesBloc>();

    _entriesBloc.add(
      LoadUserEntriesEvent(
        func: () => sl<EntriesRepository>().getEntries(),
      ),
    );

    _searchController = TextEditingController();
    _filterFromDateController = TextEditingController(text: "None");
    _filterToDateController = TextEditingController(text: "None");

    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _selectDate(
    BuildContext context, {
    bool isFromDate = true,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    DateTime selectedDate = isFromDate
        ? _fromDate != "None"
            ? DateFormat("dd/MM/yyyy").parse(_fromDate)
            : DateTime(2021)
        : _toDate != "None"
            ? DateFormat("dd/MM/yyyy").parse(_toDate)
            : DateTime(2101);
    if (picked != null && picked != selectedDate) {
      if (isFromDate) {
        _filterFromDateController.text =
            DateFormat("dd/MM/yyyy").format(picked);
      } else {
        _filterToDateController.text = DateFormat("dd/MM/yyyy").format(picked);
      }

      setState(() {
        if (isFromDate) {
          _fromDate = DateFormat("dd/MM/yyyy").format(picked);
        } else {
          _toDate = DateFormat("dd/MM/yyyy").format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBarWidget(
          isBack: true,
          title: "My Entries",
          onClick: () => Navigator.pop(context),
        ),
        body: SafeArea(
          bottom: false,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(height: 15),
                SearchBarWidget(
                  controller: _searchController,
                  hasFilterBtn: true,
                  isFilterVisible: _isFiltersVisible,
                  showFilters: () {
                    setState(() {
                      _isFiltersVisible = !_isFiltersVisible;
                    });
                  },
                ),
                // const SizedBox(height: 35),
                _isFiltersVisible
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 25,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(102, 102, 102, 1),
                          ),
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width *
                                0.9 *
                                0.14 *
                                0.3,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  EntryInputFieldWidget(
                                    label: "FROM DATE",
                                    controller: _filterFromDateController,
                                    isDisabled: true,
                                    onClick: () => _selectDate(context),
                                  ),
                                  EntryInputFieldWidget(
                                    label: "TO DATE",
                                    controller: _filterToDateController,
                                    isDisabled: true,
                                    onClick: () =>
                                        _selectDate(context, isFromDate: false),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        side: const BorderSide(
                                          color:
                                              Color.fromRGBO(102, 102, 102, 1),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.9 *
                                                0.14 *
                                                0.3,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _filterFromDateController.text = "None";
                                        _filterToDateController.text = "None";

                                        setState(() {
                                          _fromDate = "None";
                                          _toDate = "None";
                                          _isFiltersVisible = false;
                                        });

                                        _entriesBloc.add(
                                          GetFilteredEntriesEvent(
                                              allEntries: _entries,
                                              fromDate: "None",
                                              toDate: "None"),
                                        );
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "Reset",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.orange,
                                        side: const BorderSide(
                                          color:
                                              Color.fromRGBO(102, 102, 102, 1),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.9 *
                                                0.14 *
                                                0.3,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isFiltersVisible = false;
                                        });

                                        _entriesBloc.add(
                                          GetFilteredEntriesEvent(
                                            allEntries: _entries,
                                            fromDate: _fromDate,
                                            toDate: _toDate,
                                          ),
                                        );
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                          child: Text(
                                            "Apply",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(height: 15),
                Expanded(
                  child: BlocBuilder<EntriesBloc, EntriesState>(
                    bloc: _entriesBloc,
                    builder: (context, state) {
                      List<Entry> filteredEntries = [];
                      if (state is Loading) {
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: const CircularProgressIndicator(
                              color: Color.fromRGBO(255, 154, 62, 1),
                            ),
                          ),
                        );
                      } else if (state is Error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Try Again!",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                _entriesBloc.add(
                                  LoadUserEntriesEvent(
                                    func: () =>
                                        sl<EntriesRepository>().getEntries(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(255, 154, 62, 1),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12.5,
                                ),
                                child: Text(
                                  "Reload",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        if (state is Loaded) {
                          _entries = state.entries;

                          filteredEntries = _entries
                              .where((entry) =>
                                  entry.chilli.label
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchTerm) ||
                                  entry.party.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchTerm))
                              .toList();
                        } else if (state is SearchResults) {
                          filteredEntries = state.queriedEntries
                              .where((entry) =>
                                  entry.chilli.label
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchTerm) ||
                                  entry.party.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchTerm))
                              .toList();
                        }
                      }

                      return filteredEntries.isNotEmpty
                          ? SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Column(
                                  children: filteredEntries
                                      .map(
                                        (entry) => EntryItemWidget(
                                          entry: entry,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.EDIT_ENTRY,
                                              arguments: entry,
                                            ).then(
                                              (value) {
                                                _entriesBloc.add(
                                                  LoadUserEntriesEvent(
                                                    func: () =>
                                                        sl<EntriesRepository>()
                                                            .getEntries(),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                "No Entries Found!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45,
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mne_app/src/core/ui/overlay_widget.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/chilli.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/party.dart';
import 'package:mne_app/src/features/AddEditEntry/presentation/widgets/entry_dropdown_field_widget.dart';
import 'package:mne_app/src/features/AddEditEntry/presentation/widgets/entry_input_field_widget.dart';
import 'package:mne_app/src/features/Reports/domain/repositories/report_repository.dart';
import 'package:mne_app/src/features/Reports/presentation/bloc/reports_bloc.dart';
import 'package:mne_app/src/features/Reports/presentation/widgets/day_filter_widget.dart';
import '../../../../../injection_container.dart';
import '../../../../core/ui/top_bar_widget.dart';
import '../../../Entries/presentation/widgets/entry_item_widget.dart';
import '../../../Entries/presentation/widgets/search_bar_widget.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ReportsBloc _reportsBloc;

  late TextEditingController _searchController,
      _filterFromDateController,
      _filterToDateController;

  String _searchTerm = "";

  bool _isFiltersVisible = false;

  Party _selectedPartyForFilter = const Party(id: "", name: "None");
  Chilli _selectedChilliForFilter = const Chilli(id: "", label: "None");
  String _fromDate = "None", _toDate = "None";
  List<String> _selectedDayFilters = [];

  List<Chilli> _chillies = [];
  List<Party> _parties = [];

  List<Entry> _entries = [], _filteredEntries = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _reportsBloc = sl<ReportsBloc>();

    _reportsBloc.add(
      LoadBasicDataEvent(
        eventFunc: () => sl<ReportsRepository>().getData(),
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

  bool areSameDates(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
    return BlocListener<ReportsBloc, ReportsState>(
      bloc: _reportsBloc,
      listener: (context, state) {
        if (state is Loading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is Loaded) {
          setState(() {
            _isLoading = false;
            _parties = [const Party(id: "", name: "None"), ...state.parties];
            _chillies = [
              const Chilli(id: "", label: "None"),
              ...state.chillies
            ];
            _entries = state.entries;
            _filteredEntries = state.entries;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TopBarWidget(
          isBack: true,
          title: "Reports",
          onClick: () => Navigator.pop(context),
          isDisabled: _isLoading,
        ),
        body: Stack(
          children: [
            SafeArea(
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
                                EntryDropdownFieldWidget(
                                  label: "PARTY NAME",
                                  isBig: true,
                                  type: "party",
                                  dropdownOptions: _parties,
                                  selectedDropdownOption:
                                      _selectedPartyForFilter,
                                  onDropdownOptionChanged: (value) {
                                    setState(() {
                                      _selectedPartyForFilter = value;
                                    });
                                  },
                                ),
                                EntryDropdownFieldWidget(
                                  label: "CHILLI",
                                  isBig: true,
                                  type: "chilli",
                                  dropdownOptions: _chillies,
                                  selectedDropdownOption:
                                      _selectedChilliForFilter,
                                  onDropdownOptionChanged: (value) {
                                    setState(() {
                                      _selectedChilliForFilter = value;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.025,
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
                                        onClick: () => _selectDate(context,
                                            isFromDate: false),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  102, 102, 102, 1),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9 *
                                                    0.14 *
                                                    0.3,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            _filterFromDateController.text =
                                                "None";
                                            _filterToDateController.text =
                                                "None";

                                            setState(() {
                                              _selectedPartyForFilter =
                                                  const Party(
                                                      id: "", name: "None");
                                              _selectedChilliForFilter =
                                                  const Chilli(
                                                id: "",
                                                label: "None",
                                              );
                                              _fromDate = "None";
                                              _toDate = "None";
                                              _isFiltersVisible = false;
                                            });

                                            _reportsBloc.add(
                                              GetFilteredEntriesEvent(
                                                  allEntries: _entries,
                                                  selectedParty: const Party(
                                                      id: "", name: "None"),
                                                  selectedChilli: const Chilli(
                                                    id: "",
                                                    label: "None",
                                                  ),
                                                  fromDate: "None",
                                                  toDate: "None"),
                                            );
                                          },
                                          child: const SizedBox(
                                            height: 50,
                                            child: Center(
                                              child: Text(
                                                "Reset",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              color: Color.fromRGBO(
                                                  102, 102, 102, 1),
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
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

                                            _reportsBloc.add(
                                              GetFilteredEntriesEvent(
                                                allEntries: _entries,
                                                selectedParty:
                                                    _selectedPartyForFilter,
                                                selectedChilli:
                                                    _selectedChilliForFilter,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DayFilterWidget(
                            label: "Today",
                            isActive: _selectedDayFilters.contains("Today"),
                            onClick: () {
                              List<String> tempSelectedDayFilters = [
                                ..._selectedDayFilters
                              ];
                              if (tempSelectedDayFilters.contains("Today")) {
                                tempSelectedDayFilters.remove("Today");
                              } else {
                                tempSelectedDayFilters.add("Today");
                              }

                              setState(() {
                                _selectedDayFilters = tempSelectedDayFilters;
                              });
                            },
                          ),
                          DayFilterWidget(
                            label: "Yesterday",
                            isActive: _selectedDayFilters.contains("Yesterday"),
                            onClick: () {
                              List<String> tempSelectedDayFilters = [
                                ..._selectedDayFilters
                              ];
                              if (tempSelectedDayFilters
                                  .contains("Yesterday")) {
                                tempSelectedDayFilters.remove("Yesterday");
                              } else {
                                tempSelectedDayFilters.add("Yesterday");
                              }

                              setState(() {
                                _selectedDayFilters = tempSelectedDayFilters;
                              });
                            },
                          ),
                          DayFilterWidget(
                            label: "This Month",
                            isActive: _selectedDayFilters.contains("Month"),
                            onClick: () {
                              List<String> tempSelectedDayFilters = [
                                ..._selectedDayFilters
                              ];
                              if (tempSelectedDayFilters.contains("Month")) {
                                tempSelectedDayFilters.remove("Month");
                              } else {
                                tempSelectedDayFilters.add("Month");
                              }

                              setState(() {
                                _selectedDayFilters = tempSelectedDayFilters;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: BlocBuilder<ReportsBloc, ReportsState>(
                        bloc: _reportsBloc,
                        builder: (context, state) {
                          if (state is Error) {
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
                                    _reportsBloc.add(
                                      LoadBasicDataEvent(
                                        eventFunc: () =>
                                            sl<ReportsRepository>().getData(),
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
                          } else if (state is SearchResults) {
                            _filteredEntries = state.queriedEntries;
                          }

                          _filteredEntries = (state is SearchResults
                                  ? _filteredEntries
                                  : _entries)
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

                          if (_selectedDayFilters.isNotEmpty) {
                            List<Entry> dayFilteredEntries = [];

                            for (String dayFilter in _selectedDayFilters) {
                              if (dayFilter != "Month") {
                                DateTime checkFor = dayFilter == "Today"
                                    ? DateTime.now()
                                    : DateTime.now().add(Duration(days: -1));
                                for (Entry entry in _filteredEntries) {
                                  if (areSameDates(entry.date, checkFor)) {
                                    dayFilteredEntries.add(entry);
                                  }
                                }
                              } else {
                                DateTime today = DateTime.now();
                                DateTime monthStart =
                                    DateTime(today.year, today.month, 1);
                                DateTime monthEnd =
                                    DateTime(today.year, today.month + 1, 1);
                                for (Entry entry in _filteredEntries) {
                                  if (monthStart.compareTo(entry.date) != 1 &&
                                      monthEnd.compareTo(entry.date) == 1) {
                                    dayFilteredEntries.add(entry);
                                  }
                                }
                              }
                            }

                            _filteredEntries = dayFilteredEntries;
                          }

                          return _filteredEntries.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      children: _filteredEntries
                                          .map(
                                            (entry) => EntryItemWidget(
                                              entry: entry,
                                              isViewOnly: true,
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  Routes.VIEW_ENTRY,
                                                  arguments: entry,
                                                ).then(
                                                  (value) {
                                                    _reportsBloc.add(
                                                      LoadBasicDataEvent(
                                                        eventFunc: () =>
                                                            sl<ReportsRepository>()
                                                                .getData(),
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
                              : const Center(
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
            _isLoading
                ? const Positioned(
                    child: OverlayWidget(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

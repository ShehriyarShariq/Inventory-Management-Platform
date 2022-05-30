import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import '../../../../../injection_container.dart';
import '../../../../core/ui/action_button_widget.dart';
import '../../../../core/ui/overlay_widget.dart';
import '../../../../core/ui/top_bar_widget.dart';
import '../../data/models/chilli.dart';
import '../../data/models/entry.dart';
import '../../data/models/party.dart';
import '../../domain/entry_repository.dart';
import '../bloc/entry_bloc.dart';
import '../widgets/entry_dropdown_field_widget.dart';
import '../widgets/entry_input_field_widget.dart';
import 'package:intl/intl.dart';

class AddEditEntryScreen extends StatefulWidget {
  const AddEditEntryScreen({Key? key}) : super(key: key);

  @override
  _AddEditEntryScreenState createState() => _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends State<AddEditEntryScreen> {
  // Entry existingEntry = Entry.empty(date: DateTime(2000));

  late EntryBloc _entryBloc;
  bool _isLoading = false, _isSaving = false;

  List<Chilli> _chillies = [];
  List<Party> _parties = [];
  Chilli _selectedChilli = const Chilli(id: "", label: "");
  Party _selectedParty = const Party(id: "", name: "");
  num _startingSerialNum = 1;

  Entry _currentEntry = Entry.empty(date: DateTime(2000));
  Entry emptyEntry = Entry.empty(date: DateTime(2000));

  TextEditingController _dateController = TextEditingController(),
      _bagCountController = TextEditingController(),
      _serialNumController = TextEditingController(),
      _rateController = TextEditingController(),
      _totalWeightController = TextEditingController(),
      _lessTareController = TextEditingController(),
      _netWeightController = TextEditingController();

  List<TextEditingController> _bagsTextControllers = [];

  @override
  void initState() {
    super.initState();

    _entryBloc = sl<EntryBloc>();

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy, HH:mm ');
    final String formattedDateTime =
        formatter.format(now) + (now.hour > 12 ? "PM" : "AM");
    _dateController.text = formattedDateTime;
    _bagCountController.text = "1";

    _serialNumController.addListener(() {
      setState(() {
        _startingSerialNum = _serialNumController.text.isNotEmpty
            ? num.parse(_serialNumController.text)
            : 1;
      });
    });

    _entryBloc.add(LoadEntryBasicDataEvent(
      chilliesFunc: () => sl<EntryRepository>().getChillies(),
      partiesFunc: () => sl<EntryRepository>().getParties(),
      serialNumFunc: () => sl<EntryRepository>().getSerialNum(),
    ));
  }

  Entry _getInitialEntry() {
    num bagCount = _bagCountController.text.isNotEmpty
        ? num.parse(_bagCountController.text)
        : 0;
    num rate =
        _rateController.text.isNotEmpty ? num.parse(_rateController.text) : 0;
    List<Map<String, num>> bags = [];

    for (int i = 0; i < bagCount; i++) {
      bags.add({
        "serialNum": _startingSerialNum + i,
        "weight": 0,
      });
    }

    Entry entry = Entry.initial(
      id: _currentEntry != emptyEntry ? _currentEntry.id : "",
      date: DateFormat("dd/MM/yyyy, HH:mm").parse(_dateController.text),
      party: _selectedParty,
      chilli: _selectedChilli,
      bagCount: bagCount,
      rate: rate,
      serialNum: _startingSerialNum,
      bags: bags,
    );

    return entry;
  }

  Entry _getCurrentEntry() {
    List<Map<String, num>> bags = [];

    for (int i = 0; i < _bagsTextControllers.length; i++) {
      bags.add({
        "serialNum": _startingSerialNum + i,
        "weight": _bagsTextControllers[i].text.isNotEmpty
            ? num.parse(_bagsTextControllers[i].text)
            : 0,
      });
    }

    _currentEntry.bags = bags;
    _currentEntry.totalWeight = num.parse(_totalWeightController.text);
    _currentEntry.netWeight = num.parse(_netWeightController.text);

    return _currentEntry;
  }

  num _recalculateTotalWeight() {
    num weight = 0;
    for (int i = 0; i < _bagsTextControllers.length; i++) {
      weight += _bagsTextControllers[i].text.isNotEmpty
          ? num.parse(_bagsTextControllers[i].text)
          : 0;
    }
    return weight;
  }

  @override
  Widget build(BuildContext context) {
    if ((ModalRoute.of(context)!.settings.name == Routes.EDIT_ENTRY ||
            ModalRoute.of(context)!.settings.name == Routes.VIEW_ENTRY) &&
        _currentEntry == emptyEntry) {
      Entry tmpExistingEntry =
          ModalRoute.of(context)!.settings.arguments as Entry;

      _dateController.text =
          DateFormat('dd/MM/yyyy, HH:mm ').format(tmpExistingEntry.date) +
              (tmpExistingEntry.date.hour > 12 ? "PM" : "AM");
      _bagCountController.text = "${tmpExistingEntry.bagCount}";
      _serialNumController.text = "${tmpExistingEntry.serialNum}";
      _rateController.text = "${tmpExistingEntry.rate}";

      List<TextEditingController> _newBagsTextControllers = [];
      for (int i = 0; i < tmpExistingEntry.bagCount; i++) {
        TextEditingController weightController = TextEditingController(
            text: tmpExistingEntry.bags[i]['weight'].toString());

        weightController.addListener(() {
          num totalWeight = _recalculateTotalWeight();

          _totalWeightController.text = "$totalWeight";
          _lessTareController.text = "${_currentEntry.bagCount}";
          _netWeightController.text = "${totalWeight - _currentEntry.bagCount}";
        });

        _newBagsTextControllers.add(weightController);
      }

      _totalWeightController.text = "${tmpExistingEntry.totalWeight}";
      _lessTareController.text = "${tmpExistingEntry.bagCount}";
      _netWeightController.text = "${tmpExistingEntry.netWeight}";

      setState(() {
        _currentEntry = tmpExistingEntry;
        _selectedParty = tmpExistingEntry.party;
        _selectedChilli = tmpExistingEntry.chilli;
        _parties = [tmpExistingEntry.party];
        _chillies = [tmpExistingEntry.chilli];
        _startingSerialNum = tmpExistingEntry.serialNum;
        _bagsTextControllers = _newBagsTextControllers;
      });
    }
    // else if (ModalRoute.of(context)!.settings.name == Routes.NEW_ENTRY &&
    //     _parties.isEmpty) {
    //   _entryBloc.add(LoadEntryBasicDataEvent(
    //     chilliesFunc: () => sl<EntryRepository>().getChillies(),
    //     partiesFunc: () => sl<EntryRepository>().getParties(),
    //     serialNumFunc: () => sl<EntryRepository>().getSerialNum(),
    //   ));
    // }

    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).requestFocus(FocusNode());
      },
      child: BlocProvider(
        create: (context) => _entryBloc,
        child: BlocListener<EntryBloc, EntryState>(
          bloc: _entryBloc,
          listener: (context, state) {
            if (state is LoadingEntryBasicData) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is Saving) {
              setState(() {
                _isSaving = true;
              });
            } else if (state is LoadedEntryBasicData) {
              if (ModalRoute.of(context)!.settings.name == Routes.NEW_ENTRY &&
                  _parties.isEmpty) {
                _serialNumController.text = "${state.startingSerialNum}";

                setState(() {
                  _isLoading = false;
                  _chillies = state.chillies;
                  _parties = state.parties;
                  _selectedParty = state.parties[0];
                  _selectedChilli = state.chillies[0];
                  _startingSerialNum = state.startingSerialNum;
                });
              } else {
                setState(() {
                  _isLoading = false;
                  _chillies = state.chillies;
                  _parties = state.parties;
                });
              }
            } else if (state is PartialSaved) {
              Entry _initialEntry = _getInitialEntry();

              List<TextEditingController> _newBagsTextControllers = [];
              for (int i = 0; i < _initialEntry.bagCount; i++) {
                TextEditingController weightController =
                    TextEditingController();

                weightController.addListener(() {
                  num totalWeight = _recalculateTotalWeight();

                  _totalWeightController.text = "$totalWeight";
                  _lessTareController.text = "${_currentEntry.bagCount}";
                  _netWeightController.text =
                      "${totalWeight - _currentEntry.bagCount}";
                });

                _newBagsTextControllers.add(weightController);
              }

              _totalWeightController.text = "0";
              _lessTareController.text = "${_initialEntry.bagCount}";
              _netWeightController.text = "-${_initialEntry.bagCount}";

              _initialEntry.id = state.id;

              setState(() {
                _isSaving = false;
                _currentEntry = _initialEntry;
                _bagsTextControllers = _newBagsTextControllers;
              });
            } else if (state is Saved) {
              Navigator.pop(context);
            }
          },
          child: AbsorbPointer(
            absorbing: _isSaving,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: TopBarWidget(
                isBack: true,
                title:
                    ModalRoute.of(context)!.settings.name == Routes.VIEW_ENTRY
                        ? "Entries"
                        : "Enter Entries",
                onClick: () => Navigator.pop(context),
                isDisabled: _isLoading,
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            EntryInputFieldWidget(
                              label: "DATE",
                              isBig: true,
                              controller: _dateController,
                              iconType: "date",
                              isDisabled: true,
                              onClick: () {},
                            ),
                            EntryDropdownFieldWidget(
                              label: "PARTY NAME",
                              isBig: true,
                              type: "party",
                              dropdownOptions: _parties,
                              selectedDropdownOption: _selectedParty,
                              onDropdownOptionChanged: (value) {
                                setState(() {
                                  _selectedParty = value;
                                });
                              },
                              isDisabled:
                                  ModalRoute.of(context)!.settings.name ==
                                      Routes.VIEW_ENTRY,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  EntryDropdownFieldWidget(
                                    label: "MARK",
                                    type: "chilli",
                                    dropdownOptions: _chillies,
                                    selectedDropdownOption: _selectedChilli,
                                    onDropdownOptionChanged: (value) {
                                      setState(() {
                                        _selectedChilli = value;
                                      });
                                    },
                                    isDisabled:
                                        ModalRoute.of(context)!.settings.name ==
                                            Routes.VIEW_ENTRY,
                                  ),
                                  EntryInputFieldWidget(
                                    label: "NO. OF BAGS",
                                    controller: _bagCountController,
                                    inpType: TextInputType.number,
                                    onClick: () {},
                                    isDisabled:
                                        ModalRoute.of(context)!.settings.name ==
                                            Routes.VIEW_ENTRY,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  EntryInputFieldWidget(
                                    label: "S. NO.",
                                    controller: _serialNumController,
                                    inpType: TextInputType.number,
                                    onClick: () {},
                                    isDisabled:
                                        ModalRoute.of(context)!.settings.name ==
                                            Routes.VIEW_ENTRY,
                                  ),
                                  EntryInputFieldWidget(
                                    label: "RATE",
                                    controller: _rateController,
                                    inpType: TextInputType.number,
                                    onClick: () {},
                                    isDisabled:
                                        ModalRoute.of(context)!.settings.name ==
                                            Routes.VIEW_ENTRY,
                                  ),
                                ],
                              ),
                            ),
                            ActionButtonWidget(
                              label: "Save",
                              onClick: () {
                                if (_bagCountController.text.isNotEmpty &&
                                    _serialNumController.text.isNotEmpty &&
                                    _rateController.text.isNotEmpty) {
                                  _entryBloc.add(
                                    InitEntrySaveEvent(
                                      saveFunc: () =>
                                          sl<EntryRepository>().saveEntry(
                                        entry: _getInitialEntry(),
                                      ),
                                    ),
                                  );
                                }
                              },
                              widthPercen: 0.9,
                              isLoading: _isSaving,
                              isDisabled:
                                  ModalRoute.of(context)!.settings.name ==
                                      Routes.VIEW_ENTRY,
                            ),
                            const SizedBox(height: 25.0),
                            _bagsTextControllers.length > 0
                                ? Column(
                                    children: [
                                      Column(
                                        children: _bagsTextControllers
                                            .asMap()
                                            .entries
                                            .map(
                                              (entry) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    EntryInputFieldWidget(
                                                      label: "S. NO.",
                                                      hasLabel: entry.key +
                                                              _startingSerialNum ==
                                                          _startingSerialNum,
                                                      hasBottomGap: entry.key ==
                                                          _currentEntry
                                                                  .bagCount -
                                                              1,
                                                      inpType:
                                                          TextInputType.number,
                                                      controller:
                                                          TextEditingController(
                                                        text:
                                                            "${entry.key + _startingSerialNum}",
                                                      ),
                                                      onClick: () {},
                                                      isDisabled: ModalRoute.of(
                                                                  context)!
                                                              .settings
                                                              .name ==
                                                          Routes.VIEW_ENTRY,
                                                    ),
                                                    EntryInputFieldWidget(
                                                      label: "WEIGHT (IN KGS)",
                                                      hasLabel: entry.key +
                                                              _startingSerialNum ==
                                                          _startingSerialNum,
                                                      hasBottomGap: entry.key ==
                                                          _currentEntry
                                                                  .bagCount -
                                                              1,
                                                      controller: entry.value,
                                                      inpType:
                                                          TextInputType.number,
                                                      onClick: () {},
                                                      isDisabled: ModalRoute.of(
                                                                  context)!
                                                              .settings
                                                              .name ==
                                                          Routes.VIEW_ENTRY,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      EntryInputFieldWidget(
                                        label: "TOTAL WEIGHT (IN KGS)",
                                        isBig: true,
                                        controller: _totalWeightController,
                                        isDisabled: true,
                                        onClick: () {},
                                      ),
                                      EntryInputFieldWidget(
                                        label: "LESS TARE",
                                        isBig: true,
                                        controller: _lessTareController,
                                        isDisabled: true,
                                        onClick: () {},
                                      ),
                                      EntryInputFieldWidget(
                                        label: "NET WEIGHT (IN KGS)",
                                        isBig: true,
                                        controller: _netWeightController,
                                        isDisabled: true,
                                        onClick: () {},
                                      ),
                                      ActionButtonWidget(
                                        label: "Save",
                                        onClick: () {
                                          _entryBloc.add(
                                            InitEntrySaveEvent(
                                              saveFunc: () =>
                                                  sl<EntryRepository>()
                                                      .saveEntry(
                                                entry: _getCurrentEntry(),
                                              ),
                                              isFinalSave: true,
                                            ),
                                          );
                                        },
                                        widthPercen: 0.9,
                                        isLoading: _isSaving,
                                        isDisabled: ModalRoute.of(context)!
                                                .settings
                                                .name ==
                                            Routes.VIEW_ENTRY,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 25.0),
                          ],
                        ),
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
          ),
        ),
      ),
    );
  }
}

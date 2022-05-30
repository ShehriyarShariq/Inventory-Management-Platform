import 'package:flutter/material.dart';
import '../../data/models/chilli.dart';
import '../../data/models/party.dart';

class EntryDropdownFieldWidget extends StatelessWidget {
  final String label, type;
  final bool hasLabel, isBig, hasBottomGap, isDisabled;
  final List<dynamic> dropdownOptions;
  final Function onDropdownOptionChanged;
  final dynamic selectedDropdownOption;

  const EntryDropdownFieldWidget({
    Key? key,
    this.label = "",
    this.hasLabel = true,
    this.isBig = false,
    this.hasBottomGap = true,
    this.isDisabled = false,
    required this.type,
    required this.dropdownOptions,
    required this.selectedDropdownOption,
    required this.onDropdownOptionChanged,
  }) : super(key: key);

  String _getLabel(option) {
    switch (type) {
      case "party":
        return (option as Party).name;
      case "chilli":
        return (option as Chilli).label;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasLabel
            ? Padding(
                padding: const EdgeInsets.only(
                  bottom: 3.0,
                  left: 5.0,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox(),
        Container(
          width: isBig
              ? MediaQuery.of(context).size.width * 0.9
              : MediaQuery.of(context).size.width * 0.42,
          height: MediaQuery.of(context).size.width * 0.9 * 0.17,
          margin: EdgeInsets.only(bottom: hasBottomGap ? 20.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.9 * 0.17 * 0.25),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 4),
                blurRadius: 4,
              )
            ],
            color: const Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(
              color: const Color.fromRGBO(238, 38, 49, 1),
            ),
          ),
          alignment: Alignment.center,
          child: FormField<String>(
            enabled: !isDisabled,
            builder: (FormFieldState<dynamic> state) {
              return InputDecorator(
                decoration: const InputDecoration(
                  hintText: "",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(0),
                ),
                isEmpty: _getLabel(selectedDropdownOption) == "",
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<dynamic>(
                    value: selectedDropdownOption ?? "",
                    isDense: true,
                    onChanged: (newValue) => onDropdownOptionChanged(newValue),
                    items: isDisabled
                        ? [
                            DropdownMenuItem(
                              value: selectedDropdownOption,
                              enabled: !isDisabled,
                              child: Text(
                                _getLabel(selectedDropdownOption),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ]
                        : dropdownOptions
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                enabled: !isDisabled,
                                child: Text(
                                  _getLabel(option),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

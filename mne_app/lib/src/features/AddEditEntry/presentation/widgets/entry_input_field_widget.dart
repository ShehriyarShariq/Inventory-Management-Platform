import 'package:flutter/material.dart';

class EntryInputFieldWidget extends StatelessWidget {
  final String label, iconType;
  final TextInputType inpType;
  final bool hasLabel, isBig, hasBottomGap, isDisabled;
  final TextEditingController controller;
  final Function onClick;

  const EntryInputFieldWidget({
    Key? key,
    this.label = "",
    this.hasLabel = true,
    this.isBig = false,
    this.hasBottomGap = true,
    this.isDisabled = false,
    this.iconType = "",
    this.inpType = TextInputType.text,
    required this.controller,
    required this.onClick,
  }) : super(key: key);

  dynamic _getIconFromType() {
    if (iconType == "date") {
      return Icons.access_time;
    }

    return null;
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
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : const SizedBox(),
        GestureDetector(
          onTap: () => onClick(),
          child: Container(
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
            child: Row(
              children: [
                Expanded(
                  child: isDisabled
                      ? Text(
                          controller.text,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : TextField(
                          controller: controller,
                          keyboardType: inpType,
                          textInputAction: TextInputAction.next,
                          readOnly: isDisabled,
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          // enabled: !isDisabled,
                        ),
                ),
                _getIconFromType() != null
                    ? Row(
                        children: [
                          const SizedBox(width: 10),
                          Icon(
                            _getIconFromType(),
                            color: const Color.fromRGBO(238, 38, 49, 1),
                          )
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

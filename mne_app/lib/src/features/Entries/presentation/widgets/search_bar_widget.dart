import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final bool hasFilterBtn, isFilterVisible;
  final TextEditingController controller;
  final Function showFilters;

  const SearchBarWidget({
    Key? key,
    this.hasFilterBtn = false,
    required this.controller,
    required this.showFilters,
    this.isFilterVisible = false,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  List<bool> _filterSelected = [false];

  @override
  Widget build(BuildContext context) {
    _filterSelected = [widget.isFilterVisible];
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.9 * 0.14,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.width * 0.9 * 0.14,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(242, 243, 242, 1),
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.9 * 0.14 * 0.3,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.9 * 0.04,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color.fromRGBO(238, 38, 49, 1),
                    size: 26.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9 * 0.05,
                  ),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search",
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(124, 124, 124, 1),
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: widget.hasFilterBtn ? 10 : 0,
          ),
          widget.hasFilterBtn
              ? ToggleButtons(
                  children: [
                    Icon(
                      !_filterSelected[0]
                          ? Icons.filter_alt_outlined
                          : Icons.filter_alt_rounded,
                    ),
                  ],
                  isSelected: _filterSelected,
                  onPressed: (index) {
                    widget.showFilters();
                    setState(() {
                      _filterSelected[index] = !_filterSelected[index];
                    });
                  },
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

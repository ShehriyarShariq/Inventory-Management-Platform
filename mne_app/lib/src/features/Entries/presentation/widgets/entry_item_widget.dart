import 'package:flutter/material.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/features/AddEditEntry/data/models/entry.dart';
import 'package:intl/intl.dart';

class EntryItemWidget extends StatelessWidget {
  final Entry entry;
  final bool isViewOnly;
  final Function onTap;

  const EntryItemWidget({
    Key? key,
    required this.entry,
    this.isViewOnly = false,
    required this.onTap,
  }) : super(key: key);

  Widget _getDataRow(context, {icon, label}) {
    return Wrap(
      children: [
        Row(
          children: [
            Image.asset(
              icon,
              width: MediaQuery.of(context).size.width * 0.067,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9 * 0.43 * 0.05,
            ),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  String _getFormattedDate(date) {
    return DateFormat("dd/MM/yyyy, hh:mm ").format(date) +
        ((date as DateTime).hour > 12 ? "PM" : "AM");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.width * 0.9 * 0.43,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.9 * 0.43 * 0.1),
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
      child: Material(
        borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.9 * 0.43 * 0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.9 * 0.43 * 0.1),
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.9 * 0.03,
              top: MediaQuery.of(context).size.width * 0.9 * 0.03,
              bottom: MediaQuery.of(context).size.width * 0.9 * 0.43 * 0.03,
              right: MediaQuery.of(context).size.width * 0.9 * 0.05,
            ),
            child: Row(children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getDataRow(
                      context,
                      icon: "assets/images/calendar_icon.png",
                      label: "Date: ${_getFormattedDate(entry.date)}",
                    ),
                    _getDataRow(
                      context,
                      icon: "assets/images/profile_icon.png",
                      label: "Party Name: ${entry.party.name}",
                    ),
                    _getDataRow(
                      context,
                      icon: "assets/images/ticket_icon.png",
                      label: "SL. No. ${entry.serialNum}",
                    ),
                    _getDataRow(
                      context,
                      icon: "assets/images/bag_icon.png",
                      label: "No. Of Bags: ${entry.bagCount}",
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    isViewOnly
                        ? "assets/images/view_icon.png"
                        : "assets/images/edit_icon.png",
                    width: MediaQuery.of(context).size.width * 0.067,
                  ),
                  Image.asset(
                    "assets/images/arrow_right_icon.png",
                    width: MediaQuery.of(context).size.width * 0.067,
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

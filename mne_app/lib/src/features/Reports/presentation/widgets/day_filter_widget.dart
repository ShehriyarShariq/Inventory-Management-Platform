import 'package:flutter/material.dart';

class DayFilterWidget extends StatelessWidget {
  final bool isActive, hasBorder;
  final String label;
  final Function onClick;

  const DayFilterWidget({
    Key? key,
    this.hasBorder = true,
    required this.isActive,
    required this.label,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(238, 38, 49, 1)
              : Colors.transparent,
          border: Border.all(
            width: hasBorder ? 1 : 0,
            color: hasBorder
                ? isActive
                    ? const Color.fromRGBO(238, 38, 49, 1)
                    : const Color.fromRGBO(3, 3, 3, 1)
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
            color: isActive ? Colors.white : const Color.fromRGBO(0, 0, 0, 1),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String imagePath, label;
  final bool isFirst;
  final Function onClick;

  const MenuItemWidget({
    Key? key,
    required this.imagePath,
    required this.label,
    this.isFirst = false,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onClick(),
        child: Container(
          height: 65,
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.01,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              top: isFirst
                  ? const BorderSide(
                      color: Color.fromRGBO(226, 226, 226, 1),
                    )
                  : BorderSide.none,
              bottom: const BorderSide(
                color: Color.fromRGBO(226, 226, 226, 1),
              ),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 25,
                height: 25,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(24, 23, 37, 1),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color.fromRGBO(24, 23, 37, 1),
                size: 32.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

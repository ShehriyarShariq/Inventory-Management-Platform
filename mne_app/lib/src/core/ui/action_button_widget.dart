import 'package:flutter/material.dart';

class ActionButtonWidget extends StatelessWidget {
  final String label;
  final Function onClick;
  final num widthPercen;
  final bool isLoading, isDisabled;

  const ActionButtonWidget({
    Key? key,
    required this.label,
    required this.onClick,
    this.widthPercen = 0.86,
    this.isLoading = false,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator ButtonWidget - COMPONENT
    return Material(
      borderRadius: BorderRadius.circular(
        MediaQuery.of(context).size.width * widthPercen * 0.19 * 0.25,
      ),
      color: Color.fromRGBO(238, 38, 49, isDisabled ? 0.6 : 1),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * widthPercen * 0.19 * 0.25,
        ),
        onTap: () {
          if (!isDisabled) {
            onClick();
          }
        },
        splashFactory:
            isDisabled ? NoSplash.splashFactory : InkRipple.splashFactory,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * widthPercen,
          height: MediaQuery.of(context).size.width * widthPercen * 0.19,
          child: Center(
            child: !isLoading || isDisabled
                ? Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 249, 255, 1),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}

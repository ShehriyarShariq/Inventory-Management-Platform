import 'package:flutter/material.dart';

class HomeOptionWidget extends StatelessWidget {
  final Color bgColor;
  final String label, labelValue;
  final Function onClick;
  final bool isLoading;

  const HomeOptionWidget({
    Key? key,
    required this.bgColor,
    required this.onClick,
    required this.label,
    this.isLoading = false,
    this.labelValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: bgColor,
      child: InkWell(
        onTap: () => onClick(),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.81,
          height: MediaQuery.of(context).size.width * 0.81 * 0.35,
          child: Stack(children: [
            Positioned(
              right: -MediaQuery.of(context).size.width * 0.81 * 0.09,
              top: 0,
              bottom: 0,
              width: MediaQuery.of(context).size.width * 0.81 * 0.4,
              child: Image.asset("assets/images/home_option_design.png"),
            ),
            Positioned(
              right: -MediaQuery.of(context).size.width * 0.81 * 0.05,
              bottom: -25,
              width: MediaQuery.of(context).size.width * 0.81 * 0.5,
              child: Opacity(
                opacity: 1,
                child: Image.asset("assets/images/home_option_design_alt.png"),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.81 * 0.09,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isLoading
                            ? MainAxisAlignment.spaceEvenly
                            : labelValue != ""
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          isLoading
                              ? Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.81 *
                                      0.05,
                                  height: MediaQuery.of(context).size.width *
                                      0.81 *
                                      0.05,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : labelValue != ""
                                  ? Text(
                                      labelValue,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox(height: 0),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

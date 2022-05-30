import 'package:flutter/material.dart';

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.6),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

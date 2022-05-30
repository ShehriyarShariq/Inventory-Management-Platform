import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../core/utils/firebase.dart';
import '../../../../core/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      if (FirebaseInit.auth.currentUser != null) {
        Navigator.pushReplacementNamed(context, Routes.HOME);
      } else {
        Navigator.pushReplacementNamed(context, Routes.AUTH);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              right: 0,
              left: 0,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset("assets/images/chillies_bg.png"),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                child: Container(
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: MediaQuery.of(context).size.width * 0.12,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Image.asset("assets/images/chillies.png"),
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.58,
                child: Hero(
                  tag: "logo",
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

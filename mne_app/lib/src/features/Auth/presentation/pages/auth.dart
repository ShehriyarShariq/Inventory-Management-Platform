import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../core/ui/action_button_widget.dart';
import '../../../../core/utils/constants.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
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
                          color: Colors.white.withOpacity(0.9),
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.07,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 46.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.47,
                      height: MediaQuery.of(context).size.width * 0.47 * 0.56,
                      child: Hero(
                        tag: "logo",
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Add all the orders from the customer in the app",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ActionButtonWidget(
                      label: "Get Started",
                      onClick: () => Navigator.pushNamed(context, Routes.LOGIN),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

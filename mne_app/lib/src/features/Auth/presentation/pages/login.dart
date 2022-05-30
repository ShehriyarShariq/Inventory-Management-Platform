import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../injection_container.dart';
import '../../data/models/credentials_model.dart';
import '../../domain/respositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/ui/action_button_widget.dart';
import '../../../../core/utils/constants.dart';
import '../widgets/input_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(),
      _password = TextEditingController();

  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    _authBloc = sl<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is LoggedIn) {
            Navigator.pushNamed(context, Routes.HOME);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.6,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: MediaQuery.of(context).size.width * 0.15,
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Image.asset(
                                      "assets/images/chillies_bg.png"),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 30.0, sigmaY: 30.0),
                                child: Container(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: MediaQuery.of(context).size.width *
                                    0.47 *
                                    0.56,
                                child: Hero(
                                  tag: "logo",
                                  child: Image.asset("assets/images/logo.png"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.07,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontSize: 26.0,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Enter your username and password",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Color.fromRGBO(124, 124, 124, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  InputFieldWidget(
                                    label: "Email",
                                    type: "email",
                                    controller: _email,
                                  ),
                                  const SizedBox(height: 20),
                                  InputFieldWidget(
                                    label: "Password",
                                    type: "password",
                                    hasActionButton: true,
                                    controller: _password,
                                  ),
                                  const SizedBox(height: 60),
                                  Center(
                                    child: ActionButtonWidget(
                                      label: "Log In",
                                      onClick: () {
                                        String emailVal = _email.text.trim();
                                        String passwordVal =
                                            _password.text.trim();

                                        if (emailVal.isNotEmpty &&
                                            passwordVal.isNotEmpty) {
                                          _authBloc.add(
                                            LoginWithCredentialsEvent(
                                              func: () => sl<AuthRepository>()
                                                  .signInWithCredentials(
                                                CredentialsModel(
                                                    email: emailVal,
                                                    password: passwordVal),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/auth_footer_bg.png"),
                                    alignment: Alignment.bottomCenter,
                                  ),
                                ),
                                child: ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 16.0, sigmaY: 16.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

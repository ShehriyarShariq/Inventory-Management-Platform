import 'package:flutter/material.dart';
import 'package:mne_app/src/core/utils/constants.dart';
import 'package:mne_app/src/features/Auth/domain/respositories/auth_repository.dart';

import '../../../injection_container.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator ButtonWidget - COMPONENT
    return Material(
      borderRadius: BorderRadius.circular(
        MediaQuery.of(context).size.width * 0.86 * 0.19 * 0.25,
      ),
      color: const Color.fromRGBO(242, 243, 242, 1),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.86 * 0.19 * 0.25,
        ),
        onTap: () async {
          await sl<AuthRepository>().logoutUser();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.AUTH,
            ModalRoute.withName('/'),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.86,
          height: MediaQuery.of(context).size.width * 0.86 * 0.19,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: MediaQuery.of(context).size.width * 0.05,
                child: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(83, 177, 117, 1),
                ),
              ),
              const Center(
                child: Text(
                  "Log Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(83, 177, 117, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

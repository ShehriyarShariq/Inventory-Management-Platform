import 'package:flutter/material.dart';
import 'package:mne_app/injection_container.dart';
import 'package:mne_app/src/core/utils/firebase.dart';
import 'package:mne_app/src/features/Auth/domain/respositories/auth_repository.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/ui/logout_button_widget.dart';
import '../../../../core/ui/top_bar_widget.dart';
import '../widgets/menu_item_widget.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopBarWidget(
        isBack: true,
        onClick: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.15,
                      ),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: FadeInImage(
                          placeholder:
                              const AssetImage("assets/images/user.png"),
                          image: FirebaseInit.auth.currentUser!.photoURL != null
                              ? Image.network(
                                      FirebaseInit.auth.currentUser!.photoURL ??
                                          Constants.PROFILE_IMAGE_DEFAULT)
                                  .image
                              : Image.asset("assets/images/user.png").image,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FirebaseInit.auth.currentUser?.displayName ?? "Guest",
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(24, 23, 37, 1),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          FirebaseInit.auth.currentUser!.email ??
                              "guest@mwb.com",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(124, 124, 124, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  children: [
                    MenuItemWidget(
                      imagePath: "assets/images/home_icon.png",
                      label: "Home",
                      isFirst: true,
                      onClick: () => Navigator.pop(context),
                    ),
                    MenuItemWidget(
                      imagePath: "assets/images/my_details_icon.png",
                      label: "My Details",
                      onClick: () =>
                          Navigator.pushNamed(context, Routes.PROFILE),
                    ),
                    MenuItemWidget(
                      imagePath: "assets/images/help_icon.png",
                      label: "Help",
                      onClick: () => Navigator.pushNamed(context, Routes.HELP),
                    ),
                    MenuItemWidget(
                      imagePath: "assets/images/about_icon.png",
                      label: "About",
                      onClick: () => Navigator.pushNamed(context, Routes.ABOUT),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ListView.builder(
                            itemCount: (constraints.maxHeight / 60).floor() - 1,
                            itemBuilder: (context, index) => Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(226, 226, 226, 1),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            LogoutButtonWidget(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
